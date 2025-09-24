-- chunkname: @scripts/loading/loaders/game_mode_loader.lua

local Loader = require("scripts/loading/loader")
local Missions = require("scripts/settings/mission/mission_templates")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local GameModeLoader = class("GameModeLoader")

GameModeLoader.init = function (self)
	self._load_done = false
	self._package_ids = {}
	self._packages_loaded_by_id = {}
end

GameModeLoader.destroy = function (self)
	self:cleanup()
end

GameModeLoader.start_loading = function (self, context)
	local mission_name = context.mission_name
	local mission_settings = Missions[mission_name]
	local game_mode_name = mission_settings.game_mode_name
	local game_mode_settings = GameModeSettings[game_mode_name]
	local package_ids = self._package_ids
	local packages_loaded_by_id = self._packages_loaded_by_id
	local packages = game_mode_settings.packages

	if packages and #packages > 0 then
		for i = 1, #packages do
			local package_name = packages[i]
			local reference_name = "GameModeLoader[" .. i .. "] - (" .. tostring(package_name) .. ")"

			local function callback(package_id)
				self:_load_done_callback(package_id)
			end

			local package_id = Managers.package:load(package_name, reference_name, callback)

			package_ids[package_id] = package_name
			packages_loaded_by_id[package_id] = false
		end
	else
		self._load_done = true
	end
end

GameModeLoader._load_done_callback = function (self, package_id)
	local packages_loaded_by_id = self._packages_loaded_by_id

	packages_loaded_by_id[package_id] = true

	local all_packages_finished_loading = true

	for id, loaded in pairs(packages_loaded_by_id) do
		if loaded == false then
			all_packages_finished_loading = false

			break
		end
	end

	if all_packages_finished_loading then
		self._load_done = true
	end
end

GameModeLoader.is_loading_done = function (self)
	return self._load_done
end

GameModeLoader.cleanup = function (self)
	local package_manager = Managers.package
	local package_ids = self._package_ids

	for package_id, package_data in pairs(package_ids) do
		package_manager:release(package_id)
	end

	table.clear(self._package_ids)

	self._load_done = false
end

GameModeLoader.dont_destroy = function (self)
	return false
end

implements(GameModeLoader, Loader)

return GameModeLoader
