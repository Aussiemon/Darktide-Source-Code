local ActionHandlerSettings = require("scripts/settings/action/action_handler_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local group_keywords = BuffSettings.group_keywords
local group_to_keywords = BuffSettings.group_to_keywords
local ActionAvailability = {}
local _buff_keyword_allows_action_during_sprint = nil
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

for ii = 1, #ActionHandlerSettings.allowed_action_kinds_during_sprint do
	local action_kind = ActionHandlerSettings.allowed_action_kinds_during_sprint[ii]
	allowed_action_kinds_during_sprint[action_kind] = true
end

ActionAvailability.available_in_sprint = function (action_settings, buff_extension)
	local buff_keyword_allows_action_during_sprint = _buff_keyword_allows_action_during_sprint(action_settings, buff_extension)
	local action_settings_allowed_during_sprint = action_settings.allowed_during_sprint

	if not buff_keyword_allows_action_during_sprint then
		if action_settings_allowed_during_sprint ~= nil then
			if not action_settings_allowed_during_sprint then
				return false
			end
		elseif not allowed_action_kinds_during_sprint[action_settings.kind] then
			return false
		end
	end

	return true, buff_keyword_allows_action_during_sprint
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

ActionAvailability.allowed_while_exploding = function (action_settings)
	if not action_settings.allowed_during_explode then
		return false
	end

	return true
end

function _buff_keyword_allows_action_during_sprint(action_settings, buff_extension)
	local action_buff_keywords = action_settings.buff_keywords

	if action_buff_keywords and buff_extension then
		local grouped_keywords = group_to_keywords[group_keywords.allow_action_during_sprint]

		for ii = 1, #action_buff_keywords do
			local keyword = action_buff_keywords[ii]

			if grouped_keywords[keyword] and buff_extension:has_keyword(keyword) then
				return true
			end
		end
	end
end

local combo_increase_actions = {}

for ii = 1, #ActionHandlerSettings.combo_increase do
	local action_kind = ActionHandlerSettings.combo_increase[ii]
	combo_increase_actions[action_kind] = true
end

ActionAvailability.increases_action_combo = function (action_settings)
	if action_settings.increase_combo ~= nil then
		return action_settings.increase_combo
	end

	return combo_increase_actions[action_settings.kind]
end

local combo_hold_actions = {}

for ii = 1, #ActionHandlerSettings.combo_hold do
	local action_kind = ActionHandlerSettings.combo_hold[ii]
	combo_hold_actions[action_kind] = true
end

ActionAvailability.holds_action_combo = function (action_settings)
	if action_settings.hold_combo ~= nil then
		return action_settings.hold_combo
	end

	return combo_hold_actions[action_settings.kind]
end

return ActionAvailability
