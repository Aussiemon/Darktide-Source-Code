local ActionInputParser = require("scripts/extension_systems/action_input/action_input_parser")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local PlayerUnitActionInputExtension = class("PlayerUnitActionInputExtension")

PlayerUnitActionInputExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._action_input_parsers = {}
end

PlayerUnitActionInputExtension.extensions_ready = function (self, world, unit)
	local unit_data = ScriptUnit.extension(unit, "unit_data_system")
	local weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	local ability_extension = ScriptUnit.extension(unit, "ability_system")
	local config = {
		weapon_action = {
			action_input_type = "weapon",
			debug_draw = true,
			templates = WeaponTemplates,
			action_extension = weapon_extension
		},
		combat_ability_action = {
			action_input_type = "ability",
			debug_draw = true,
			templates = AbilityTemplates,
			action_extension = ability_extension
		},
		grenade_ability_action = {
			action_input_type = "ability",
			templates = AbilityTemplates,
			action_extension = ability_extension
		}
	}
	local network_data_cache = {}
	self._network_data_cache = network_data_cache
	local network_data_cache_configs = {}
	self._network_data_cache_configs = network_data_cache_configs
	local authoritative_network_data = {}
	self._authoritative_network_data = authoritative_network_data
	local debug_index = 1

	for action_component_name, data in pairs(config) do
		local action_component = unit_data:read_component(action_component_name)
		self._action_input_parsers[action_component_name] = ActionInputParser:new(unit, action_component_name, action_component, data, debug_index)
		local cache_config = {
			input_sequences_is_running = string.format("%s_input_sequences_is_running", action_component_name),
			input_sequences_current_element_index = string.format("%s_input_sequences_current_element_index", action_component_name),
			input_sequences_element_start_t = string.format("%s_input_sequences_element_start_t", action_component_name),
			input_queue_action_input = string.format("%s_input_queue_action_input", action_component_name),
			input_queue_raw_input = string.format("%s_input_queue_raw_input", action_component_name),
			input_queue_produced_by_hierarchy = string.format("%s_input_queue_produced_by_hierarchy", action_component_name),
			input_queue_hierarchy_position = string.format("%s_input_queue_hierarchy_position", action_component_name),
			input_queue_first_entry_became_first_entry_t = string.format("%s_input_queue_first_entry_became_first_entry_t", action_component_name),
			hierarchy_position = string.format("%s_hierarchy_position", action_component_name)
		}
		network_data_cache_configs[action_component_name] = cache_config

		for collection_name, game_object_field_name in pairs(cache_config) do
			if collection_name ~= "input_queue_first_entry_became_first_entry_t" then
				authoritative_network_data[game_object_field_name] = {}
			else
				authoritative_network_data[game_object_field_name] = 0
			end
		end

		for collection_name, game_object_field_name in pairs(cache_config) do
			if collection_name ~= "input_queue_first_entry_became_first_entry_t" then
				network_data_cache[game_object_field_name] = {}
			else
				network_data_cache[game_object_field_name] = 0
			end
		end

		if data.debug_draw then
			debug_index = debug_index + 1
		end
	end
end

PlayerUnitActionInputExtension.peek_next_input = function (self, id)
	local parser = self._action_input_parsers[id]

	return parser:peek_next_input()
end

PlayerUnitActionInputExtension.last_action_auto_completed = function (self, id)
	local parser = self._action_input_parsers[id]

	return parser:last_action_auto_completed()
end

PlayerUnitActionInputExtension.consume_next_input = function (self, id, t)
	local parser = self._action_input_parsers[id]

	parser:consume_next_input(t)
end

PlayerUnitActionInputExtension.clear_input_queue_and_sequences = function (self, id)
	local parser = self._action_input_parsers[id]

	parser:clear_input_queue_and_sequences()
end

PlayerUnitActionInputExtension.action_transitioned_with_automatic_input = function (self, id, action_input, t)
	local parser = self._action_input_parsers[id]

	parser:action_transitioned_with_automatic_input(action_input, t)
end

PlayerUnitActionInputExtension.mispredict_happened = function (self, fixed_frame, game_session, game_object_id)
	local parsers = self._action_input_parsers
	local authoritative_network_data = self._authoritative_network_data

	GameSession.game_object_fields(game_session, game_object_id, authoritative_network_data)

	local configs = self._network_data_cache_configs

	for id, parser in pairs(parsers) do
		local config = configs[id]

		parser:mispredict_happened(fixed_frame, authoritative_network_data[config.input_sequences_is_running], authoritative_network_data[config.input_sequences_current_element_index], authoritative_network_data[config.input_sequences_element_start_t], authoritative_network_data[config.input_queue_action_input], authoritative_network_data[config.input_queue_raw_input], authoritative_network_data[config.input_queue_produced_by_hierarchy], authoritative_network_data[config.input_queue_hierarchy_position], authoritative_network_data[config.input_queue_first_entry_became_first_entry_t], authoritative_network_data[config.hierarchy_position])
	end
end

PlayerUnitActionInputExtension.update = function (self, dt, t)
	local parsers = self._action_input_parsers

	for id, parser in pairs(parsers) do
		parser:update(dt, t)
	end
end

PlayerUnitActionInputExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	local parsers = self._action_input_parsers

	for id, parser in pairs(parsers) do
		parser:fixed_update(unit, dt, t, fixed_frame)
	end
end

PlayerUnitActionInputExtension.has_any_queued_input = function (self)
	local has_queued_input = false
	local parsers = self._action_input_parsers

	for id, parser in pairs(parsers) do
		if parser:peek_next_input() ~= nil then
			has_queued_input = true

			break
		end
	end

	return has_queued_input
end

PlayerUnitActionInputExtension.bot_queue_action_input = function (self, id, action_input, raw_input)
	local parser = self._action_input_parsers[id]

	fassert(parser, "No parser with id %q exists.", id)

	return parser:bot_queue_action_input(action_input, raw_input)
end

PlayerUnitActionInputExtension.bot_queue_request_is_consumed = function (self, id, global_bot_request_id)
	local parser = self._action_input_parsers[id]

	fassert(parser, "No parser with id %q exists,", id)

	return parser:bot_queue_request_is_consumed(global_bot_request_id)
end

PlayerUnitActionInputExtension.bot_queue_clear_requests = function (self, id)
	local parser = self._action_input_parsers[id]

	fassert(parser, "No parser with id %q exists,", id)
	parser:bot_queue_clear_requests()
end

PlayerUnitActionInputExtension.network_data = function (self)
	local data_cache = self._network_data_cache
	local configs = self._network_data_cache_configs

	for id, parser in pairs(self._action_input_parsers) do
		local config = configs[id]
		data_cache[config.input_queue_first_entry_became_first_entry_t] = parser:pack_input_sequences_and_queue(data_cache[config.input_sequences_is_running], data_cache[config.input_sequences_current_element_index], data_cache[config.input_sequences_element_start_t], data_cache[config.input_queue_hierarchy_position], data_cache[config.input_queue_produced_by_hierarchy], data_cache[config.input_queue_action_input], data_cache[config.input_queue_raw_input], data_cache[config.hierarchy_position])
	end

	return data_cache
end

return PlayerUnitActionInputExtension
