local function _require_ability_action(action)
	local base = "scripts/extension_systems/ability/actions/"
	local action_file_name = base .. action
	local class = require(action_file_name)

	return class
end

local ability_action_data = {
	actions = {
		character_state_change = _require_ability_action("action_character_state_change"),
		linear_aim = _require_ability_action("action_linear_aim"),
		proximity_tag = _require_ability_action("action_proximity_tag"),
		shout = _require_ability_action("action_shout"),
		psyker_shout = _require_ability_action("action_psyker_shout"),
		stance_change = _require_ability_action("action_stance_change"),
		stance_change_gunlugger = _require_ability_action("action_stance_change"),
		targeted_dash_aim = _require_ability_action("action_targeted_dash_aim")
	}
}

local function _can_use_ability_check(action_settings, condition_func_params, used_input)
	local ability_extension = condition_func_params.ability_extension
	local ability_type = action_settings.ability_type

	if not ability_extension:can_use_ability(ability_type) then
		return false
	end

	return true
end

ability_action_data.action_kind_condition_funcs = {
	proximity_tag = _can_use_ability_check,
	shout = _can_use_ability_check,
	psyker_shout = _can_use_ability_check,
	stance_change = _can_use_ability_check,
	stance_change_gunlugger = _can_use_ability_check,
	targeted_dash_aim = _can_use_ability_check,
	linear_aim = function (action_settings, condition_func_params, used_input)
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
	character_state_change = function (action_settings, condition_func_params, used_input)
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
	end
}
ability_action_data.action_kind_total_time_funcs = {}
ability_action_data.conditional_state_functions = {}

for name, _ in pairs(ability_action_data.action_kind_condition_funcs) do
	-- Nothing
end

for name, _ in pairs(ability_action_data.action_kind_total_time_funcs) do
	-- Nothing
end

return ability_action_data
