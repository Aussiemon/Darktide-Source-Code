local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtilities = require("scripts/foundation/utilities/xbox_live")
local XboxPlatformAchievement = class("XboxPlatformAchievement")
local ProgressStates = {
	UNLOCKED = 1,
	NOT_STARTED = 2,
	IN_PROGRESS = 3
}

XboxPlatformAchievement._get_platform_id = function (self, achievement_definition)
	local xbox_data = achievement_definition.xbox
	local platform_id = xbox_data and xbox_data.id

	return platform_id
end

XboxPlatformAchievement._should_show_progress = function (self, achievement_definition)
	local xbox_data = achievement_definition.xbox
	local show_progress = xbox_data and xbox_data.show_progress

	return show_progress
end

XboxPlatformAchievement._add_achievement = function (self, lookup, platform_data)
	local platform_id = tonumber(platform_data.id)
	local achievement_id = lookup[platform_id]

	if achievement_id == nil then
		Log.warning("XboxPlatformAchievement", "Can't add achievement '%s'. No ingame achievement matches it.", platform_id)

		return
	end

	local progress_state = platform_data.progress_state

	if progress_state == ProgressStates.UNLOCKED then
		self._progress[achievement_id] = 100

		return
	end

	local current_progress = table.nested_get(platform_data, "progression", "requirements", 1, "current_progress_value")

	if current_progress == nil then
		Log.warning("XboxPlatformAchievement", "Can't add achievement '%s'. No requirement is defined.", platform_id)

		return
	end

	local current_numeric_progress = tonumber(current_progress)

	if current_numeric_progress == nil then
		Log.warning("XboxPlatformAchievement", "Can't add achievement '%s'. Progress '%s' isn't numeric.", platform_id, current_progress)

		return
	end

	self._progress[achievement_id] = current_numeric_progress
end

XboxPlatformAchievement.init = function (self, definitions)
	self._backend_promise = XboxLiveUtilities.get_all_achievements()
	self._progress = {}

	return self._backend_promise:next(function (platform_data)
		local lookup = {}

		for id, achievement_definition in pairs(definitions) do
			local platform_id = self:_get_platform_id(achievement_definition)

			if platform_id then
				lookup[platform_id] = id
			end
		end

		for i = 1, #platform_data do
			local data = platform_data[i]

			self:_add_achievement(lookup, data)
		end

		for platform_id, achievement_id in pairs(lookup) do
			if self._progress[achievement_id] == nil then
				Log.warning("XboxPlatformAchievement", "In game achievement '%s' has platform id '%s' but no such achievement is defined.", achievement_id, platform_id)
			end
		end
	end)
end

XboxPlatformAchievement.destroy = function (self)
	return Promise.resolved()
end

XboxPlatformAchievement._set_progress = function (self, achievement_definition, progress)
	local id = achievement_definition.id
	local current_progress = self._progress[id]

	if not current_progress then
		return Promise.rejected()
	end

	local platform_id = self:_get_platform_id(achievement_definition)
	local show_progress = self:_should_show_progress(achievement_definition)
	local will_unlock = progress == 100

	if (will_unlock or show_progress) and current_progress < progress then
		self._progress[id] = progress

		return XboxLiveUtilities.update_achievement(platform_id, progress)
	end

	return Promise.resolved()
end

XboxPlatformAchievement.is_platform_achievement = function (self, achievement_definition)
	local achievement_id = achievement_definition.id

	return self._progress[achievement_id] ~= nil
end

XboxPlatformAchievement.unlock = function (self, achievement_definition)
	return self:_set_progress(achievement_definition, 100)
end

XboxPlatformAchievement.is_unlocked = function (self, achievement_definition)
	local achievement_id = achievement_definition.id

	return self._progress[achievement_id] == 100
end

XboxPlatformAchievement.set_progress = function (self, achievement_definition, progress)
	local target = achievement_definition.target
	local normalized_progress = math.min(math.floor(100 * progress / target), 99)

	return self:_set_progress(achievement_definition, normalized_progress)
end

XboxPlatformAchievement.get_progress = function (self, achievement_definition)
	local achievement_id = achievement_definition.id

	return self._progress[achievement_id]
end

return XboxPlatformAchievement
