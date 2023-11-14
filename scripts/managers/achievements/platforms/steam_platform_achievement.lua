local Promise = require("scripts/foundation/utilities/promise")
local SteamPlatformAchievement = class("SteamPlatformAchievement")

SteamPlatformAchievement.init = function (self, definitions)
	return Promise.resolved()
end

SteamPlatformAchievement.destroy = function (self)
	return Promise.resolved()
end

SteamPlatformAchievement._get_platform_id = function (self, achievement_definition)
	local steam_data = achievement_definition.steam
	local platform_id = steam_data and steam_data.id

	return platform_id
end

SteamPlatformAchievement._get_platform_stat_id = function (self, achievement_definition)
	local steam_data = achievement_definition.steam
	local platform_stat_id = steam_data and steam_data.stat_id

	return platform_stat_id
end

SteamPlatformAchievement.is_platform_achievement = function (self, achievement_definition)
	return self:_get_platform_id(achievement_definition) ~= nil
end

SteamPlatformAchievement.unlock = function (self, achievement_definition)
	local platform_id = self:_get_platform_id(achievement_definition)

	if platform_id and Achievement.unlock(platform_id) then
		return Promise.resolved()
	end

	return Promise.rejected()
end

SteamPlatformAchievement.is_unlocked = function (self, achievement_definition)
	local platform_id = self:_get_platform_id(achievement_definition)

	return platform_id ~= nil and Achievement.unlocked(platform_id)
end

SteamPlatformAchievement.set_progress = function (self, achievement_definition, progress)
	local platform_id = self:_get_platform_id(achievement_definition)
	local platform_stat_id = self:_get_platform_stat_id(achievement_definition)

	if not platform_id or not platform_stat_id then
		return Promise.rejected()
	end

	progress = math.floor(progress)

	Stats.set(platform_stat_id, progress)

	return Promise.resolved()
end

SteamPlatformAchievement.get_progress = function (self, achievement_definition)
	local platform_id = self:_get_platform_id(achievement_definition)
	local platform_stat_id = self:_get_platform_stat_id(achievement_definition)

	if not platform_id or not platform_stat_id then
		Log.warning("SteamPlatformAchievement", "Achievement '%s' couldn't be read. Missing platform data.", achievement_definition.id)

		return nil
	end

	local progress, error = Stats.get(platform_stat_id)

	if error then
		Log.warning("SteamPlatformAchievement", "Achievement '%s' couldn't be read. %s", achievement_definition.id, error)

		return nil
	end

	return progress
end

return SteamPlatformAchievement
