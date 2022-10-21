local AbilityActionHandlerData = require("scripts/settings/ability/ability_action_handler_data")
local WeaponActionHandlerData = require("scripts/settings/equipment/weapon_action_handler_data")
local weapon_actions = WeaponActionHandlerData.actions
local ability_actions = AbilityActionHandlerData.actions

local function action_handler_settings_tests(action_handler_settings)
	local disallowed_action_kinds_during_lunge = action_handler_settings.disallowed_action_kinds_during_lunge

	for i = 1, #disallowed_action_kinds_during_lunge do
		local kind = disallowed_action_kinds_during_lunge[i]
		local action_class = weapon_actions[kind] or ability_actions[kind]
	end

	local allowed_action_kinds_during_sprint = action_handler_settings.allowed_action_kinds_during_sprint

	for i = 1, #allowed_action_kinds_during_sprint do
		local kind = allowed_action_kinds_during_sprint[i]
		local action_class = weapon_actions[kind] or ability_actions[kind]
	end

	local allowed_action_kinds_during_sprint = action_handler_settings.allowed_action_kinds_during_sprint

	for i = 1, #allowed_action_kinds_during_sprint do
		local kind = allowed_action_kinds_during_sprint[i]
		local action_class = weapon_actions[kind] or ability_actions[kind]
	end

	local abort_sprint = action_handler_settings.abort_sprint

	for i = 1, #abort_sprint do
		local kind = abort_sprint[i]
		local action_class = weapon_actions[kind] or ability_actions[kind]
	end

	local prevent_sprint = action_handler_settings.prevent_sprint

	for i = 1, #prevent_sprint do
		local kind = prevent_sprint[i]
		local action_class = weapon_actions[kind] or ability_actions[kind]
	end
end

return action_handler_settings_tests
