-- chunkname: @scripts/managers/achievements/achievement_platforms.lua

local NoPlatformAchievement = require("scripts/managers/achievements/platforms/no_platform_achievement")
local SteamPlatformAchievement = require("scripts/managers/achievements/platforms/steam_platform_achievement")
local XboxPlatformAchievement = require("scripts/managers/achievements/platforms/xbox_platform_achievement")
local AchievementPlatforms = setmetatable({}, {
	__index = function ()
		return NoPlatformAchievement
	end
})

AchievementPlatforms[Backend.AUTH_METHOD_XBOXLIVE] = XboxPlatformAchievement
AchievementPlatforms[Backend.AUTH_METHOD_STEAM] = SteamPlatformAchievement

return AchievementPlatforms
