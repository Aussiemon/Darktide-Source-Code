local TriggerInterface = require("scripts/managers/achievements/triggers/achievement_trigger_interface")
local StatTrigger = require("scripts/managers/achievements/triggers/achievement_stat_trigger")
local AchievementDecreasingStatTrigger = class("AchievementDecreasingStatTrigger", "AchievementStatTrigger")

AchievementDecreasingStatTrigger._check_complete = function (self, stat_value)
	return stat_value <= self._target
end

AchievementDecreasingStatTrigger._default_value = function (self)
	return math.huge
end

implements(AchievementDecreasingStatTrigger, TriggerInterface, StatTrigger.INTERFACE)

return AchievementDecreasingStatTrigger
