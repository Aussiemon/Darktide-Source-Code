-- chunkname: @scripts/settings/ability/ability_action_handler_data.lua

local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSettings.special_rules

local function _require_ability_action(action)
	local base = "scripts/extension_systems/ability/actions/"
	local action_file_name = base .. action
	local class = require(action_file_name)

	return class
end

local ability_action_data = {}

ability_action_data.actions = {
	ability_target_finder = _require_ability_action("action_ability_target_finder"),
	servo_skull_order_target_finder = _require_ability_action("action_servo_skull_order_target_finder"),
	activate_force_shield = _require_ability_action("action_activate_force_shield"),
	adamant_shout = _require_ability_action("action_adamant_shout"),
	character_state_change = _require_ability_action("action_character_state_change"),
	companion_start_ability = _require_ability_action("action_companion_start_ability"),
	cryptic_chordclaw = _require_ability_action("action_cryptic_chordclaw"),
	cryptic_chordclaw_charge = _require_ability_action("action_cryptic_chordclaw_charge"),
	cryptic_discharge = _require_ability_action("action_cryptic_discharge"),
	cryptic_precision_stance_toggle = _require_ability_action("action_cryptic_precision_stance_toggle"),
	directional_dash_aim = _require_ability_action("action_directional_dash_aim"),
	ogryn_shout = _require_ability_action("action_ogryn_shout"),
	order_companion = _require_ability_action("action_order_companion"),
	psyker_shout = _require_ability_action("action_psyker_shout"),
	servo_skull_select_action = _require_ability_action("action_servo_skull_select_action"),
	shout_aim = _require_ability_action("action_shout_aim"),
	stance_change = _require_ability_action("action_stance_change"),
	stance_change_gunlugger = _require_ability_action("action_stance_change"),
	targeted_dash_aim = _require_ability_action("action_targeted_dash_aim"),
	veteran_combat_ability = _require_ability_action("action_veteran_combat_ability"),
	veteran_immediate_use = _require_ability_action("action_shout_aim"),
	veteran_shout_aim = _require_ability_action("action_shout_aim"),
}

local function _can_use_ability_check(action_settings, condition_func_params, used_input, t, time_in_action)
	local ability_extension = condition_func_params.ability_extension
	local ability_type = action_settings.ability_type

	return ability_extension:can_use_ability(ability_type)
end

ability_action_data.action_kind_condition_funcs = {
	ogryn_shout = _can_use_ability_check,
	psyker_shout = _can_use_ability_check,
	shout_aim = _can_use_ability_check,
	veteran_shout_aim = function (action_settings, condition_func_params, used_input, t, time_in_action)
		local can_use_ability = _can_use_ability_check(action_settings, condition_func_params, used_input)

		if not can_use_ability then
			return false
		end

		local stagger_nearby_enemies = condition_func_params.talent_extension:has_special_rule(special_rules.veteran_combat_ability_stagger_nearby_enemies)

		return stagger_nearby_enemies
	end,
	veteran_immediate_use = function (action_settings, condition_func_params, used_input, t, time_in_action)
		local can_use_ability = _can_use_ability_check(action_settings, condition_func_params, used_input)

		if not can_use_ability then
			return false
		end

		local stagger_nearby_enemies = condition_func_params.talent_extension:has_special_rule(special_rules.veteran_combat_ability_stagger_nearby_enemies)

		return not stagger_nearby_enemies
	end,
	stance_change = _can_use_ability_check,
	stance_change_gunlugger = _can_use_ability_check,
	targeted_dash_aim = _can_use_ability_check,
	ability_target_finder = function (action_settings, condition_func_params, used_input, t, time_in_action)
		return true
	end,
	servo_skull_order_target_finder = function (action_settings, condition_func_params, used_input, t, time_in_action)
		return true
	end,
	veteran_combat_ability = _can_use_ability_check,
	directional_dash_aim = function (action_settings, condition_func_params, used_input, t, time_in_action)
		local can_use_ability = _can_use_ability_check(action_settings, condition_func_params, used_input)

		if not can_use_ability then
			return false
		end

		local unit_data_extension = condition_func_params.unit_data_extension
		local character_sate_component = unit_data_extension:read_component("character_state")
		local current_state_name = character_sate_component.state_name
		local wanted_state_name = "lunging"
		local is_in_wanted_state = current_state_name == wanted_state_name

		if is_in_wanted_state then
			return false
		end

		return true
	end,
	character_state_change = function (action_settings, condition_func_params, used_input, t, time_in_action)
		local can_use_ability = _can_use_ability_check(action_settings, condition_func_params, used_input)

		if not can_use_ability then
			return false
		end

		local unit_data_extension = condition_func_params.unit_data_extension
		local character_sate_component = unit_data_extension:read_component("character_state")
		local current_state_name = character_sate_component.state_name
		local wanted_state_name = action_settings.state_name
		local is_in_wanted_state = current_state_name == wanted_state_name

		if is_in_wanted_state then
			return false
		end

		return true
	end,
	companion_start_ability = function (action_settings, condition_func_params, used_input, t, time_in_action)
		local can_use_ability = _can_use_ability_check(action_settings, condition_func_params, used_input)

		if not can_use_ability then
			return false
		end

		return true
	end,
	cryptic_discharge = _can_use_ability_check,
	cryptic_precision_stance_toggle = function (action_settings, condition_func_params, used_input, t, time_in_action)
		local unit_data_extension = condition_func_params.unit_data_extension
		local combat_ability_component = unit_data_extension:read_component("combat_ability")
		local can_use_ability = _can_use_ability_check(action_settings, condition_func_params, used_input)

		return combat_ability_component.active or can_use_ability
	end,
	cryptic_chordclaw = function (action_settings, condition_func_params, used_input, t, time_in_action)
		local can_use_ability = _can_use_ability_check(action_settings, condition_func_params, used_input)
		local unit_data_extension = condition_func_params.unit_data_extension
		local combat_ability_component = unit_data_extension:read_component("combat_ability")

		return not combat_ability_component.active and can_use_ability
	end,
	cryptic_chordclaw_charge = function (action_settings, condition_func_params, used_input, t, time_in_action)
		local can_use_ability = _can_use_ability_check(action_settings, condition_func_params, used_input)

		if not can_use_ability then
			return false
		end

		local ability_extension = condition_func_params.ability_extension
		local talent_extension = condition_func_params.talent_extension
		local ability_charges_remaining = ability_extension:remaining_ability_charges("combat_ability")
		local unit_data_extension = condition_func_params.unit_data_extension
		local combat_ability_component = unit_data_extension:read_component("combat_ability")

		return not combat_ability_component.active and can_use_ability
	end,
	activate_force_shield = _can_use_ability_check,
}
ability_action_data.action_kind_total_time_funcs = {}
ability_action_data.conditional_state_functions = {
	action_end = function (condition_func_params, action_params, remaining_time, t)
		local no_time_left = remaining_time <= 0

		return no_time_left
	end,
}

for name, _ in pairs(ability_action_data.action_kind_condition_funcs) do
	-- Nothing
end

for name, _ in pairs(ability_action_data.action_kind_total_time_funcs) do
	-- Nothing
end

return ability_action_data
