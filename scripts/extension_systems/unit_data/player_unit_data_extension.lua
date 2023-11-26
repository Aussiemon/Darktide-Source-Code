-- chunkname: @scripts/extension_systems/unit_data/player_unit_data_extension.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerHuskDataComponentConfig = require("scripts/extension_systems/unit_data/player_husk_data_component_config")
local PlayerHuskHudDataComponentConfig = require("scripts/extension_systems/unit_data/player_husk_hud_data_component_config")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitDataComponentConfig = require("scripts/extension_systems/unit_data/player_unit_data_component_config")
local UnitDataComponentConfigFormatter = require("scripts/extension_systems/unit_data/unit_data_component_config_formatter")
local PlayerUnitDataExtension = class("PlayerUnitDataExtension")
local FORMATTED_CONFIG, FIELD_NETWORK_LOOKUP, FORMATTED_HUSK_CONFIG, FORMATTED_HUSK_HUD_CONFIG = UnitDataComponentConfigFormatter.format(PlayerUnitDataComponentConfig, "server_unit_data_state", PlayerHuskDataComponentConfig, "server_husk_data_state", PlayerHuskHudDataComponentConfig, "server_husk_hud_data_state")
local NUM_FIELDS = #FIELD_NETWORK_LOOKUP

local function nop()
	return
end

local math_round = math.round
local math_min = math.min
local math_max = math.max
local vector3_unbox = Vector3Box.unbox
local quaternion_unbox = QuaternionBox.unbox
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
	locomotion_position = 0.001,
	Vector3 = 0.001,
	high_precision_direction = 1e-05
}
local FIXED_FRAME_OFFSET_NETWORK_TYPES = {
	fixed_frame_offset_end_t_6bit = true,
	fixed_frame_offset_start_t_7bit = true,
	fixed_frame_offset_start_t_9bit = true,
	fixed_frame_offset_start_t_6bit = true,
	fixed_frame_offset_small = true,
	fixed_frame_offset_start_t_5bit = true,
	fixed_frame_offset = true,
	fixed_frame_offset_end_t_7bit = true,
	fixed_frame_offset_end_t_4bit = true
}
local script_id_string_32 = Script.id_string_32
local NETWORK_NAME_ID_TO_FIELD_ID = {}
local NETWORK_ID_TO_NAME = {}
local ALWAYS_UPDATE_FIELDS = {}
local ALWAYS_UPDATE_FIELDS_N = 0
local ALWAYS_UPDATE_FIELDS_STRIDE = 4
local FIELDS_LOOKUP = Script.new_map(512)
local HUSK_FIELDS_LOOKUP = Script.new_map(64)
local HUSK_HUD_FIELDS_LOOKUP = Script.new_map(64)

for i = 1, NUM_FIELDS do
	local field = FIELD_NETWORK_LOOKUP[i]
	local component_name = field[1]
	local field_name = field[2]
	local network_name = field[4]
	local network_type = field[5]

	if FIXED_FRAME_OFFSET_NETWORK_TYPES[network_type] then
		ALWAYS_UPDATE_FIELDS[ALWAYS_UPDATE_FIELDS_N + 1] = component_name
		ALWAYS_UPDATE_FIELDS[ALWAYS_UPDATE_FIELDS_N + 2] = field_name
		ALWAYS_UPDATE_FIELDS[ALWAYS_UPDATE_FIELDS_N + 3] = network_name
		ALWAYS_UPDATE_FIELDS[ALWAYS_UPDATE_FIELDS_N + 4] = network_type
		ALWAYS_UPDATE_FIELDS_N = ALWAYS_UPDATE_FIELDS_N + ALWAYS_UPDATE_FIELDS_STRIDE
	end

	FIELDS_LOOKUP[network_name] = i

	local network_name_id = script_id_string_32(network_name)

	NETWORK_NAME_ID_TO_FIELD_ID[network_name_id] = i
	NETWORK_ID_TO_NAME[network_name_id] = network_name
	NETWORK_ID_TO_NAME[network_name] = network_name_id

	local husk_config = FORMATTED_HUSK_CONFIG[component_name]

	if husk_config and husk_config[field_name] then
		HUSK_FIELDS_LOOKUP[network_name] = i
	end

	local husk_hud_config = FORMATTED_HUSK_HUD_CONFIG[component_name]

	if husk_hud_config and husk_hud_config[field_name] then
		HUSK_HUD_FIELDS_LOOKUP[network_name] = i
	end
end

local POST_UPDATE_FIELDS_STRIDE = 3
local POST_UPDATE_FIELDS = {
	Vector3 = vector3_unbox,
	Quaternion = quaternion_unbox,
	string = function (value, fixed_time_step, network_name)
		local field_idx = FIELDS_LOOKUP[network_name]
		local field = FIELD_NETWORK_LOOKUP[field_idx]
		local use_network_lookup = field[8]
		local lookup = use_network_lookup and NetworkLookup[use_network_lookup] or field[6]
		local networked_value = lookup[value]

		return networked_value
	end,
	fixed_frame_time = function (value, fixed_time_step)
		return math_round(value / fixed_time_step)
	end
}
local FRAME_INDEX_FIELD = "frame_index"
local REMAINDER_TIME_FIELD = "remainder_time"
local FRAME_TIME_FIELD = "frame_time"
local HAD_RECEIVED_INPUT_FIELD = "had_received_input"
local QUATERNION_TOLERANCE = math.cos(math.pi / 64)
local CLIENT_STATE_CACHE_SIZE = 60
local SERVER_STATE_CACHE_SIZE = 1

local function debug(...)
	Log.debug("PlayerUnitDataExtension", ...)
end

local function info(...)
	Log.info("PlayerUnitDataExtension", ...)
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
	self._fixed_time_step = Managers.state.game_session.fixed_time_step
	self.is_resimulating = false

	local component_config = FORMATTED_CONFIG
	local is_server = extension_init_context.is_server
	local state_cache_size = is_server and SERVER_STATE_CACHE_SIZE or CLIENT_STATE_CACHE_SIZE

	self._state_cache_size = state_cache_size

	local components = {}
	local rollback_components = {}

	for config_name, fields in pairs(component_config) do
		local cache = {}

		for i = 1, state_cache_size do
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
	local i = (next_frame - 1) % state_cache_size + 1

	self._component_index = i
	self._last_component_index = i
	self._last_fixed_frame = fixed_frame
	self._last_fixed_t = fixed_frame * self._fixed_time_step

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
		self._sent_fixed_frame = next_frame

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
	self._server_sync_data = {}
	self._server_sync_husk_data = {}
	self._server_sync_husk_hud_data = {}
	self._update_fields_post_update = Script.new_array(2048)
	self._update_fields_post_update[0] = 0
	self._modified_update_fields = Script.new_map(512)

	local archetype = extension_init_data.archetype

	self._archetype = archetype

	local specialization = extension_init_data.specialization

	self._specialization = specialization
	self._hit_zone_lookup, self._hit_zone_actors_lookup = HitZone.initialize_lookup(unit, breed.hit_zones)
	self._write_components = {}
	self._read_components = {}

	for component_name, _ in pairs(self._components) do
		self._read_components[component_name] = self:_create_read_component(component_name)
		self._write_components[component_name] = self:_create_write_component(component_name)
	end

	for component_name, config in pairs(component_config) do
		for field_name, field_info in pairs(config) do
			local additional_data = field_info.additional_data

			if additional_data then
				self:_setup_component_dependency(component_name, field_name, field_info, additional_data)
			end
		end
	end

	if not is_server then
		self._game_object_return_table = Script.new_array(NUM_FIELDS * 2)
	end

	self._network_max_time_offset = NetworkConstants.max_time_offset
	self._in_panic = false
	self._in_panic_at_t = 0
	self._panic_is_behind = false
end

PlayerUnitDataExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id

	local last_fixed_frame = self._last_fixed_frame
	local go_data_table = {}
	local husk_go_data_table = {}
	local husk_hud_go_data_table = {}

	for i = 1, NUM_FIELDS do
		local field = FIELD_NETWORK_LOOKUP[i]
		local component_name, field_name, type, network_name, network_type, lookup, use_network_lookup = field[1], field[2], field[3], field[4], field[5], field[6], field[8]
		local value = self._components[component_name][self._component_index][field_name]
		local actual_value

		if type == "Vector3" or type == "Quaternion" then
			actual_value = value:unbox()
		elseif type == "string" then
			local string_lookup = use_network_lookup and NetworkLookup[use_network_lookup] or lookup
			local lookup_index = string_lookup[value]

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

		if HUSK_FIELDS_LOOKUP[network_name] then
			husk_go_data_table[network_name] = actual_value
		end

		if HUSK_HUD_FIELDS_LOOKUP[network_name] then
			husk_hud_go_data_table[network_name] = actual_value
		end
	end

	local player_peer = self._player_peer

	if not self._is_local_unit then
		go_data_table[FRAME_INDEX_FIELD] = last_fixed_frame
		go_data_table.game_object_type = NetworkLookup.game_object_types.server_unit_data_state
		go_data_table.unit_game_object_id = object_id

		local action_input_network_data = self._action_input_extension:network_data()

		for game_object_field_name, lookup_id_array in pairs(action_input_network_data) do
			go_data_table[game_object_field_name] = lookup_id_array
		end

		self._server_data_state_game_object_id = GameSession.create_game_object(session, "server_unit_data_state", go_data_table, player_peer)
	end

	husk_go_data_table.game_object_type = NetworkLookup.game_object_types.server_husk_data_state
	husk_go_data_table.unit_game_object_id = object_id
	husk_go_data_table[FRAME_INDEX_FIELD] = last_fixed_frame
	self._server_husk_data_state_game_object_id = GameSession.create_game_object(session, "server_husk_data_state", husk_go_data_table, nil, player_peer)
	husk_hud_go_data_table.game_object_type = NetworkLookup.game_object_types.server_husk_hud_data_state
	husk_hud_go_data_table.unit_game_object_id = object_id
	self._server_husk_hud_data_state_game_object_id = GameSession.create_game_object(session, "server_husk_hud_data_state", husk_hud_go_data_table, nil, player_peer)
end

PlayerUnitDataExtension.on_server_data_state_game_object_created = function (self, session, game_object_id)
	self._server_data_state_game_object_id = game_object_id
end

local USERDATA_REPLACEMENT = {}

PlayerUnitDataExtension.extensions_ready = function (self, world, unit)
	local game_object_return_table_or_nil = self._game_object_return_table
	local n_fields = 0

	for component_name, component_config in pairs(self._component_config) do
		local component = self._components[component_name][self._component_index]

		for field_name, data in pairs(component_config) do
			local value = component[field_name]
			local field_type = data.type
			local go_return_init_value

			if field_type == "Vector3" then
				go_return_init_value = USERDATA_REPLACEMENT
			elseif field_type == "Quaternion" then
				go_return_init_value = USERDATA_REPLACEMENT
			else
				go_return_init_value = value
			end

			if game_object_return_table_or_nil then
				local lookup_index = data.lookup_index
				local field = FIELD_NETWORK_LOOKUP[lookup_index]
				local network_name = field[4]

				game_object_return_table_or_nil[n_fields + 1] = NETWORK_ID_TO_NAME[network_name]
				game_object_return_table_or_nil[n_fields + 2] = go_return_init_value
				n_fields = n_fields + 2
			end
		end
	end

	self._action_input_extension = ScriptUnit.extension(unit, "action_input_system")
	self._input_extension = ScriptUnit.extension(unit, "input_system")
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
end

local READ_ONLY_META = {
	__index = function (t, field_name)
		local field = rawget(t, "__config")[field_name]
		local data_type = field.type
		local data = rawget(t, "__data")[rawget(t, "__blackboard").index][field_name]

		if data_type == "Vector3" then
			local field_network_type = field.field_network_type

			if field_network_type == "locomotion_position" then
				local additional_data = rawget(t, "__additional_data")[field_name]
				local parent_unit = additional_data.parent_read_component[additional_data.parent_field_name]

				if parent_unit then
					return PlayerMovement.calculate_absolute_position(parent_unit, data:unbox())
				else
					return data:unbox()
				end
			else
				return data:unbox()
			end
		elseif data_type == "Quaternion" then
			local field_network_type = field.field_network_type

			if field_network_type == "locomotion_rotation" then
				local additional_data = rawget(t, "__additional_data")[field_name]
				local parent_unit = additional_data.parent_read_component[additional_data.parent_field_name]

				if parent_unit then
					return PlayerMovement.calculate_absolute_rotation(parent_unit, data:unbox())
				else
					return data:unbox()
				end
			else
				return data:unbox()
			end
		elseif data_type == "Unit" then
			if not data or data == -1 then
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
		local data_type = field.type
		local networked_value
		local data = rawget(t, "__data")

		if data_type == "Vector3" or data_type == "Quaternion" then
			local actual_value
			local field_network_type = field.field_network_type

			if data_type == "Vector3" then
				if field_network_type == "locomotion_position" then
					local additional_data = rawget(t, "__additional_data")[field_name]
					local parent_unit = additional_data.parent_read_component[additional_data.parent_field_name]

					if parent_unit then
						actual_value = PlayerMovement.calculate_relative_position(parent_unit, value)
					else
						actual_value = value
					end
				else
					actual_value = value
				end
			elseif field_network_type == "locomotion_rotation" then
				local additional_data = rawget(t, "__additional_data")[field_name]
				local parent_unit = additional_data.parent_read_component[additional_data.parent_field_name]

				if parent_unit then
					actual_value = PlayerMovement.calculate_relative_rotation(parent_unit, value)
				else
					actual_value = value
				end
			else
				actual_value = value
			end

			networked_value = data[rawget(t, "__blackboard").index][field_name]

			networked_value:store(actual_value)
		elseif data_type == "Unit" then
			local field_network_type = field.field_network_type
			local doing_conversion = false

			if field_network_type == "locomotion_parent" then
				local prev_val = data[rawget(t, "__blackboard").index][field_name]

				if prev_val ~= nil then
					doing_conversion = true

					local additional_data = rawget(t, "__additional_data")[field_name]
					local conversion_array = additional_data.conversion_array

					for i = 1, additional_data.size, 2 do
						conversion_array[(i + 1) * 0.5] = additional_data[i][additional_data[i + 1]]
					end
				end
			end

			if value == nil then
				data[rawget(t, "__blackboard").index][field_name] = -1
				networked_value = -1
			else
				local is_level_index, id = Managers.state.unit_spawner:game_object_id_or_level_index(value)

				if is_level_index then
					data[rawget(t, "__blackboard").index][field_name] = id + 65535
					networked_value = id + 65535
				else
					data[rawget(t, "__blackboard").index][field_name] = id
					networked_value = id
				end
			end

			if doing_conversion then
				local additional_data = rawget(t, "__additional_data")[field_name]
				local conversion_array = additional_data.conversion_array

				for i = 1, additional_data.size, 2 do
					additional_data[i][additional_data[i + 1]] = conversion_array[(i + 1) * 0.5]
				end
			end
		elseif data_type == "hit_zone_actor_index" then
			if value == nil then
				data[rawget(t, "__blackboard").index][field_name] = NetworkConstants.invalid_hit_zone_actor_index
				networked_value = NetworkConstants.invalid_hit_zone_actor_index
			else
				data[rawget(t, "__blackboard").index][field_name] = value
			end
		elseif data_type == "prd_state" then
			if value == nil then
				data[rawget(t, "__blackboard").index][field_name] = -1
				networked_value = -1
			else
				data[rawget(t, "__blackboard").index][field_name] = value
			end
		else
			data[rawget(t, "__blackboard").index][field_name] = value
		end

		if rawget(t, "__is_server") then
			local network_type = field.field_network_type

			if not FIXED_FRAME_OFFSET_NETWORK_TYPES[network_type] then
				local field_lookup = FIELD_NETWORK_LOOKUP[field.lookup_index]
				local network_name = field_lookup[4]
				local player_unit_data_ext = rawget(t, "__data_ext")
				local modified_fields = player_unit_data_ext._modified_update_fields
				local update_fields = player_unit_data_ext._update_fields_post_update
				local start_idx = modified_fields[network_name]

				if start_idx then
					update_fields[start_idx + 3] = networked_value or value
				else
					start_idx = update_fields[0]
					modified_fields[network_name] = start_idx
					update_fields[start_idx + 1] = network_name
					update_fields[start_idx + 2] = POST_UPDATE_FIELDS[data_type] or POST_UPDATE_FIELDS[network_type] or nop
					update_fields[start_idx + 3] = networked_value or value
					update_fields[0] = start_idx + POST_UPDATE_FIELDS_STRIDE
				end
			end
		end
	end
}

PlayerUnitDataExtension.write_component = function (self, component_name)
	return self._write_components[component_name]
end

PlayerUnitDataExtension._create_write_component = function (self, component_name)
	local config = self._component_config[component_name]
	local component = {
		__data = self._components[component_name],
		__blackboard = self._component_blackboard,
		__config = config,
		__name = component_name,
		__data_ext = self,
		__is_server = self._is_server
	}

	setmetatable(component, WRITE_META)

	return component
end

PlayerUnitDataExtension._setup_component_dependency = function (self, component_name, field_name, field_info, additional_data_config)
	local read_component = self:read_component(component_name)
	local write_component = self:write_component(component_name)
	local additional_data = rawget(read_component, "__additional_data")

	if not additional_data then
		additional_data = {}

		rawset(read_component, "__additional_data", additional_data)
		rawset(write_component, "__additional_data", additional_data)
	end

	local field_additional_data
	local field_network_type = field_info.field_network_type

	if field_network_type == "locomotion_parent" then
		local children = additional_data_config.children
		local num_children = #children

		field_additional_data = Script.new_table(num_children * 2, 2)
		field_additional_data.size = num_children * 2
		field_additional_data.conversion_array = Script.new_array(num_children)

		for i = 1, num_children do
			local child = children[i]
			local child_component_name = child.component_name
			local child_field_name = child.field_name
			local child_write_component = self:write_component(child_component_name)
			local strided_i = (i - 1) * 2

			field_additional_data[strided_i + 1] = child_write_component
			field_additional_data[strided_i + 2] = child_field_name
		end
	elseif field_network_type == "locomotion_position" or field_network_type == "locomotion_rotation" then
		local parent = additional_data_config.parent
		local parent_component_name = parent.component_name
		local parent_component = self:read_component(parent_component_name)
		local parent_field_name = parent.field_name

		field_additional_data = {
			parent_read_component = parent_component,
			parent_field_name = parent_field_name
		}
	else
		ferror("Don't know how to handle additional_data for this field_network_type:%q", field_network_type)
	end

	additional_data[field_name] = field_additional_data
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

PlayerUnitDataExtension.specialization = function (self)
	return self._specialization
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

PlayerUnitDataExtension.pre_update = function (self, unit, dt, t)
	if self._is_server then
		return
	end

	self:_read_server_unit_data_state(t)
end

PlayerUnitDataExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	self._visual_loadout_extension:update_delayed_unequipped_slots(unit, dt, t, fixed_frame)

	local old_index = self._component_index
	local next_frame = fixed_frame + 1
	local new_index = (next_frame - 1) % self._state_cache_size + 1

	self._component_blackboard.index = new_index
	self._component_index = new_index
	self._last_fixed_frame = fixed_frame
	self._last_fixed_t = t
	self._last_component_index = old_index

	if old_index ~= new_index then
		local components = self._components

		self:_copy_components(components, old_index, new_index)
	end
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
	local last_fixed_frame = self._last_fixed_frame

	if last_fixed_frame ~= self._sent_fixed_frame then
		local fixed_time_step = self._fixed_time_step
		local server_sync_data = self._server_sync_data
		local server_sync_husk_data = self._server_sync_husk_data
		local server_sync_husk_hud_data = self._server_sync_husk_hud_data
		local update_fields_post_update = self._update_fields_post_update

		for i = 1, update_fields_post_update[0], POST_UPDATE_FIELDS_STRIDE do
			local network_name = update_fields_post_update[i]
			local func = update_fields_post_update[i + 1]
			local value_to_be_synced = func ~= nop and func(update_fields_post_update[i + 2], fixed_time_step, network_name) or update_fields_post_update[i + 2]

			if sync_server_state then
				server_sync_data[network_name] = value_to_be_synced
			end

			if HUSK_FIELDS_LOOKUP[network_name] then
				server_sync_husk_data[network_name] = value_to_be_synced
			end

			if HUSK_HUD_FIELDS_LOOKUP[network_name] then
				server_sync_husk_hud_data[network_name] = value_to_be_synced
			end
		end

		table.clear(self._modified_update_fields)

		update_fields_post_update[0] = 0

		local components = self._components
		local network_constants = NetworkConstants
		local index = self._last_component_index

		for i = 1, ALWAYS_UPDATE_FIELDS_N, ALWAYS_UPDATE_FIELDS_STRIDE do
			local component_name = ALWAYS_UPDATE_FIELDS[i]
			local field_name = ALWAYS_UPDATE_FIELDS[i + 1]
			local network_name = ALWAYS_UPDATE_FIELDS[i + 2]
			local network_type = ALWAYS_UPDATE_FIELDS[i + 3]
			local value = components[component_name][index][field_name]
			local type_info = network_constants[network_type]
			local value_to_be_synced = math_max(math_round(value / fixed_time_step) - last_fixed_frame, type_info.min)

			if sync_server_state then
				server_sync_data[network_name] = value_to_be_synced
			end

			if HUSK_FIELDS_LOOKUP[network_name] then
				server_sync_husk_data[network_name] = value_to_be_synced
			end

			if HUSK_HUD_FIELDS_LOOKUP[network_name] then
				server_sync_husk_hud_data[network_name] = value_to_be_synced
			end
		end

		if sync_server_state then
			server_sync_data[FRAME_INDEX_FIELD] = last_fixed_frame

			local remainder_time = math_min(t - self._last_fixed_t, self._network_max_time_offset)

			server_sync_data[REMAINDER_TIME_FIELD] = remainder_time
			server_sync_data[FRAME_TIME_FIELD] = math_min(dt, self._network_max_time_offset)
			server_sync_data[HAD_RECEIVED_INPUT_FIELD] = self._input_extension:had_received_input(last_fixed_frame)

			local action_input_extension = self._action_input_extension
			local action_input_network_data = action_input_extension:network_data()

			for game_object_field_name, lookup_id_array in pairs(action_input_network_data) do
				server_sync_data[game_object_field_name] = lookup_id_array
			end

			set_fields(game_session, server_data_state_game_object_id, server_sync_data)
		end

		server_sync_husk_data[FRAME_INDEX_FIELD] = last_fixed_frame

		set_fields(game_session, server_husk_data_state_game_object_id, server_sync_husk_data)
		set_fields(game_session, server_husk_hud_state_game_object_id, server_sync_husk_hud_data)

		self._sent_fixed_frame = last_fixed_frame

		table.clear(server_sync_data)
		table.clear(server_sync_husk_data)
		table.clear(server_sync_husk_hud_data)
	end
end

local _game_object_field = GameSession.game_object_field
local _vector3_distance_sq = Vector3.distance_squared
local _quaternion_is_valid = Quaternion.is_valid
local _quaternion_dot = Quaternion.dot

PlayerUnitDataExtension._read_server_unit_data_state = function (self, t)
	local server_data_state_game_object_id = self._server_data_state_game_object_id

	if not server_data_state_game_object_id then
		return
	end

	local game_session = self._game_session
	local frame_index = _game_object_field(game_session, server_data_state_game_object_id, FRAME_INDEX_FIELD)
	local remainder_time = _game_object_field(game_session, server_data_state_game_object_id, REMAINDER_TIME_FIELD)
	local frame_time = _game_object_field(game_session, server_data_state_game_object_id, FRAME_TIME_FIELD)
	local state_cache_size = self._state_cache_size
	local input_handler = self._player.input_handler

	if frame_index <= self._last_received_frame then
		return
	elseif frame_index > self._last_fixed_frame then
		input_handler:frame_parsed(frame_index, remainder_time, frame_time)

		if not self._in_panic then
			info("Panic started. Received state package from the future, this is likely because we haven't run any fixed frames yet or had a major stall. Received frame (%i), last frame (%i).", frame_index, self._last_fixed_frame)

			self._in_panic = true
			self._in_panic_at_t = t
			self._panic_is_behind = true

			input_handler:set_in_panic(true)
		elseif not self._panic_is_behind then
			info("Panic switched to being behind.")

			self._panic_is_behind = true
		end

		self._last_received_frame = frame_index

		return
	elseif frame_index <= self._last_fixed_frame - state_cache_size then
		input_handler:frame_parsed(frame_index, remainder_time, frame_time)

		if not self._in_panic then
			info("Panic started. Received state package so old it would trash newer entries due to ringbuffer size.")

			self._in_panic = true
			self._in_panic_at_t = t
			self._panic_is_behind = false

			input_handler:set_in_panic(true)
		elseif self._panic_is_behind then
			info("Panic switched to being ahead.")

			self._panic_is_behind = false
		end

		self._last_received_frame = frame_index

		return
	end

	if self._in_panic then
		info("Panic resolved, took %.3f seconds.", t - self._in_panic_at_t)

		self._in_panic = false
		self._in_panic_at_t = 0
		self._panic_is_behind = false

		input_handler:set_in_panic(false)
	end

	local mispredict = false
	local wrapped_frame_index = (frame_index - 1) % state_cache_size + 1
	local rollback_components = self._rollback_components
	local components = self._components
	local game_object_return_table = self._game_object_return_table
	local modified_table_size = GameSession.game_object_fields_array(game_session, server_data_state_game_object_id, game_object_return_table)

	for i = 1, modified_table_size, 2 do
		local field_id = NETWORK_NAME_ID_TO_FIELD_ID[game_object_return_table[i]]
		local field = FIELD_NETWORK_LOOKUP[field_id]
		local authoritative_value = game_object_return_table[i + 1]
		local component_name, field_name, type, network_type, lookup, skip_predict_verification, use_network_lookup = field[1], field[2], field[3], field[5], field[6], field[7], field[8]
		local component = components[component_name][wrapped_frame_index]
		local rollback_component = rollback_components[component_name]
		local simulated_value = component[field_name]
		local real_simulated_value, correct
		local default_number_tolerance = NUMBER_NETWORK_TYPE_TOLERANCES.default

		if simulated_value == nil then
			correct = false

			if type == "string" then
				local string_lookup = use_network_lookup and NetworkLookup[use_network_lookup] or lookup

				component[field_name] = string_lookup[authoritative_value]
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
			correct = _quaternion_is_valid(real_simulated_value) and math.abs(_quaternion_dot(real_simulated_value, authoritative_value)) > QUATERNION_TOLERANCE

			simulated_value:store(authoritative_value)
		elseif type == "string" then
			local string_lookup = use_network_lookup and NetworkLookup[use_network_lookup] or lookup

			real_simulated_value = simulated_value

			local local_correct = string_lookup[real_simulated_value] == authoritative_value

			correct = skip_predict_verification and true or local_correct

			if not local_correct then
				component[field_name] = string_lookup[authoritative_value]
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

	if mispredict then
		local resimulate_from = frame_index + 1
		local wrapped_resimulate_frame_index = (resimulate_from - 1) % state_cache_size + 1

		self:_copy_components(self._components, wrapped_frame_index, wrapped_resimulate_frame_index)

		self._component_index = wrapped_resimulate_frame_index
		self._component_blackboard.index = wrapped_resimulate_frame_index

		self._action_input_extension:mispredict_happened(frame_index, game_session, server_data_state_game_object_id)

		self.is_resimulating = true

		Managers.state.extension:fixed_update_resimulate_unit(self._unit, resimulate_from, rollback_components)

		self.is_resimulating = false
	end

	self._last_received_frame = frame_index

	input_handler:frame_parsed(frame_index, remainder_time, frame_time)
end

return PlayerUnitDataExtension
