local AchievementTypes = require("scripts/settings/achievements/achievement_types")
local AchievementStatTrigger = class("AchievementStatTrigger")
AchievementStatTrigger.INTERFACE = {
	"_default_value",
	"_check_complete"
}

AchievementStatTrigger.init = function (self, stat_definition, target)
	self._stat_name = stat_definition:get_id()
	self._triggers = {
		stat_definition:get_id()
	}
	self._target = target
end

AchievementStatTrigger.destroy = function (self)
	return
end

AchievementStatTrigger.trigger = function (self, _, trigger_type, stat_name, stat_value)
	if trigger_type ~= AchievementTypes.stat then
		return false
	end

	if stat_name ~= self._stat_name then
		return false
	end

	return self:_check_complete(stat_value)
end

AchievementStatTrigger.get_triggers = function (self)
	return AchievementTypes.stat, self._triggers
end

AchievementStatTrigger.get_target = function (self)
	return self._target
end

AchievementStatTrigger.get_progress = function (self, constant_achievement_data)
	return constant_achievement_data.stats[self._stat_name] or self:_default_value()
end

AchievementStatTrigger.get_related_achievements = function (self)
	return
end

return AchievementStatTrigger
