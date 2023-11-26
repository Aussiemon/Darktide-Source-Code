-- chunkname: @scripts/managers/achievements/platforms/no_platform_achievement.lua

local Promise = require("scripts/foundation/utilities/promise")
local NoPlatformAchievement = class("NoPlatformAchievement")

NoPlatformAchievement.init = function (self, definitions)
	return Promise.resolved()
end

NoPlatformAchievement.destroy = function (self)
	return Promise.resolved()
end

NoPlatformAchievement.is_platform_achievement = function (self, achievement_definition)
	return false
end

NoPlatformAchievement.unlock = function (self, achievement_definition)
	return Promise.rejected()
end

NoPlatformAchievement.is_unlocked = function (self, achievement_definition)
	return false
end

NoPlatformAchievement.set_progress = function (self, achievement_definition, progress)
	return Promise.rejected()
end

NoPlatformAchievement.get_progress = function (self, achievement_definition)
	return nil
end

return NoPlatformAchievement
