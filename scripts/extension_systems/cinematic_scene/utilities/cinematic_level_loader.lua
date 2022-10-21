local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local MasterItems = require("scripts/backend/master_items")
local CinematicLevelLoader = class("CinematicLevelLoader")
local PACKAGE_LOAD_STATES = table.enum("none", "level_load", "packages_load", "done")

CinematicLevelLoader.init = function (self)
	self._cinematic_name = nil
	self._levels_to_load = {}
	self._packages_to_load = {}
	self._package_ids = {}
	self._level_ready_callbacks = {}
end

CinematicLevelLoader.destroy = function (self)
	self:cleanup()
end

CinematicLevelLoader.start_loading = function (self, cinematic_name, level_names, callback)
	local ready_callbacks = self._level_ready_callbacks
	ready_callbacks[#ready_callbacks + 1] = callback

	if #level_names == 0 then
		for _, ready_callback in ipairs(ready_callbacks) do
			ready_callback(cinematic_name, {})
		end

		table.clear(ready_callbacks)
	else
		if self._cinematic_name == nil then
			self._cinematic_name = cinematic_name
			local item_definitions = MasterItems.get_cached()

			for _, level_name in ipairs(level_names) do
				self._levels_to_load[level_name] = PACKAGE_LOAD_STATES.level_load
			end

			for _, level_name in ipairs(level_names) do
				local function pkg_callback(_pkg_name)
					self:_level_load_done_callback(item_definitions, level_name)
				end

				local id = Managers.package:load(level_name, "CinematicLevelLoader", pkg_callback)
				self._package_ids[id] = level_name
			end

			return
		end

		if self._cinematic_name == cinematic_name and self:_is_loading_done() then
			callback(self._cinematic_name, self._levels_to_load)
		end
	end
end

CinematicLevelLoader._level_load_done_callback = function (self, item_definitions, level_name)
	local item_packages_to_load = ItemPackage.level_resource_dependency_packages(item_definitions, level_name)

	if table.is_empty(item_packages_to_load) then
		self._levels_to_load[level_name] = PACKAGE_LOAD_STATES.done

		if self:_is_loading_done() then
			local ready_callbacks = self._level_ready_callbacks

			for _, ready_callback in ipairs(ready_callbacks) do
				ready_callback(self._cinematic_name, self._levels_to_load)
			end

			table.clear(ready_callbacks)
		end
	else
		self._levels_to_load[level_name] = PACKAGE_LOAD_STATES.packages_load
		local packages_to_load = self._packages_to_load
		packages_to_load[level_name] = {}

		for package_name, _ in pairs(item_packages_to_load) do
			packages_to_load[level_name][package_name] = false
		end

		local package_manager = Managers.package
		local package_ids = self._package_ids

		local function callback(_pkg_name)
			self:_load_done_callback(_pkg_name, level_name)
		end

		for package_name, _ in pairs(packages_to_load[level_name]) do
			local id = package_manager:load(package_name, "CinematicLevelLoader", callback)
			package_ids[id] = package_name
		end
	end
end

CinematicLevelLoader._load_done_callback = function (self, package_id, level_name)
	local package_name = self._package_ids[package_id]
	local packages_to_load = self._packages_to_load
	packages_to_load[level_name][package_name] = true
	local all_packages_finished_loading = true

	for name, loaded in pairs(packages_to_load[level_name]) do
		if loaded == false then
			all_packages_finished_loading = false

			break
		end
	end

	if all_packages_finished_loading then
		self._levels_to_load[level_name] = PACKAGE_LOAD_STATES.done
	end

	if self:_is_loading_done() then
		local ready_callbacks = self._level_ready_callbacks

		for _, ready_callback in ipairs(ready_callbacks) do
			ready_callback(self._cinematic_name, self._levels_to_load)
		end

		table.clear(ready_callbacks)
	end
end

CinematicLevelLoader._is_loading_done = function (self)
	local result = true

	for _, state in pairs(self._levels_to_load) do
		if state ~= PACKAGE_LOAD_STATES.done then
			result = false

			break
		end
	end

	return result
end

CinematicLevelLoader.is_loading = function (self)
	return not self:_is_loading_done()
end

CinematicLevelLoader.check_loading = function (self, cinematic_name)
	local is_correct_cinematic = cinematic_name == self._cinematic_name

	return is_correct_cinematic and self:_is_loading_done()
end

CinematicLevelLoader.has_level = function (self, level_name)
	return self._levels_to_load[level_name] ~= nil
end

CinematicLevelLoader.has_levels = function (self)
	return not table.is_empty(self._levels_to_load)
end

CinematicLevelLoader.cleanup = function (self)
	local package_manager = Managers.package
	local packages = self._package_ids

	for package_id, _ in pairs(packages) do
		package_manager:release(package_id)
	end

	table.clear(self._package_ids)
	table.clear(self._levels_to_load)

	self._cinematic_name = nil

	table.clear(self._level_ready_callbacks)
	table.clear(self._packages_to_load)
end

return CinematicLevelLoader
