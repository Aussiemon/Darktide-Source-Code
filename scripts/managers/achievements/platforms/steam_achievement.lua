local Promise = require("scripts/foundation/utilities/promise")
local PlatformAchievementInterface = require("scripts/managers/achievements/platforms/platform_achievement_interface")
local SteamPlatformAchievements = require("scripts/settings/achievements/steam_platform_achievements")
local SteamAchievement = class("SteamAchievement")

local function _get_platform_id(achievement_id)
	return SteamPlatformAchievements.backend_to_platform[achievement_id]
end

local function _get_stat_id(platform_id)
	return SteamPlatformAchievements.platform_to_stat[platform_id]
end

SteamAchievement.init = function (self)
	return Promise.resolved()
end

SteamAchievement.unlock_achievement = function (self, achievement_id)
	local platform_id = _get_platform_id(achievement_id)

	if platform_id and Achievement.unlock(platform_id) then
		return true
	end

	return false
end

SteamAchievement.update_progress = function (self, achievement_id, value, target)
	local platform_id = _get_platform_id(achievement_id)
	local stat_id = _get_stat_id(platform_id)
	value = math.floor(value)

	if stat_id and Stats.set(stat_id, value) then
		return true
	end

	return false
end

SteamAchievement.is_unlocked = function (self, achievement_id)
	local platform_id = _get_platform_id(achievement_id)

	return platform_id ~= nil and Achievement.unlocked(platform_id)
end

SteamAchievement.get_progress = function (self, achievement_id)
	local platform_id = _get_platform_id(achievement_id)
	local stat_id = _get_stat_id(platform_id)

	if stat_id then
		local value, error = Stats.get(stat_id)

		if error then
			Log.warning("SteamAchievement", "Error when getting progress for '%s': '%s'.", achievement_id, error)

			return nil
		end

		return value
	end

	return nil
end

SteamAchievement.is_platform_achievement = function (self, achievement_id)
	return _get_platform_id(achievement_id) ~= nil
end

implements(SteamAchievement, PlatformAchievementInterface)

return SteamAchievement
