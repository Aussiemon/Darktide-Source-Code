local AchievementTypes = require("scripts/settings/achievements/achievement_types")
local TriggerInterface = require("scripts/managers/achievements/triggers/achievement_trigger_interface")
local AchievementMetaTrigger = class("AchievementMetaTrigger")

AchievementMetaTrigger.init = function (self, achievement_array, optional_target)
	self._achievement_array = achievement_array
	self._target = optional_target or #achievement_array
end

AchievementMetaTrigger.destroy = function (self)
	return
end

AchievementMetaTrigger.trigger = function (self, constant_achievement_data)
	local amount_completed = self:get_progress(constant_achievement_data)

	return self._target <= amount_completed
end

AchievementMetaTrigger.get_triggers = function (self)
	return AchievementTypes.meta, self._achievement_array
end

AchievementMetaTrigger.get_target = function (self)
	return self._target
end

AchievementMetaTrigger.get_progress = function (self, constant_achievement_data)
	local completed = constant_achievement_data.completed
	local amount_completed = 0

	for i = 1, #self._achievement_array do
		local id = self._achievement_array[i]

		if completed[id] then
			amount_completed = amount_completed + 1
		end
	end

	return math.min(amount_completed, self._target)
end

AchievementMetaTrigger.get_related_achievements = function (self)
	return self._achievement_array
end

implements(AchievementMetaTrigger, TriggerInterface)

return AchievementMetaTrigger
