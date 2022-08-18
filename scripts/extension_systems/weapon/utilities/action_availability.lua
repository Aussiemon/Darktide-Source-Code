local ActionHandlerSettings = require("scripts/settings/action/action_handler_settings")
local ActionAvailability = {}
local disallowed_action_kinds_during_lunge = {}

for i = 1, #ActionHandlerSettings.disallowed_action_kinds_during_lunge do
	local action_kind = ActionHandlerSettings.disallowed_action_kinds_during_lunge[i]
	disallowed_action_kinds_during_lunge[action_kind] = true
end

ActionAvailability.available_in_lunge = function (action_settings)
	local action_settings_allowed_during_lunge = action_settings.allowed_during_lunge

	if action_settings_allowed_during_lunge ~= nil then
		if not action_settings_allowed_during_lunge then
			return false
		end
	elseif disallowed_action_kinds_during_lunge[action_settings.kind] then
		return false
	end

	return true
end

local allowed_action_kinds_during_sprint = {}

for i = 1, #ActionHandlerSettings.allowed_action_kinds_during_sprint do
	local action_kind = ActionHandlerSettings.allowed_action_kinds_during_sprint[i]
	allowed_action_kinds_during_sprint[action_kind] = true
end

ActionAvailability.available_in_sprint = function (action_settings)
	local action_settings_allowed_during_sprint = action_settings.allowed_during_sprint

	if action_settings_allowed_during_sprint ~= nil then
		if not action_settings_allowed_during_sprint then
			return false
		end
	elseif not allowed_action_kinds_during_sprint[action_settings.kind] then
		return false
	end

	return true
end

ActionAvailability.allowed_without_smite_target = function (action_settings)
	local action_settings_only_allowed_with_target = action_settings.only_allowed_with_smite_target

	if action_settings_only_allowed_with_target ~= nil and action_settings_only_allowed_with_target then
		return false
	end

	return true
end

ActionAvailability.needs_ammo = function (action_settings)
	if not action_settings.ammunition_usage or action_settings.ammunition_usage == 0 then
		return false
	end

	return true
end

return ActionAvailability
