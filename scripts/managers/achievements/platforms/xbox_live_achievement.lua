local Promise = require("scripts/foundation/utilities/promise")
local PlatformAchievementInterface = require("scripts/managers/achievements/platforms/platform_achievement_interface")
local XboxLivePlatformAchievements = require("scripts/settings/achievements/xbox_live_platform_achievements")
local XboxLiveUtilities = require("scripts/foundation/utilities/xbox_live")
local XboxLiveAchievement = class("XboxLiveAchievement")

local function _get_platform_id(achievement_id)
	return XboxLivePlatformAchievements.backend_to_platform[achievement_id]
end

XboxLiveAchievement._set_progress = function (self, platform_id, percent)
	local current_percent = self._progress[platform_id] or 0
	local show_progress = XboxLivePlatformAchievements.show_progress[platform_id]

	if (percent == 100 or show_progress) and current_percent < percent then
		self._progress[platform_id] = percent

		XboxLiveUtilities.update_achievement(platform_id, percent)
	end
end

XboxLiveAchievement._get_progress = function (self, platform_id)
	return self._progress[platform_id] or 0
end

XboxLiveAchievement.init = function (self)
	local progress = {}
	self._progress = progress

	return XboxLiveUtilities.get_all_achievements():next(function (achievements_data)
		for i = 1, #achievements_data do
			local achievement = achievements_data[i]
			local id = tonumber(achievement.id)
			local progress_state = achievement.progress_state

			if progress_state == 1 then
				progress[id] = 100
			elseif progress_state == 2 then
				progress[id] = 0
			elseif progress_state == 3 then
				local requirement = achievement.progression and achievement.progression.requirements and achievement.progression.requirements[1]
				local progress_value = requirement and tonumber(requirement.current_progress_value)
				progress[id] = progress_value
			end
		end

		return nil
	end):catch(function (err)
		Log.error("XboxLiveAchievement", "Failed getting achievements progress from xbox live: %s", table.tostring(err))

		return Promise.resolved()
	end)
end

XboxLiveAchievement.unlock_achievement = function (self, achievement_id)
	local platform_id = _get_platform_id(achievement_id)

	if platform_id then
		self:_set_progress(platform_id, 100)

		return true
	end

	return false
end

XboxLiveAchievement.update_progress = function (self, achievement_id, value, target)
	local platform_id = _get_platform_id(achievement_id)
	local progress_in_percentage = math.floor(100 * value / target)

	if platform_id and progress_in_percentage < 100 then
		self:_set_progress(platform_id, progress_in_percentage)

		return true
	end

	return false
end

XboxLiveAchievement.is_unlocked = function (self, achievement_id)
	local platform_id = _get_platform_id(achievement_id)

	return platform_id ~= nil and self:_get_progress(platform_id) == 100
end

XboxLiveAchievement.get_progress = function (self, achievement_id)
	local platform_id = _get_platform_id(achievement_id)

	return platform_id and self:_get_progress(platform_id)
end

XboxLiveAchievement.is_platform_achievement = function (self, achievement_id)
	return _get_platform_id(achievement_id) ~= nil
end

implements(XboxLiveAchievement, PlatformAchievementInterface)

return XboxLiveAchievement
