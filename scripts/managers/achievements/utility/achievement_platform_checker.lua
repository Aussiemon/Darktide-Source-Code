local SteamPlatformAchievements = require("scripts/settings/achievements/steam_platform_achievements")
local XboxLivePlatformAchievements = require("scripts/settings/achievements/xbox_live_platform_achievements")
local AchievementPlatformChecker = {
	is_steam_plaform_achievement = function (achievement_id)
		return SteamPlatformAchievements.backend_to_platform[achievement_id] ~= nil
	end,
	is_xbox_live_plaform_achievement = function (achievement_id)
		return XboxLivePlatformAchievements.backend_to_platform[achievement_id] ~= nil
	end
}

AchievementPlatformChecker.is_any_plaform_achievement = function (achievement_id)
	local is_steam_achievement = AchievementPlatformChecker.is_steam_plaform_achievement(achievement_id)
	local is_xbox_live_achievement = AchievementPlatformChecker.is_xbox_live_plaform_achievement(achievement_id)

	return is_steam_achievement or is_xbox_live_achievement
end

return AchievementPlatformChecker
