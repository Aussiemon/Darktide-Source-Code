local TriggerInterface = require("scripts/managers/achievements/triggers/achievement_trigger_interface")
local AchievementBackendTrigger = class("AchievementBackendTrigger")

AchievementBackendTrigger.init = function (self, _, target)
	self._target = target or 1
end

AchievementBackendTrigger.destroy = function (self)
	return
end

AchievementBackendTrigger.trigger = function (self)
	return false
end

AchievementBackendTrigger.get_triggers = function (self)
	return
end

AchievementBackendTrigger.get_target = function (self)
	return self._target
end

AchievementBackendTrigger.get_progress = function (self, constant_achievement_data)
	return 0
end

AchievementBackendTrigger.get_related_achievements = function (self)
	return nil
end

implements(AchievementBackendTrigger, TriggerInterface)

return AchievementBackendTrigger
