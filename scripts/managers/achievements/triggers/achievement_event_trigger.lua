local AchievementTypes = require("scripts/settings/achievements/achievement_types")
local TriggerInterface = require("scripts/managers/achievements/triggers/achievement_trigger_interface")
local AchievementEventTrigger = class("AchievementEventTrigger")

AchievementEventTrigger.init = function (self, event_name, optional_keys, optional_values)
	self._event_name = event_name
	self._triggers = {
		event_name
	}
	self._keys = optional_keys or {}
	self._values = optional_values or {}
end

AchievementEventTrigger.destroy = function (self)
	return
end

AchievementEventTrigger.trigger = function (self, constant_achievement_data, trigger_type, event_name, event_params)
	if trigger_type ~= AchievementTypes.event then
		return false
	end

	if event_name ~= self._event_name then
		return false
	end

	for i = 1, #self._keys, 1 do
		local real_value = event_params[self._keys[i]]
		local expected_value = self._values[i]

		if real_value ~= expected_value then
			return false
		end
	end

	return true
end

AchievementEventTrigger.get_triggers = function (self)
	return AchievementTypes.event, self._triggers
end

AchievementEventTrigger.get_target = function (self)
	return 1
end

AchievementEventTrigger.get_progress = function (self, constant_achievement_data)
	return 0
end

AchievementEventTrigger.get_related_achievements = function (self)
	return
end

implements(AchievementEventTrigger, TriggerInterface)

return AchievementEventTrigger
