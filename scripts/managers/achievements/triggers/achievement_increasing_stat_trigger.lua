local TriggerInterface = require("scripts/managers/achievements/triggers/achievement_trigger_interface")
local StatTrigger = require("scripts/managers/achievements/triggers/achievement_stat_trigger")
local AchievementIncreasingStatTrigger = class("AchievementIncreasingStatTrigger", "AchievementStatTrigger")

AchievementIncreasingStatTrigger._check_complete = function (self, stat_value)
	return self._target <= stat_value
end

AchievementIncreasingStatTrigger._default_value = function (self)
	return 0
end

implements(AchievementIncreasingStatTrigger, TriggerInterface, StatTrigger.INTERFACE)

return AchievementIncreasingStatTrigger
