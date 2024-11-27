-- chunkname: @scripts/managers/achievements/platforms/ps5_platform_achievement.lua

local BasePlatformAchievement = "scripts/managers/achievements/platforms/base_platform_achievement"
local Promise = require("scripts/foundation/utilities/promise")
local PS5PlatformAchievement = class("PS5PlatformAchievement", "BasePlatformAchievement")

PS5PlatformAchievement._get_platform_id = function (self, achievement_definition)
	local psn_data = achievement_definition.psn

	return psn_data and psn_data.id
end

PS5PlatformAchievement._should_show_progress = function (self, achievement_definition)
	local psn_data = achievement_definition.psn

	return psn_data and psn_data.show_progress
end

PS5PlatformAchievement._add_achievement = function (self, lookup, data)
	local platform_id = tonumber(data.trophy_id)
	local achievement_id = lookup[platform_id]

	if not achievement_id then
		Log.warning("PS5PlatformAchievement", "Can't add achievement '%s'. No in-game achievement matches it.", platform_id)

		return
	end

	if data.unlocked then
		self._progress[achievement_id] = 100
	else
		local current_progress = data.progress_value

		self._progress[achievement_id] = current_progress
	end
end

PS5PlatformAchievement.init = function (self, definitions)
	self._backend_promise = Managers.ps5_uds:get_all_achievements()
	self._progress = {}

	return self._backend_promise:next(function (platform_data)
		local lookup = {}

		for id, achievement_definition in pairs(definitions) do
			local platform_id = self:_get_platform_id(achievement_definition)

			if platform_id then
				lookup[platform_id] = id
			end
		end

		local trophy_data = platform_data.data

		for i = 1, #trophy_data do
			self:_add_achievement(lookup, trophy_data[i])
		end

		for platform_id, achievement_id in pairs(lookup) do
			if self._progress[achievement_id] == nil then
				Log.warning("PS5PlatformAchievement", "In-game achievement '%s' has platform id '%s' but no such achievement is defined.", achievement_id, platform_id)
			end
		end
	end)
end

PS5PlatformAchievement.destroy = function (self)
	return Promise.resolved()
end

PS5PlatformAchievement._set_progress = function (self, achievement_definition, progress)
	local trophy_id = achievement_definition.id
	local current_progress = self._progress[trophy_id]

	if not current_progress then
		return Promise.rejected()
	end

	local platform_id = self:_get_platform_id(achievement_definition)

	if self:_should_show_progress(achievement_definition) then
		if current_progress < progress then
			self._progress[trophy_id] = progress

			return Managers.ps5_uds:update_achievement(platform_id, progress)
		end
	elseif progress == 100 then
		self._progress[trophy_id] = progress

		return Managers.ps5_uds:unlock_trophy(platform_id)
	end

	return Promise.resolved()
end

PS5PlatformAchievement.is_platform_achievement = function (self, achievement_definition)
	local achievement_id = achievement_definition.id

	return self._progress[achievement_id] ~= nil
end

PS5PlatformAchievement.unlock = function (self, achievement_definition)
	return self:_set_progress(achievement_definition, 100)
end

PS5PlatformAchievement.is_unlocked = function (self, achievement_definition)
	local achievement_id = achievement_definition.id

	return self._progress[achievement_id] == 100
end

PS5PlatformAchievement.set_progress = function (self, achievement_definition, progress)
	local target = achievement_definition.target
	local normalized_progress = math.min(math.floor(100 * progress / target), 99)

	return self:_set_progress(achievement_definition, normalized_progress)
end

PS5PlatformAchievement.get_progress = function (self, achievement_definition)
	local achievement_id = achievement_definition.id

	return self._progress[achievement_id]
end

return PS5PlatformAchievement
