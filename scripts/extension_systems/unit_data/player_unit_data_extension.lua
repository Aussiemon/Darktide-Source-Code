local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerHuskDataComponentConfig = require("scripts/extension_systems/unit_data/player_husk_data_component_config")
local PlayerHuskHudDataComponentConfig = require("scripts/extension_systems/unit_data/player_husk_hud_data_component_config")
local PlayerUnitDataComponentConfig = require("scripts/extension_systems/unit_data/player_unit_data_component_config")
local UnitDataComponentConfigFormatter = require("scripts/extension_systems/unit_data/unit_data_component_config_formatter")
local PlayerUnitDataExtension = class("PlayerUnitDataExtension")
local FORMATTED_CONFIG, FIELD_NETWORK_LOOKUP, FORMATTED_HUSK_CONFIG, FORMATTED_HUSK_HUD_CONFIG = UnitDataComponentConfigFormatter.format(PlayerUnitDataComponentConfig, "server_unit_data_state", PlayerHuskDataComponentConfig, "server_husk_data_state", PlayerHuskHudDataComponentConfig, "server_husk_hud_data_state")
local NUMBER_NETWORK_TYPE_TOLERANCES = {
	weapon_sway_offset = 0.01,
	weapon_sway = 0.01,
	weapon_view_lock = 0.01,
	weapon_spread = 0.01,
	warp_charge_ramping_modifier = 0.01,
	default = 0.001,
	projectile_speed = 0.1,
	stamina_fraction = 0.01,
	recoil_angle = 0.01,
	character_height = 0.01,
	action_time_scale = 0.01
}
local VECTOR3_NETWORK_TYPE_TOLERANCES = {
	high_precision_velocity = 1e-05,
	Vector3 = 0.001,
	high_precision_direction = 1e-05
}
local FIXED_FRAME_OFFSET_NETWORK_TYPES = {
	fixed_frame_offset = true,
	fixed_frame_offset_start_t_7bit = true,
	fixed_frame_offset_small = true,
	fixed_frame_offset_start_t_6bit = true,
	fixed_frame_offset_end_t_4bit = true,
	fixed_frame_offset_end_t_6bit = true,
	fixed_frame_offset_end_t_7bit = true
}
local NUM_FIELDS = #FIELD_NETWORK_LOOKUP
local FRAME_INDEX_FIELD = "frame_index"
local REMAINDER_TIME_FIELD = "remainder_time"
local FRAME_TIME_FIELD = "frame_time"
local HAD_RECEIVED_INPUT_FIELD = "had_received_input"
local QUATERNION_TOLERANCE = math.cos(math.pi / 64)
local STATE_CACHE_SIZE = 60

local function debug(...)
	Log.debug("PlayerUnitDataExtension", ...)
end

local function info(...)
	Log.info("PlayerUnitDataExtension", ...)
end

local function mispredict_info(...)
	if DevParameters.log_mispredicts then
		Log.info("PlayerUnitDataExtension", ...)
	end
end

local RPCS = {}

local function _populate_component(fields, component)
	for field_name, data in pairs(fields) do
		local type = data.type

		if type == "Vector3" then
			component[field_name] = Vector3Box(Vector3.invalid_vector())
		elseif type == "Quaternion" then
			component[field_name] = QuaternionBox(Quaternion.from_elements(math.huge, math.huge, math.huge, math.huge))
		end
	end
end

PlayerUnitDataExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._unit = unit
	self._player = extension_init_data.player
	self._player_peer = self._player:peer_id()
	self._fixed_time_step = GameParameters.fixed_time_step
	self.is_resimulating = false
	local component_config = FORMATTED_CONFIG
	local components = {}
	local rollback_components = {}

	for config_name, fields in pairs(component_config) do
		local cache = {}

		for i = 1, STATE_CACHE_SIZE do
			local component = {}

			_populate_component(fields, component)

			cache[i] = component
		end

		components[config_name] = cache
		local rollback_component = {}

		_populate_component(fields, rollback_component)

		rollback_components[config_name] = rollback_component
	end

	self._rollback_components = rollback_components
	local fixed_frame = extension_init_context.fixed_frame
	local next_frame = fixed_frame + 1
	local i = (next_frame - 1) % STATE_CACHE_SIZE + 1
	self._component_index = i
	self._last_component_index = i
	self._last_fixed_frame = fixed_frame
	self._last_fixed_t = fixed_frame * GameParameters.fixed_time_step
	local is_server = extension_init_context.is_server

	if not is_server then
		local game_object_id = nil_or_game_object_id
		local network_event_delegate = extension_init_context.network_event_delegate

		network_event_delegate:register_session_unit_events(self, game_object_id, unpack(RPCS))

		self._network_event_delegate = network_event_delegate
		self._game_object_id = game_object_id
		self._last_received_frame = -1
		self._game_session = game_object_data_or_game_session
	end

	self._is_server = is_server
	local is_local_unit = extension_init_data.is_local_unit

	if not is_local_unit then
		self._sent_component_index = i
		local owner = extension_init_data.player
		self._owner_peer = owner:peer_id()
		self._owner_channel = owner:channel_id()
	end

	self._is_local_unit = is_local_unit
	self._components = components
	self._component_config = component_config
	self._components.movement_settings[i].player_speed_scale = 1
	self._component_blackboard = {
		index = i
	}
	local breed = extension_init_data.breed
	self._breed = breed
	local archetype = extension_init_data.archetype

	fassert(archetype, "No archetype passed to PlayerUnitDataExtension!")

	self._archetype = archetype
	self._hit_zone_lookup, self._hit_zone_actors_lookup = HitZone.initialize_lookup(unit, breed.hit_zones)
	self._write_components = {}
	self._read_components = {}

	for component_name, _ in pairs(self._components) do
		self._read_components[component_name] = self:_create_read_component(component_name)
		self._write_components[component_name] = self:_create_write_component(component_name)
	end

	if not is_server then
		self._game_object_return_table = Script.new_map(NUM_FIELDS)
	end

	self._network_max_time_offset = NetworkConstants.max_time_offset
end

PlayerUnitDataExtension.game_object_initialized = function (self, session, object_id)
	assert(session and object_id)

	self._game_session = session
	self._game_object_id = object_id
	local last_fixed_frame = self._last_fixed_frame
	local go_data_table = {}
	local husk_go_data_table = {}
	local husk_hud_go_data_table = {}

	for i = 1, NUM_FIELDS do
		local field = FIELD_NETWORK_LOOKUP[i]
		local component_name = field[1]
		local field_name = field[2]
		local type = field[3]
		local network_name = field[4]
		local network_type = field[5]
		local lookup = field[6]
		local value = self._components[component_name][self._component_index][field_name]
		local actual_value = nil

		if type == "Vector3" or type == "Quaternion" then
			actual_value = value:unbox()
		elseif type == "string" then
			local lookup_index = lookup[value]

			if not lookup_index then
				table.dump(lookup)
				ferror("Value %q does not exist in lookup for %s:%s(%s)", value, component_name, field_name, type)
			end

			actual_value = lookup_index
		elseif network_type == "fixed_frame_time" then
			local frame = math.round(value / self._fixed_time_step)
			actual_value = frame
		elseif FIXED_FRAME_OFFSET_NETWORK_TYPES[network_type] then
			local type_info = NetworkConstants[network_type]
			local min_value = type_info.min
			local frame = math.max(math.round(value / self._fixed_time_step) - last_fixed_frame, min_value)
			actual_value = frame
		else
			actual_value = value
		end

		go_data_table[network_name] = actual_value
		local husk_config = FORMATTED_HUSK_CONFIG[component_name]
		local sync_to_husk = husk_config and husk_config[field_name]

		if sync_to_husk then
			husk_go_data_table[network_name] = actual_value
		end

		local husk_hud_config = FORMATTED_HUSK_HUD_CONFIG[component_name]
		local sync_to_husk_hud = husk_hud_config and husk_hud_config[field_name]

		if sync_to_husk_hud then
			husk_hud_go_data_table[network_name] = actual_value
		end
	end

	if not self._is_local_unit then
		go_data_table[FRAME_INDEX_FIELD] = last_fixed_frame
		go_data_table.game_object_type = NetworkLookup.game_object_types.server_unit_data_state
		go_data_table.unit_game_object_id = object_id
		local action_input_network_data = self._action_input_extension:network_data()

		for game_object_field_name, lookup_id_array in pairs(action_input_network_data) do
			go_data_table[game_object_field_name] = lookup_id_array
		end

		self._server_data_state_game_object_id = GameSession.create_game_object(session, "server_unit_data_state", go_data_table, self._player_peer)
	end

	husk_go_data_table.game_object_type = NetworkLookup.game_object_types.server_husk_data_state
	husk_go_data_table.unit_game_object_id = object_id
	husk_go_data_table[FRAME_INDEX_FIELD] = last_fixed_frame
	self._server_husk_data_state_game_object_id = GameSession.create_game_object(session, "server_husk_data_state", husk_go_data_table)
	husk_hud_go_data_table.game_object_type = NetworkLookup.game_object_types.server_husk_hud_data_state
	husk_hud_go_data_table.unit_game_object_id = object_id
	self._server_husk_hud_data_state_game_object_id = GameSession.create_game_object(session, "server_husk_hud_data_state", husk_hud_go_data_table)
end

PlayerUnitDataExtension.on_server_data_state_game_object_created = function (self, session, game_object_id)
	self._server_data_state_game_object_id = game_object_id
end

local USERDATA_REPLACEMENT = {}

PlayerUnitDataExtension.extensions_ready = function (self, world, unit)
	local game_object_return_table_or_nil = self._game_object_return_table

	for component_name, component_config in pairs(self._component_config) do
		local component = self._components[component_name][self._component_index]

		for field_name, data in pairs(component_config) do
			local value = component[field_name]
			local field_type = data.type
			local go_return_init_value = nil

			if field_type == "Vector3" then
				fassert(Vector3.is_valid(value:unbox()), "Value in field %q with type %q not initialized with a valid value before extensions_ready()", field_name, field_type)

				go_return_init_value = USERDATA_REPLACEMENT
			elseif field_type == "Quaternion" then
				fassert(Quaternion.is_valid(value:unbox()), "Value in field %q with type %q not initialized with a valid value before extensions_ready()", field_name, field_type)

				go_return_init_value = USERDATA_REPLACEMENT
			else
				fassert(value ~= nil, "Value in field %q with type %q not set with a non-nil value by extensions_ready()", field_name, field_type)

				go_return_init_value = value
			end

			if game_object_return_table_or_nil then
				fassert(go_return_init_value ~= nil, "No init value for game object return table for component_name %q field_name %q", component_name, field_name)

				local lookup_index = data.lookup_index
				local field = FIELD_NETWORK_LOOKUP[lookup_index]
				local network_name = field[4]
				game_object_return_table_or_nil[network_name] = go_return_init_value
			end
		end
	end

	self._action_input_extension = ScriptUnit.extension(unit, "action_input_system")
	self._input_extension = ScriptUnit.extension(unit, "input_system")
end

local READ_ONLY_META = {
	__index = function (t, field_name)
		local field = rawget(t, "__config")[field_name]

		fassert(field ~= nil, "Trying to get field %q that doesn't exist in component %q", field_name, rawget(t, "__name"))

		local data_type = field.type
		local data = rawget(t, "__data")[rawget(t, "__blackboard").index][field_name]

		if data_type == "Vector3" or data_type == "Quaternion" then
			return data:unbox()
		elseif data_type == "Unit" then
			if data == -1 then
				return nil
			elseif data > 65535 then
				return Managers.state.unit_spawner:unit(data - 65535, true)
			else
				return Managers.state.unit_spawner:unit(data, false)
			end
		elseif data_type == "hit_zone_actor_index" then
			if data == NetworkConstants.invalid_hit_zone_actor_index then
				return nil
			else
				return data
			end
		elseif data_type == "prd_state" then
			if data == -1 then
				return nil
			else
				return data
			end
		else
			return data
		end
	end,
	__newindex = function (t, field_name, value)
		ferror("Trying to write to %q in read only component %q", field_name, rawget(t, "__name"))
	end
}

PlayerUnitDataExtension._create_read_component = function (self, component_name)
	local config = self._component_config[component_name]

	fassert(config, "PlayerUnitDataExtension component %q does not exist.", component_name)

	local component = {
		__data = self._components[component_name],
		__blackboard = self._component_blackboard,
		__config = config,
		__name = component_name
	}

	setmetatable(component, READ_ONLY_META)

	return component
end

PlayerUnitDataExtension.has_component = function (self, component_name)
	return self._read_components[component_name] ~= nil
end

PlayerUnitDataExtension.read_component = function (self, component_name)
	return self._read_components[component_name]
end

local WRITE_META = {
	__index = READ_ONLY_META.__index,
	__newindex = function (t, field_name, value)
		local field = rawget(t, "__config")[field_name]

		fassert(field ~= nil, "Trying to get field %q that doesn't exist in component %q", field_name, rawget(t, "__name"))

		local data_type = field.type
		local data = rawget(t, "__data")

		if data_type == "Vector3" or data_type == "Quaternion" then
			data[rawget(t, "__blackboard").index][field_name]:store(value)
		elseif data_type == "Unit" then
			if value == nil then
				data[rawget(t, "__blackboard").index][field_name] = -1
			else
				local is_level_index, id = Managers.state.unit_spawner:game_object_id_or_level_index(value)

				fassert(id, "Unit %q in PlayerUnitDataExtension field %s does not have a game object id or level index", value, field_name)

				if is_level_index then
					data[rawget(t, "__blackboard").index][field_name] = id + 65535
				else
					data[rawget(t, "__blackboard").index][field_name] = id
				end
			end
		elseif data_type == "hit_zone_actor_index" then
			if value == nil then
				data[rawget(t, "__blackboard").index][field_name] = NetworkConstants.invalid_hit_zone_actor_index
			else
				fassert(value ~= NetworkConstants.invalid_hit_zone_actor_index, "Field %q with type %q is set to NetworkConstants.invalid_hit_zone_actor_index (%f)", field_name, field.field_network_type, NetworkConstants.invalid_hit_zone_actor_index)

				data[rawget(t, "__blackboard").index][field_name] = value
			end
		elseif data_type == "prd_state" then
			if value == nil then
				data[rawget(t, "__blackboard").index][field_name] = -1
			else
				data[rawget(t, "__blackboard").index][field_name] = value
			end
		else
			data[rawget(t, "__blackboard").index][field_name] = value
		end
	end
}

PlayerUnitDataExtension.write_component = function (self, component_name)
	return self._write_components[component_name]
end

PlayerUnitDataExtension._create_write_component = function (self, component_name)
	local config = self._component_config[component_name]

	fassert(config, "PlayerUnitDataExtension component %q does not exist.", component_name)

	local component = {
		__data = self._components[component_name],
		__blackboard = self._component_blackboard,
		__config = config,
		__name = component_name
	}

	setmetatable(component, WRITE_META)

	return component
end

PlayerUnitDataExtension.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(RPCS))
	else
		GameSession.destroy_game_object(self._game_session, self._server_husk_hud_data_state_game_object_id)
		GameSession.destroy_game_object(self._game_session, self._server_husk_data_state_game_object_id)

		if self._server_data_state_game_object_id then
			GameSession.destroy_game_object(self._game_session, self._server_data_state_game_object_id)
		end
	end
end

PlayerUnitDataExtension.breed = function (self)
	return self._breed
end

PlayerUnitDataExtension.breed_name = function (self)
	local breed = self._breed
	local breed_name = breed.name

	return breed_name
end

PlayerUnitDataExtension.archetype = function (self)
	return self._archetype
end

PlayerUnitDataExtension.archetype_name = function (self)
	local archetype = self._archetype
	local archetype_name = archetype.name

	return archetype_name
end

PlayerUnitDataExtension.hit_zone = function (self, actor)
	return self._hit_zone_lookup[actor]
end

PlayerUnitDataExtension.hit_zone_actors = function (self, hit_zone_name)
	return self._hit_zone_actors_lookup[hit_zone_name]
end

PlayerUnitDataExtension.is_owned_by_death_manager = function (self)
	return false
end

PlayerUnitDataExtension.last_received_fixed_frame = function (self)
	return self._last_received_frame
end

PlayerUnitDataExtension.last_fixed_frame = function (self)
	return self._last_fixed_frame
end

PlayerUnitDataExtension.is_local_unit = function (self)
	return self._is_local_unit
end

PlayerUnitDataExtension.pre_update = function (self, dt, t)
	if self._is_server then
		return
	end

	self:_read_server_unit_data_state()
end

PlayerUnitDataExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	local old_index = self._component_index
	local next_frame = fixed_frame + 1
	local new_index = (next_frame - 1) % STATE_CACHE_SIZE + 1
	self._component_blackboard.index = new_index
	self._component_index = new_index
	self._last_fixed_frame = fixed_frame
	self._last_fixed_t = t
	self._last_component_index = old_index

	Profiler.start("copying cache")

	local components = self._components

	self:_copy_components(components, old_index, new_index)
	Profiler.stop("copying cache")
end

PlayerUnitDataExtension._copy_components = function (self, components, from, to)
	for component_name, component_cache in pairs(components) do
		local old_component = component_cache[from]
		local new_component = component_cache[to]

		for field_name, value in pairs(old_component) do
			if type(value) == "userdata" then
				new_component[field_name]:store(value:unbox())
			else
				new_component[field_name] = value
			end
		end
	end
end

local SERVER_DATA_TEMP = {}
local SERVER_HUSK_DATA_TEMP = {}
local SERVER_HUSK_HUD_DATA_TEMP = {}
local math_round = math.round
local math_min = math.min
local math_max = math.max
local vector3_unbox = Vector3Box.unbox
local quaternion_unbox = QuaternionBox.unbox

PlayerUnitDataExtension.post_update = function (self, unit, dt, t)
	if not self._is_server then
		return
	end

	local sync_server_state = not self._is_local_unit
	local server_data_state_game_object_id = self._server_data_state_game_object_id
	local server_husk_data_state_game_object_id = self._server_husk_data_state_game_object_id
	local server_husk_hud_state_game_object_id = self._server_husk_hud_data_state_game_object_id
	local game_session = self._game_session
	local set_fields = GameSession.set_game_object_fields
	local index = self._last_component_index

	if index ~= self._sent_component_index then
		local components = self._components
		local fixed_time_step = self._fixed_time_step
		local last_fixed_frame = self._last_fixed_frame
		local network_constants = NetworkConstants

		for i = 1, NUM_FIELDS do
			local field = FIELD_NETWORK_LOOKUP[i]
			local component_name = field[1]
			local field_name = field[2]
			local type = field[3]
			local network_name = field[4]
			local network_type = field[5]
			local lookup = field[6]
			local value = components[component_name][index][field_name]
			local value_to_be_synced = nil

			if type == "Vector3" then
				value_to_be_synced = vector3_unbox(value)
			elseif type == "Quaternion" then
				value_to_be_synced = quaternion_unbox(value)
			elseif type == "string" then
				value_to_be_synced = lookup[value]
			elseif FIXED_FRAME_OFFSET_NETWORK_TYPES[network_type] then
				local type_info = network_constants[network_type]
				value_to_be_synced = math_max(math_round(value / fixed_time_step) - last_fixed_frame, type_info.min)

				fassert(value_to_be_synced <= type_info.max, "Trying to send value too far in the future. %s:%s", component_name, field_name)
			elseif network_type == "fixed_frame_time" then
				value_to_be_synced = math_round(value / fixed_time_step)
			else
				value_to_be_synced = value
			end

			if sync_server_state then
				SERVER_DATA_TEMP[network_name] = value_to_be_synced
			end

			local husk_config = FORMATTED_HUSK_CONFIG[component_name]

			if husk_config and husk_config[field_name] then
				SERVER_HUSK_DATA_TEMP[network_name] = value_to_be_synced
			end

			local husk_hud_config = FORMATTED_HUSK_HUD_CONFIG[component_name]

			if husk_hud_config and husk_hud_config[field_name] then
				SERVER_HUSK_HUD_DATA_TEMP[network_name] = value_to_be_synced
			end
		end

		if sync_server_state then
			SERVER_DATA_TEMP[FRAME_INDEX_FIELD] = last_fixed_frame
			local remainder_time = math_min(t - self._last_fixed_t, self._network_max_time_offset)
			SERVER_DATA_TEMP[REMAINDER_TIME_FIELD] = remainder_time
			SERVER_DATA_TEMP[FRAME_TIME_FIELD] = math_min(dt, self._network_max_time_offset)
			SERVER_DATA_TEMP[HAD_RECEIVED_INPUT_FIELD] = self._input_extension:had_received_input(last_fixed_frame)
			local action_input_extension = self._action_input_extension
			local action_input_network_data = action_input_extension:network_data()

			for game_object_field_name, lookup_id_array in pairs(action_input_network_data) do
				SERVER_DATA_TEMP[game_object_field_name] = lookup_id_array
			end

			set_fields(game_session, server_data_state_game_object_id, SERVER_DATA_TEMP)
		end

		SERVER_HUSK_DATA_TEMP[FRAME_INDEX_FIELD] = last_fixed_frame

		set_fields(game_session, server_husk_data_state_game_object_id, SERVER_HUSK_DATA_TEMP)
		set_fields(game_session, server_husk_hud_state_game_object_id, SERVER_HUSK_HUD_DATA_TEMP)

		self._sent_component_index = index
	end
end

local _game_object_field = GameSession.game_object_field
local _vector3_distance_sq = Vector3.distance_squared
local _quaternion_is_valid = Quaternion.is_valid
local _quaternion_dot = Quaternion.dot

PlayerUnitDataExtension._read_server_unit_data_state = function (self)
	local server_data_state_game_object_id = self._server_data_state_game_object_id

	if not server_data_state_game_object_id then
		return
	end

	local game_session = self._game_session
	local frame_index = _game_object_field(game_session, server_data_state_game_object_id, FRAME_INDEX_FIELD)
	local remainder_time = _game_object_field(game_session, server_data_state_game_object_id, REMAINDER_TIME_FIELD)
	local frame_time = _game_object_field(game_session, server_data_state_game_object_id, FRAME_TIME_FIELD)

	if frame_index <= self._last_received_frame then
		return
	elseif self._last_fixed_frame < frame_index then
		self._player.input_handler:frame_parsed(frame_index, remainder_time, frame_time)
		info("Received state package from the future, this is likely because we haven't run any fixed frames yet or had a major stall. Received frame (%i), last frame (%i).", frame_index, self._last_fixed_frame)

		return
	elseif frame_index <= self._last_fixed_frame - STATE_CACHE_SIZE then
		info("Received state package so old it would trash newer entries due to ringbuffer size.")

		return
	end

	local mispredict = false
	local wrapped_frame_index = (frame_index - 1) % STATE_CACHE_SIZE + 1
	local rollback_components = self._rollback_components
	local components = self._components

	Profiler.start("fetching_fields")

	local game_object_return_table = self._game_object_return_table

	GameSession.game_object_fields(game_session, server_data_state_game_object_id, game_object_return_table)
	Profiler.stop("fetching_fields")
	Profiler.start("comparing_fields")

	for i = 1, NUM_FIELDS do
		local field = FIELD_NETWORK_LOOKUP[i]
		local component_name = field[1]
		local field_name = field[2]
		local type = field[3]
		local network_name = field[4]
		local network_type = field[5]
		local lookup = field[6]
		local skip_predict_verification = field[7]
		local authoritative_value = game_object_return_table[network_name]
		local component = components[component_name][wrapped_frame_index]
		local rollback_component = rollback_components[component_name]
		local simulated_value = component[field_name]
		local real_simulated_value, correct = nil
		local default_number_tolerance = NUMBER_NETWORK_TYPE_TOLERANCES.default

		if simulated_value == nil then
			correct = false

			if type == "string" then
				component[field_name] = lookup[authoritative_value]
			elseif type == "number" and FIXED_FRAME_OFFSET_NETWORK_TYPES[network_type] then
				component[field_name] = (authoritative_value + frame_index) * self._fixed_time_step
			elseif type == "number" and network_type == "fixed_frame_time" then
				component[field_name] = authoritative_value * self._fixed_time_step
			else
				component[field_name] = authoritative_value
			end
		elseif type == "Vector3" then
			real_simulated_value = simulated_value:unbox()
			correct = _vector3_distance_sq(real_simulated_value, authoritative_value) < VECTOR3_NETWORK_TYPE_TOLERANCES[network_type]

			simulated_value:store(authoritative_value)
		elseif type == "Quaternion" then
			real_simulated_value = simulated_value:unbox()
			correct = _quaternion_is_valid(real_simulated_value) and QUATERNION_TOLERANCE < math.abs(_quaternion_dot(real_simulated_value, authoritative_value))

			simulated_value:store(authoritative_value)
		elseif type == "string" then
			real_simulated_value = simulated_value
			local local_correct = lookup[real_simulated_value] == authoritative_value
			correct = skip_predict_verification and true or local_correct

			if not local_correct then
				component[field_name] = lookup[authoritative_value]
			end
		elseif type == "number" then
			if FIXED_FRAME_OFFSET_NETWORK_TYPES[network_type] then
				real_simulated_value = math.round(simulated_value / self._fixed_time_step) - frame_index
				local type_info = NetworkConstants[network_type]
				local min_value = type_info.min
				correct = real_simulated_value == authoritative_value or real_simulated_value <= min_value and authoritative_value <= min_value

				if correct then
					component[field_name] = simulated_value
				else
					component[field_name] = (authoritative_value + frame_index) * self._fixed_time_step
				end
			elseif network_type == "fixed_frame_time" then
				real_simulated_value = math.round(simulated_value / self._fixed_time_step)
				correct = real_simulated_value == authoritative_value
				component[field_name] = authoritative_value * self._fixed_time_step
			elseif network_type == "player_anim_time" then
				correct = true
				component[field_name] = authoritative_value
			elseif network_type == "player_anim" then
				correct = true
				component[field_name] = authoritative_value
			elseif network_type == "player_anim_state" then
				correct = true
				component[field_name] = authoritative_value
			else
				correct = math.abs(simulated_value - authoritative_value) < (NUMBER_NETWORK_TYPE_TOLERANCES[network_type] or default_number_tolerance)
				component[field_name] = authoritative_value
			end
		else
			correct = simulated_value == authoritative_value
			component[field_name] = authoritative_value
		end

		rollback_component[field_name] = simulated_value

		if not correct then
			mispredict = true
		end
	end

	Profiler.stop("comparing_fields")

	if mispredict then
		Profiler.start("mispredict")

		local resimulate_from = frame_index + 1
		local wrapped_resimulate_frame_index = (resimulate_from - 1) % STATE_CACHE_SIZE + 1

		self:_copy_components(self._components, wrapped_frame_index, wrapped_resimulate_frame_index)

		self._component_index = wrapped_resimulate_frame_index
		self._component_blackboard.index = wrapped_resimulate_frame_index

		self._action_input_extension:mispredict_happened(frame_index, game_session, server_data_state_game_object_id)

		self.is_resimulating = true

		Managers.state.extension:fixed_update_resimulate_unit(self._unit, resimulate_from, rollback_components)

		self.is_resimulating = false

		Profiler.stop("mispredict")
	end

	self._last_received_frame = frame_index

	self._player.input_handler:frame_parsed(frame_index, remainder_time, frame_time)
end

return PlayerUnitDataExtension
