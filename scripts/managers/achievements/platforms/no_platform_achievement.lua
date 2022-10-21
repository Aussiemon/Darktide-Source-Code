local Promise = require("scripts/foundation/utilities/promise")
local PlatformAchievementInterface = require("scripts/managers/achievements/platforms/platform_achievement_interface")
local NoPlatformAchievement = class("NoPlatformAchievement")

NoPlatformAchievement.init = function (self)
	return Promise.resolved()
end

NoPlatformAchievement.unlock_achievement = function (self, achievement_id)
	return false
end

NoPlatformAchievement.update_progress = function (self, achievement_id, value, target)
	return false
end

NoPlatformAchievement.is_unlocked = function (self, achievement_id)
	return false
end

NoPlatformAchievement.get_progress = function (self, achievement_id)
	return nil
end

NoPlatformAchievement.is_platform_achievement = function (self, achievement_id)
	return false
end

implements(NoPlatformAchievement, PlatformAchievementInterface)

return NoPlatformAchievement
