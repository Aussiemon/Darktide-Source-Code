-- chunkname: @scripts/extension_systems/unit_data/player_husk_data_extension.lua

local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerUnitDataComponentConfig = require("scripts/extension_systems/unit_data/player_unit_data_component_config")
local PlayerHuskDataComponentConfig = require("scripts/extension_systems/unit_data/player_husk_data_component_config")
local PlayerHuskHudDataComponentConfig = require("scripts/extension_systems/unit_data/player_husk_hud_data_component_config")
local UnitDataComponentConfigFormatter = require("scripts/extension_systems/unit_data/unit_data_component_config_formatter")
local FORMATTED_CONFIG, FIELD_NETWORK_LOOKUP, FORMATTED_HUSK_CONFIG, FORMATTED_HUSK_HUD_CONFIG = UnitDataComponentConfigFormatter.format(PlayerUnitDataComponentConfig, "server_unit_data_state", PlayerHuskDataComponentConfig, "server_husk_data_state", PlayerHuskHudDataComponentConfig, "server_husk_hud_data_state")
local script_id_string_32 = Script.id_string_32
local NETWORK_NAME_LOOKUP = Script.new_map(128)
local HUSK_GAME_OBJECT_FIELD_DATA = Script.new_array(64)
local HUSK_HUD_GAME_OBJECT_FIELD_DATA = Script.new_array(32)
local NETWORK_NAME_ID_TO_FIELD_ID = Script.new_map(128)

local function create_network_field_lookup(formatted_config, network_field_lookup)
	local data_n = 0

	for component_name, component_config in pairs(formatted_config) do
		for field_name, field_config in pairs(component_config) do
			local field_id = FORMATTED_CONFIG[component_name][field_name].lookup_index
			local field = FIELD_NETWORK_LOOKUP[field_id]
			local network_name = field[4]
			local network_name_id = NETWORK_NAME_LOOKUP[network_name]

			if not network_name_id then
				network_name_id = script_id_string_32(network_name)
				NETWORK_NAME_LOOKUP[network_name] = network_name_id
				NETWORK_NAME_LOOKUP[network_name_id] = network_name
				NETWORK_NAME_ID_TO_FIELD_ID[network_name_id] = field_id
			end

			network_field_lookup[data_n + 1] = network_name_id
			network_field_lookup[data_n + 2] = 0
			data_n = data_n + 2
		end
	end
end

create_network_field_lookup(FORMATTED_HUSK_CONFIG, HUSK_GAME_OBJECT_FIELD_DATA)
create_network_field_lookup(FORMATTED_HUSK_HUD_CONFIG, HUSK_HUD_GAME_OBJECT_FIELD_DATA)

local PlayerHuskDataExtension = class("PlayerHuskDataExtension")
local FIXED_FRAME_OFFSET_NETWORK_TYPES = {
	fixed_frame_offset = true,
	fixed_frame_offset_end_t_4bit = true,
	fixed_frame_offset_end_t_6bit = true,
	fixed_frame_offset_end_t_7bit = true,
	fixed_frame_offset_small = true,
	fixed_frame_offset_start_t_6bit = true,
	fixed_frame_offset_start_t_7bit = true,
	fixed_frame_offset_start_t_9bit = true,
}
local _game_object_field = GameSession.game_object_field
local _game_object_fields_array = GameSession.game_object_fields_array

local function _update_component_values(components, game_session, game_object_id, husk_config, config, field_network_lookup, game_object_field_data, fixed_time_step, frame_index)
	local num_fields = _game_object_fields_array(game_session, game_object_id, game_object_field_data)

	for i = 1, num_fields, 2 do
		local network_name_id = game_object_field_data[i]
		local authoritative_value = game_object_field_data[i + 1]
		local field = field_network_lookup[NETWORK_NAME_ID_TO_FIELD_ID[network_name_id]]
		local component_name, field_name, type, network_type, lookup, use_network_lookup = field[1], field[2], field[3], field[5], field[6], field[8]
		local component = components[component_name]

		if type == "Vector3" or type == "Quaternion" then
			component[field_name]:store(authoritative_value)
		elseif type == "string" then
			local string_lookup = use_network_lookup and NetworkLookup[use_network_lookup] or lookup

			component[field_name] = string_lookup[authoritative_value]
		elseif type == "number" then
			if FIXED_FRAME_OFFSET_NETWORK_TYPES[network_type] then
				component[field_name] = (authoritative_value + frame_index) * fixed_time_step
			elseif network_type == "fixed_frame_time" then
				component[field_name] = authoritative_value * fixed_time_step
			else
				component[field_name] = authoritative_value
			end
		else
			component[field_name] = authoritative_value
		end
	end
end

local function _read_component_values(server_husk_data_state_game_object_id, server_husk_hud_data_state_game_object_id, components, game_session, fixed_time_step, frame_index)
	if not server_husk_data_state_game_object_id or not server_husk_hud_data_state_game_object_id then
		return false
	end

	_update_component_values(components, game_session, server_husk_data_state_game_object_id, FORMATTED_HUSK_CONFIG, FORMATTED_CONFIG, FIELD_NETWORK_LOOKUP, HUSK_GAME_OBJECT_FIELD_DATA, fixed_time_step, frame_index)
	_update_component_values(components, game_session, server_husk_hud_data_state_game_object_id, FORMATTED_HUSK_HUD_CONFIG, FORMATTED_CONFIG, FIELD_NETWORK_LOOKUP, HUSK_HUD_GAME_OBJECT_FIELD_DATA, fixed_time_step, frame_index)

	return true
end

PlayerHuskDataExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	local breed = extension_init_data.breed

	self._breed = breed
	self._hit_zone_lookup, self._hit_zone_actors_lookup = HitZone.initialize_lookup(unit, breed.hit_zones)
	self._game_session = game_session
	self._fixed_time_step = Managers.state.game_session.fixed_time_step

	local components_config = FORMATTED_CONFIG

	self._components_config = components_config

	local components_husk_config = {}

	self._components_husk_config = components_husk_config

	local components = {}

	self._components = components

	self:_initialize_components(components, components_husk_config, FORMATTED_CONFIG, FORMATTED_HUSK_CONFIG)
	self:_initialize_components(components, components_husk_config, FORMATTED_CONFIG, FORMATTED_HUSK_HUD_CONFIG)

	local read_components = {}

	self._read_components = read_components

	for component_name, _ in pairs(components) do
		read_components[component_name] = self:_create_read_component(component_name)
	end

	self._last_received_frame = 0

	local archetype = extension_init_data.archetype

	self._archetype = archetype
end

PlayerHuskDataExtension.on_server_husk_data_state_game_object_created = function (self, game_object_id)
	self._server_husk_data_state_game_object_id = game_object_id

	local game_session = self._game_session
	local frame_index = _game_object_field(game_session, game_object_id, "frame_index")

	_read_component_values(self._server_husk_data_state_game_object_id, self._server_husk_hud_data_state_game_object_id, self._components, game_session, self._fixed_time_step, frame_index)
end

PlayerHuskDataExtension.on_server_husk_hud_data_state_game_object_created = function (self, game_object_id)
	self._server_husk_hud_data_state_game_object_id = game_object_id

	local game_session = self._game_session
	local frame_index = _game_object_field(game_session, self._server_husk_data_state_game_object_id, "frame_index")

	_read_component_values(self._server_husk_data_state_game_object_id, self._server_husk_hud_data_state_game_object_id, self._components, game_session, self._fixed_time_step, frame_index)
end

PlayerHuskDataExtension.breed = function (self)
	return self._breed
end

PlayerHuskDataExtension.breed_name = function (self)
	local breed = self._breed

	return breed.name
end

PlayerHuskDataExtension.archetype = function (self)
	return self._archetype
end

PlayerHuskDataExtension.archetype_name = function (self)
	local archetype = self._archetype

	return archetype.name
end

PlayerHuskDataExtension.hit_zone = function (self, actor)
	return self._hit_zone_lookup[actor]
end

PlayerHuskDataExtension.hit_zone_actors = function (self, hit_zone_name)
	return self._hit_zone_actors_lookup[hit_zone_name]
end

PlayerHuskDataExtension.is_owned_by_death_manager = function (self)
	return false
end

PlayerHuskDataExtension.has_component = function (self, component_name)
	return self._read_components[component_name] ~= nil
end

PlayerHuskDataExtension.read_component = function (self, component_name)
	local read_component = self._read_components[component_name]

	return read_component
end

PlayerHuskDataExtension.write_component = function (self, component_name)
	error("Writing to components is not supported on husks.")
end

PlayerHuskDataExtension.is_local_unit = function (self)
	return false
end

PlayerHuskDataExtension.pre_update = function (self)
	self:_read_server_husk_data_state()
end

PlayerHuskDataExtension._read_server_husk_data_state = function (self)
	local server_husk_data_state_game_object_id = self._server_husk_data_state_game_object_id
	local server_husk_hud_data_state_game_object_id = self._server_husk_hud_data_state_game_object_id
	local game_session = self._game_session
	local frame_index = _game_object_field(game_session, server_husk_data_state_game_object_id, "frame_index")

	if frame_index <= self._last_received_frame then
		return
	end

	local components = self._components
	local fixed_time_step = self._fixed_time_step
	local values_read = _read_component_values(server_husk_data_state_game_object_id, server_husk_hud_data_state_game_object_id, components, game_session, fixed_time_step, frame_index)

	if values_read then
		self._last_received_frame = frame_index
	end
end

local READ_ONLY_META = {
	__index = function (t, field_name)
		local field = rawget(t, "__config")[field_name]
		local data_type = field.type
		local data = rawget(t, "__data")[field_name]

		if data_type == "Vector3" or data_type == "Quaternion" then
			return data:unbox()
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
		else
			return data
		end
	end,
	__newindex = function (t, field_name, value)
		ferror("Trying to write to %q in a read only component %q", field_name, rawget(t, "__name"))
	end,
}

PlayerHuskDataExtension._create_read_component = function (self, component_name)
	local config = self._components_config[component_name]
	local husk_config = self._components_husk_config[component_name]
	local component = {
		__data = self._components[component_name],
		__config = config,
		__name = component_name,
		__husk_config = husk_config,
	}

	setmetatable(component, READ_ONLY_META)

	return component
end

PlayerHuskDataExtension._initialize_components = function (self, components, components_husk_config, components_config, config)
	for component_name, fields in pairs(config) do
		local component = components[component_name] or {}

		components[component_name] = component

		local husk_config = components_husk_config[component_name] or {}

		components_husk_config[component_name] = husk_config

		local formatted_config = components_config[component_name]

		for field_name, _ in pairs(fields) do
			local field_config = formatted_config[field_name]
			local type = field_config.type

			if type == "Vector3" then
				component[field_name] = Vector3Box(Vector3.invalid_vector())
			elseif type == "Quaternion" then
				component[field_name] = QuaternionBox(Quaternion.from_elements(math.huge, math.huge, math.huge, math.huge))
			end

			husk_config[field_name] = true
		end
	end
end

return PlayerHuskDataExtension
