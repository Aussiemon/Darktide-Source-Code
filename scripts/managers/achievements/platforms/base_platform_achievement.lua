-- chunkname: @scripts/managers/achievements/platforms/base_platform_achievement.lua

local Promise = require("scripts/foundation/utilities/promise")
local BasePlatformAchievement = class("BasePlatformAchievement")

BasePlatformAchievement.init = function (self, definitions)
	return Promise.resolved()
end

BasePlatformAchievement.destroy = function (self)
	return Promise.resolved()
end

BasePlatformAchievement.is_platform_achievement = function (self, achievement_definition)
	return false
end

BasePlatformAchievement.unlock = function (self, achievement_definition)
	return Promise.rejected()
end

BasePlatformAchievement.is_unlocked = function (self, achievement_definition)
	return false
end

BasePlatformAchievement.set_progress = function (self, achievement_definition, progress)
	return Promise.rejected()
end

BasePlatformAchievement.get_progress = function (self, achievement_definition)
	return nil
end

return BasePlatformAchievement
