-- chunkname: @scripts/settings/equipment/tests/weapon_template_tests.lua

local Breed = require("scripts/utilities/breed")
local Breeds = require("scripts/settings/breed/breeds")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitAnimationStateMachineSettings = require("scripts/settings/animation/player_unit_animation_state_machine_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local hit_zone_names = HitZone.hit_zone_names
local _template_settings_test, _action_settings_test, _conditional_state_test, _alternate_fire_test, _validate_hit_zone_priority, _validate_chain_actions, _validate_reachable_actions, _validate_conditional_state_to_action_input, _validate_running_action_state_to_action_input, _action_input_sequence_total_time, _state_machine_settings_test, _check_state_machine_settings, _stat_and_perk_verification, _stat_verification, _validate_tweak_template_existence, _check_tweak_template_existence

local function weapon_template_tests(weapon_template)
	_template_settings_test(weapon_template)
	_action_settings_test(weapon_template)
	_conditional_state_test(weapon_template)
	_alternate_fire_test(weapon_template)
	_state_machine_settings_test(weapon_template)
	_validate_tweak_template_existence(weapon_template)
	_stat_and_perk_verification(weapon_template)
end

local inventory_slot_component_data = PlayerCharacterConstants.inventory_slot_component_data
local weapon_component_data = inventory_slot_component_data.weapon

function _template_settings_test(weapon_template)
	local weapon_template_name = weapon_template.name
	local anim_state_machine_3p, breed_anim_state_machine_3p = weapon_template.anim_state_machine_3p, weapon_template.breed_anim_state_machine_3p

	if breed_anim_state_machine_3p then
		for breed_name, breed in pairs(Breeds) do
			if Breed.is_player(breed) then
				-- Nothing
			end
		end
	end

	local anim_state_machine_1p, breed_anim_state_machine_1p = weapon_template.anim_state_machine_1p, weapon_template.breed_anim_state_machine_1p

	if breed_anim_state_machine_1p then
		for breed_name, breed in pairs(Breeds) do
			if Breed.is_player(breed) then
				-- Nothing
			end
		end
	end

	local keywords = weapon_template.keywords
	local overheat_configuration = weapon_template.overheat_configuration

	if overheat_configuration and not weapon_template.use_special_charge_template_for_overheat_decay then
		local auto_vent_delay = overheat_configuration.auto_vent_delay
		local network_type = weapon_component_data.overheat_last_charge_at_t.network_type
		local network_type_info = Network.type_info(network_type)
		local min = network_type_info.min
		local fixed_time_step = 1 / GameParameters.tick_rate
		local time_network_type_can_represent_backwards_in_time = math.abs(min * fixed_time_step)
		local vent_interval = overheat_configuration.vent_interval

		if not vent_interval then
			return false, "vent_configuration needs vent_interval."
		end

		local vent_duration = overheat_configuration.vent_duration

		if not vent_duration then
			return false, "vent_configuration needs vent_duration."
		end

		network_type = weapon_component_data.overheat_remove_at_t.network_type
		network_type_info = Network.type_info(network_type)

		local max = network_type_info.max
		local time_network_type_can_represent_forwards_in_time = math.abs(max * fixed_time_step)

		if time_network_type_can_represent_forwards_in_time < vent_interval then
			return false, string.format("vent_interval is larger than what the current network_type (%q) can represent forwards in time (%.5f). Change what network_type \"overheat_remove_at_t\" to something that can represent it.", network_type, time_network_type_can_represent_forwards_in_time)
		end
	end
end

local MANDATORY_ACTIONS = {
	action_wield = true,
}

function _action_settings_test(weapon_template)
	local start_inputs = {}
	local start_inputs_no_priority = {}
	local start_inputs_priority = {}
	local action_kind_tests = require("scripts/settings/equipment/tests/action_kind_tests")

	for action_name, _ in pairs(MANDATORY_ACTIONS) do
		-- Nothing
	end

	local action_inputs = weapon_template.action_inputs

	for action_name, action_settings in pairs(weapon_template.actions) do
		action_kind_tests(action_settings, weapon_template, action_name)

		local start_input = action_settings.start_input
		local action_priority = action_settings.action_priority

		if start_input then
			local previus_exist = not not start_inputs[start_input]
			local start_input_does_not_have_priority = start_inputs_no_priority[start_input]

			if not action_priority then
				-- Nothing
			else
				local priority_key = start_input .. "_" .. action_priority

				start_inputs_priority[priority_key] = action_name
			end

			start_inputs[start_input] = action_name
			start_inputs_no_priority[start_input] = start_input_does_not_have_priority or not action_priority
		end

		local s, m = _validate_hit_zone_priority(weapon_template, action_settings)

		s, m = _validate_chain_actions(weapon_template, action_settings)
		s, m = _validate_conditional_state_to_action_input(weapon_template, action_settings)
		s, m = _validate_running_action_state_to_action_input(weapon_template, action_settings)
		s, m = _validate_reachable_actions(weapon_template, action_settings)

		local stop_input = action_settings.stop_input
		local minimum_hold_time = action_settings.minimum_hold_time or 0

		if stop_input then
			local stop_input_config = action_inputs[stop_input]
			local fixed_time_step = 1 / GameParameters.tick_rate
			local safe_stop_input_buffer_time = minimum_hold_time + fixed_time_step
			local action_input_sequence_total_time = _action_input_sequence_total_time(stop_input_config)
		end
	end
end

function _action_input_sequence_total_time(action_input_config)
	local input_sequence_time = 0
	local action_input_time = input_sequence_time + action_input_config.buffer_time

	return action_input_time
end

local EMPTY_TABLE = {}

function _conditional_state_test(weapon_template)
	local WeaponActionHandlerData = require("scripts/settings/equipment/weapon_action_handler_data")
	local conditional_state_functions = WeaponActionHandlerData.conditional_state_functions
	local action_inputs = weapon_template.action_inputs
	local conditional_state_to_action = weapon_template.conditional_state_to_action_input or EMPTY_TABLE

	for i = 1, #conditional_state_to_action do
		local conditional_state_config = conditional_state_to_action[i]
		local conditional_state = conditional_state_config.conditional_state
		local input_name = conditional_state_config.input_name
	end
end

function _alternate_fire_test(weapon_template)
	local alternate_fire_settings = weapon_template.alternate_fire_settings

	if not alternate_fire_settings then
		return
	end
end

local TEMP_MISSING_HIT_ZONE_NAMES = {}

function _validate_hit_zone_priority(weapon_template, action_settings)
	local success, error_msg = true, ""
	local hit_zone_priority = action_settings.hit_zone_priority

	if hit_zone_priority == nil then
		return success, error_msg
	end

	table.clear_array(TEMP_MISSING_HIT_ZONE_NAMES, #TEMP_MISSING_HIT_ZONE_NAMES)

	local num_missing_hit_zone_names = 0

	for hit_zone_name, _ in pairs(hit_zone_names) do
		if hit_zone_priority[hit_zone_name] == nil then
			num_missing_hit_zone_names = num_missing_hit_zone_names + 1
			TEMP_MISSING_HIT_ZONE_NAMES[num_missing_hit_zone_names] = hit_zone_name
		end
	end

	if num_missing_hit_zone_names > 0 then
		table.sort(TEMP_MISSING_HIT_ZONE_NAMES)

		success, error_msg = false, "Missing priority for the following hit zones:"

		for i = 1, num_missing_hit_zone_names do
			local hit_zone_name = TEMP_MISSING_HIT_ZONE_NAMES[i]

			error_msg = string.format("%s\n\t%s", error_msg, hit_zone_name)
		end
	end

	return success, error_msg
end

local _skip_ability_check_action_kinds = {
	inspect = true,
	toggle_special = true,
	unwield = true,
	unwield_to_specific = true,
}

function _validate_chain_actions(weapon_template, action_settings)
	local allowed_chain_actions = action_settings.allowed_chain_actions

	if not allowed_chain_actions then
		return true, ""
	end

	local actions = weapon_template.actions
	local action_inputs = weapon_template.action_inputs
	local success = true
	local error_msg = ""
	local has_grenade_ability = false
	local has_combat_ability = false

	for input, chain_action in pairs(allowed_chain_actions) do
		local chain_action_success = true
		local chain_action_error_msg = string.format("%q -> ", tostring(input))

		if input == "combat_ability" then
			has_combat_ability = true
		end

		if input == "grenade_ability" then
			has_grenade_ability = true
		end

		if type(input) ~= "string" then
			chain_action_success = false
			chain_action_error_msg = chain_action_error_msg .. "key is not a string. "
		end

		local num_chain_actions = #chain_action

		if num_chain_actions == 0 then
			local action_name = chain_action.action_name

			if action_name then
				if not actions[action_name] then
					chain_action_success = false
					chain_action_error_msg = chain_action_error_msg .. "action_name is not an action. "
				end
			else
				chain_action_success = false
				chain_action_error_msg = chain_action_error_msg .. "missing action_name. "
			end
		else
			for ii = 1, num_chain_actions do
				local action = chain_action[ii]
				local action_type = type(action)

				if action_type == "table" then
					local action_name = action.action_name

					if action_name then
						if not actions[action_name] then
							chain_action_success = false
							chain_action_error_msg = chain_action_error_msg .. "action_name is not an action. "
						end
					else
						chain_action_success = false
						chain_action_error_msg = chain_action_error_msg .. "missing action_name. "
					end
				else
					chain_action_success = false
					chain_action_error_msg = chain_action_error_msg .. "has indexed values that aren't chain action tables. "
				end
			end
		end

		local from_action_input = action_inputs[input] ~= nil

		if not from_action_input then
			chain_action_success = false
			chain_action_error_msg = chain_action_error_msg .. string.format("%q does not match any action_input. ", input)
		end

		if not chain_action_success then
			error_msg = error_msg .. chain_action_error_msg .. "\n"
			success = false
		end
	end

	local is_weapon = false
	local is_bot_weapon = string.find(weapon_template.name, "bot_")

	if not is_bot_weapon then
		for i, keyword in pairs(weapon_template.keywords) do
			if keyword == "ranged" or keyword == "melee" then
				is_weapon = true
			end
		end
	end

	local kind = action_settings.kind
	local make_ability_check = not _skip_ability_check_action_kinds[kind] and not action_settings.skip_ability_chain_action_check

	if is_weapon and make_ability_check then
		if not has_grenade_ability then
			success = false
			error_msg = error_msg .. "missing chain action for input grenade_ability\n"
		end

		if not has_combat_ability then
			success = false
			error_msg = error_msg .. "missing chain action for input combat_ability\n"
		end
	end

	return success, error_msg
end

function _validate_conditional_state_to_action_input(weapon_template, action_settings)
	local conditional_state_to_action_input = action_settings.conditional_state_to_action_input

	if not conditional_state_to_action_input then
		return true, ""
	end

	local WeaponActionHandlerData = require("scripts/settings/equipment/weapon_action_handler_data")
	local conditional_state_functions = WeaponActionHandlerData.conditional_state_functions
	local action_inputs = weapon_template.action_inputs
	local success = true
	local error_msg = ""

	for conditional_state, config in pairs(conditional_state_to_action_input) do
		local conditional_state_success = true
		local conditional_state_error_msg = string.format("%q -> ", tostring(conditional_state))

		if type(conditional_state) ~= "string" then
			conditional_state_success = false
			conditional_state_error_msg = conditional_state_error_msg .. "key is not a string. "
		end

		if not conditional_state_functions[conditional_state] then
			conditional_state_success = false
			conditional_state_error_msg = conditional_state_error_msg .. string.format("%q does not exist in conditional_state_functions. ", conditional_state)
		end

		local input_name = config.input_name

		if input_name then
			if not action_inputs[input_name] then
				conditional_state_success = false
				conditional_state_error_msg = conditional_state_error_msg .. "input_name is not defined in action_input table. "
			end
		else
			conditional_state_success = false
			conditional_state_error_msg = conditional_state_error_msg .. "missing input_name. "
		end

		if not conditional_state_success then
			error_msg = error_msg .. conditional_state_error_msg .. "\n"
			success = false
		end
	end

	return success, error_msg
end

function _validate_running_action_state_to_action_input(weapon_template, action_settings)
	local running_action_state_to_action_input = action_settings.running_action_state_to_action_input

	if not running_action_state_to_action_input then
		return true, ""
	end

	local WeaponActionHandlerData = require("scripts/settings/equipment/weapon_action_handler_data")
	local action_kind_to_running_action_chain_event = WeaponActionHandlerData.action_kind_to_running_action_chain_event
	local action_kind = action_settings.kind
	local allowed_running_action_chain_events = action_kind_to_running_action_chain_event[action_kind]
	local action_inputs = weapon_template.action_inputs
	local success = true
	local error_msg = ""

	if running_action_state_to_action_input and not allowed_running_action_chain_events then
		success = false
		error_msg = string.format("Action kind %q defines running_action_state_to_action_input, but there's no mapping for it in WeaponActionHandlerData.action_kind_to_running_action_chain_event", action_kind)
	end

	if success then
		for running_action_event, config in pairs(running_action_state_to_action_input) do
			local running_action_chain_event_success = true
			local running_action_chain_event_error_msg = string.format("%q -> ", tostring(running_action_event))

			if type(running_action_event) ~= "string" then
				running_action_chain_event_success = false
				running_action_chain_event_error_msg = running_action_chain_event_error_msg .. "key is not a string. "
			end

			if not allowed_running_action_chain_events[running_action_event] then
				running_action_chain_event_success = false
				running_action_chain_event_error_msg = running_action_chain_event_error_msg .. string.format("%q is not a valid running action chain event for action kind %q. ", running_action_event, action_kind)
			end

			local input_name = config.input_name

			if input_name then
				if not action_inputs[input_name] then
					running_action_chain_event_success = false
					running_action_chain_event_error_msg = running_action_chain_event_error_msg .. "input_name is not defined in action_input table. "
				end
			else
				running_action_chain_event_success = false
				running_action_chain_event_error_msg = running_action_chain_event_error_msg .. "missing input_name. "
			end

			if not running_action_chain_event_success then
				error_msg = error_msg .. running_action_chain_event_error_msg .. "\n"
				success = false
			end
		end
	end

	return success, error_msg
end

function _validate_reachable_actions(weapon_template, action_settings)
	local reachable_from_start_input = false
	local reachable_from_chain_action = false
	local reachable_from_conditional_state = false
	local reachable_from_overheat_configuration = false
	local reachable_from_warp_explode_configuration = false
	local reachable_from_mandatory = false
	local start_input = action_settings.start_input

	if start_input then
		local action_inputs = weapon_template.action_inputs

		if action_inputs[start_input] then
			reachable_from_start_input = true
		end
	end

	local actions = weapon_template.actions

	for other_action_name, other_action_settings in pairs(actions) do
		if other_action_name ~= action_settings.name then
			local allowed_chain_actions = other_action_settings.allowed_chain_actions or EMPTY_TABLE

			for _, chain_action in pairs(allowed_chain_actions) do
				if chain_action.action_name == action_settings.name then
					reachable_from_chain_action = true
				else
					for _, sub_chain_action in ipairs(chain_action) do
						if sub_chain_action.action_name == action_settings.name then
							reachable_from_chain_action = true
						end
					end
				end
			end
		end
	end

	local conditional_state_to_action = weapon_template.conditional_state_to_action_input

	if conditional_state_to_action then
		for _, conditional_action in pairs(conditional_state_to_action) do
			if conditional_action.action_name == action_settings.name then
				reachable_from_conditional_state = true
			end
		end
	end

	local overheat_configuration = weapon_template.overheat_configuration

	if overheat_configuration then
		local explode_action = overheat_configuration.explode_action

		if explode_action == action_settings.name then
			reachable_from_overheat_configuration = true
		end
	end

	local archetype_warp_explode_action_override = weapon_template.archetype_warp_explode_action_override

	if archetype_warp_explode_action_override and archetype_warp_explode_action_override == action_settings.name then
		reachable_from_warp_explode_configuration = true
	end

	if MANDATORY_ACTIONS[action_settings.name] then
		reachable_from_mandatory = true
	end

	local debug_string = ""

	if start_input and not reachable_from_start_input then
		debug_string = debug_string .. string.format("start_input %q does not exist as an action_input. ", start_input)
	end

	if not start_input and not reachable_from_chain_action then
		debug_string = debug_string .. "no action chains into this action. "
	end

	if not start_input and not reachable_from_conditional_state then
		debug_string = debug_string .. "no conditional_state is setup for this action. "
	end

	if not start_input and not reachable_from_overheat_configuration then
		debug_string = debug_string .. "no overheat_configuration refering to this action. "
	end

	if not start_input and not reachable_from_mandatory then
		debug_string = debug_string .. "is not a mandatory action. "
	end

	local success = reachable_from_start_input or reachable_from_chain_action or reachable_from_conditional_state or reachable_from_overheat_configuration or reachable_from_warp_explode_configuration or reachable_from_mandatory

	return success, debug_string
end

function _state_machine_settings_test(weapon_template)
	local error_msg = ""
	local success = true
	local used_state_machines = {}

	for breed_name, breed in pairs(Breeds) do
		if Breed.is_player(breed) then
			local breed_success = true
			local state_machine_3p, state_machine_1p = WeaponTemplate.state_machines(weapon_template, breed_name)

			if state_machine_3p then
				used_state_machines[state_machine_3p] = true
			else
				breed_success = false
				error_msg = string.format("%sNo third person state machine found for breed %q!\n", error_msg, breed_name)
			end

			if state_machine_1p then
				used_state_machines[state_machine_1p] = true
			else
				breed_success = false
				error_msg = string.format("%sNo first person state machine found for breed %q!\n", error_msg, breed_name)
			end

			if not breed_success then
				success = false
			end
		end
	end

	if success then
		for state_machine, _ in pairs(used_state_machines) do
			local settings_success, settings_error_msg = _check_state_machine_settings(state_machine)

			if not settings_success then
				success = false
				error_msg = string.format("%sstate_machine_settings test failed for state_machine %q - %s\n", error_msg, state_machine, settings_error_msg)
			end
		end
	end
end

function _check_state_machine_settings(state_machine)
	local state_machine_settings = PlayerUnitAnimationStateMachineSettings[state_machine]

	if not state_machine_settings then
		return false, "Missing state_machine_settings. Add them in player_unit_animation_state_machine_settings."
	end

	return true
end

function _validate_tweak_template_existence(weapon_template)
	local RecoilTemplates = require("scripts/settings/equipment/recoil_templates")
	local SpreadTemplates = require("scripts/settings/equipment/spread_templates")
	local SwayTemplates = require("scripts/settings/equipment/sway_templates")
	local SuppressionTemplates = require("scripts/settings/equipment/suppression_templates")
	local WeaponDodgeTemplates = require("scripts/settings/dodge/weapon_dodge_templates")
	local WeaponHandlingTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_handling_templates")
	local WeaponSprintTemplates = require("scripts/settings/sprint/weapon_sprint_templates")
	local WeaponStaminaTemplates = require("scripts/settings/stamina/weapon_stamina_templates")
	local WeaponToughnessTemplates = require("scripts/settings/toughness/weapon_toughness_templates")
	local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
	local WeaponAmmoTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_ammo_templates")
	local WeaponBurninatingTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_burninating_templates")
	local WeaponSizeOfFlameTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_size_of_flame_templates")
	local template_types = WeaponTweakTemplateSettings.template_types
	local template_success, template_error_msg
	local success = true
	local error_msg = ""

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.recoil, RecoilTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.spread, SpreadTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.sway, SwayTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.suppression, SuppressionTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.dodge, WeaponDodgeTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.sprint, WeaponSprintTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.stamina, WeaponStaminaTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.toughness, WeaponToughnessTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.weapon_handling, WeaponHandlingTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.charge, WeaponHandlingTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.ammo, WeaponAmmoTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.burninating, WeaponBurninatingTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	template_success, template_error_msg = _check_tweak_template_existence(weapon_template, template_types.size_of_flame, WeaponSizeOfFlameTemplates)

	if not template_success then
		error_msg = string.format("%s%s", error_msg, template_error_msg)
		success = false
	end

	return true
end

function _check_tweak_template_existence(weapon_template, template_type, source_templates)
	local success = true
	local error_msg = ""
	local key = template_type .. "_template"
	local base_template_lookup = weapon_template.__base_template_lookup
	local alternate_fire_settings = weapon_template.alternate_fire_settings

	if alternate_fire_settings then
		base_template_lookup.__locked = false

		local templates = base_template_lookup[template_type]
		local template_name = alternate_fire_settings[key]
		local template_lookup = templates.__data.alternate_fire

		if template_lookup and template_name then
			local base_template_name = template_lookup.base_identifier

			source_templates.__locked = false

			if not source_templates[base_template_name] then
				success = false
				error_msg = string.format("%s\nalternate_fire template named %q for type %q does not exist. Has it been added to the relevant parent template lua file?", error_msg, base_template_name, template_type)
			end
		end
	end

	base_template_lookup.__locked = false

	local templates = base_template_lookup[template_type]
	local template_name = weapon_template[key]
	local template_lookup = templates.__data.base

	if template_lookup and template_name then
		local base_template_name = template_lookup.base_identifier

		source_templates.__locked = false

		if not source_templates[base_template_name] then
			success = false
			error_msg = string.format("%s\nTemplate named %q for type %q does not exist. Has it been added to the relevant parent template lua file?", error_msg, base_template_name, template_type)
		end
	end

	return success, error_msg
end

function _stat_and_perk_verification(weapon_template)
	local base_stats = weapon_template.base_stats
	local perks = weapon_template.perks

	if not base_stats and not perks then
		return
	end

	local error_msgs = {}

	if base_stats then
		for name, stat in pairs(base_stats) do
			local success, stat_error_msgs = _stat_verification(stat, weapon_template)

			if not success then
				local error_msg = string.format("stat %q failed:", name)

				for _, stat_error in ipairs(stat_error_msgs) do
					error_msg = string.format("%s\n\t%s", error_msg, stat_error)
				end

				error_msgs[#error_msgs + 1] = error_msg
			end
		end
	end

	if perks then
		for name, perk in pairs(perks) do
			local success, perk_error_msgs = _stat_verification(perk, weapon_template)

			if not success then
				local error_msg = string.format("perk %q failed:", name)

				for _, perk_error in ipairs(perk_error_msgs) do
					error_msg = string.format("%s\n\t%s", error_msg, perk_error)
				end

				error_msgs[#error_msgs + 1] = error_msg
			end
		end
	end

	if #error_msgs > 0 then
		local error_msg = string.format("WeaponTemplate %q failed stat_and_perk_verification test.", weapon_template.name)

		for _, error in ipairs(error_msgs) do
			error_msg = string.format("%s\n%s", error_msg, error)
		end

		ferror(error_msg)
	end
end

function _stat_verification(stat, weapon_template)
	local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
	local template_types = WeaponTweakTemplateSettings.template_types
	local base_template_lookup = weapon_template.__base_template_lookup
	local error_msgs = {}

	for _, template_type in pairs(template_types) do
		local targets = stat[template_type]

		if targets then
			local lookup = base_template_lookup[template_type]
			local valid_targets = ""
			local iterator = pairs

			for target_name, _ in iterator(lookup) do
				valid_targets = string.format("%s %q", valid_targets, target_name)
			end

			for target_name, _ in pairs(targets) do
				local lookup_entry = lookup[target_name]

				if not lookup_entry then
					if #valid_targets == 0 then
						error_msgs[#error_msgs + 1] = string.format("template_type %q could not find valid target %q. there are no valid targets for the given template_type!", template_type, target_name)
					else
						error_msgs[#error_msgs + 1] = string.format("template_type %q could not find valid target %q. either the target is misspelled or there's no template setup at the target. valid_targets =%s.", template_type, target_name, valid_targets)
					end
				end
			end
		end
	end

	return #error_msgs == 0, error_msgs
end

return weapon_template_tests
