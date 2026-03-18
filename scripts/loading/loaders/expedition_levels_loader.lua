-- chunkname: @scripts/loading/loaders/expedition_levels_loader.lua

local Loader = require("scripts/loading/loader")
local SingleLevelLoader = require("scripts/loading/loaders/single_level_loader")
local ExpeditionLevelsLoader = class("ExpeditionLevelsLoader")

ExpeditionLevelsLoader.init = function (self)
	self._level_loaders = {}
	self._nothing_loaded = false
end

ExpeditionLevelsLoader.destroy = function (self)
	self:cleanup()
end

ExpeditionLevelsLoader.start_loading = function (self, context)
	local level_editor_level = context.level_editor_level
	local circumstance_name = context.circumstance_name
	local mechanism_manager = Managers.mechanism
	local mechanism_name = mechanism_manager:mechanism_name()

	if mechanism_name ~= "expedition" then
		self._nothing_loaded = true

		return
	end

	local mechanism = mechanism_manager:current_mechanism()
	local current_location_index = mechanism:current_location_index()

	if not current_location_index then
		self._nothing_loaded = true

		return
	end

	local levels_spawner = mechanism:levels_spawner()

	if not levels_spawner then
		self._levels_spawner_missing = true

		return
	end

	local expedition = levels_spawner:expedition()
	local level_loaders = self._level_loaders

	for i = math.max(1, current_location_index - 1), current_location_index do
		local segment = expedition[i]
		local levels_data = segment.levels_data
		local only_load_delayed_despawn_levels = i ~= current_location_index
		local theme_tag = segment.theme_tag

		for _, level_data in ipairs(levels_data) do
			local delayed_despawn = level_data.delayed_despawn

			if not only_load_delayed_despawn_levels or delayed_despawn then
				if only_load_delayed_despawn_levels then
					level_data.delayed_despawn = false
				end

				local level_name = level_data.level_name
				local level_loader = SingleLevelLoader:new()
				local level_loader_context = {
					level_name = level_name,
					level_editor_level = level_editor_level,
					circumstance_name = circumstance_name,
					theme_tag = theme_tag,
					dont_load_theme = not level_data.is_location and not level_data.is_safe_zone,
				}

				level_loader:start_loading(level_loader_context)

				level_data.level_loader = level_loader
				level_loaders[#level_loaders + 1] = level_loader
			end
		end
	end
end

ExpeditionLevelsLoader.is_loading_done = function (self)
	if self._nothing_loaded then
		return true
	end

	if self._levels_spawner_missing then
		return false
	end

	local level_loaders = self._level_loaders

	for i = 1, #level_loaders do
		local loader = level_loaders[i]

		if not loader:is_loading_done() then
			return
		end
	end

	return true
end

ExpeditionLevelsLoader.cleanup = function (self)
	Managers.world_level_despawn:flush()

	local level_loaders = self._level_loaders

	if level_loaders then
		for i = 1, #level_loaders do
			local loader = level_loaders[i]

			loader:destroy()
		end

		table.clear(level_loaders)
	end

	self._nothing_loaded = false
	self._levels_spawner_missing = false
end

ExpeditionLevelsLoader.dont_destroy = function (self)
	return false
end

implements(ExpeditionLevelsLoader, Loader)

return ExpeditionLevelsLoader
