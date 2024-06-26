-- chunkname: @scripts/managers/achievements/achievement_platforms.lua

local BasePlatformAchievement = require("scripts/managers/achievements/platforms/base_platform_achievement")
local SteamPlatformAchievement = require("scripts/managers/achievements/platforms/steam_platform_achievement")
local XboxPlatformAchievement = require("scripts/managers/achievements/platforms/xbox_platform_achievement")
local AchievementPlatforms = setmetatable({}, {
	__index = function ()
		return BasePlatformAchievement
	end,
})

AchievementPlatforms[Backend.AUTH_METHOD_XBOXLIVE] = XboxPlatformAchievement
AchievementPlatforms[Backend.AUTH_METHOD_STEAM] = SteamPlatformAchievement

return AchievementPlatforms
