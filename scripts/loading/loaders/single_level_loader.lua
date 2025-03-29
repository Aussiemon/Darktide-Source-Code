-- chunkname: @scripts/loading/loaders/single_level_loader.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local Loader = require("scripts/loading/loader")
local ThemePackage = require("scripts/foundation/managers/package/utilities/theme_package")
local MasterItems = require("scripts/backend/master_items")
local SingleLevelLoader = class("SingleLevelLoader")
local LOAD_STATES = table.enum("none", "level_load", "packages_load", "done")

SingleLevelLoader.init = function (self)
	self._level_name = nil
	self._theme_tag = nil
	self._packages_to_load = {}
	self._package_ids = {}
	self._level_package_id = nil
	self._level_loaded = false
	self._load_state = LOAD_STATES.none
end

SingleLevelLoader.destroy = function (self)
	self:cleanup()
end

SingleLevelLoader.start_loading = function (self, context)
	local level_name = context.level_name
	local circumstance_name = context.circumstance_name
	local theme_tag = context.theme_tag

	self._theme_tag = theme_tag
	self._level_name = level_name

	local circumstance_template = circumstance_name and CircumstanceTemplates[circumstance_name]
	local item_definitions = MasterItems.get_cached()

	self._load_state = LOAD_STATES.level_load

	local function callback(_pkg_name)
		self:_level_load_done_callback(item_definitions)
	end

	self._reference_name = "SingleLevelLoader (" .. tostring(level_name) .. ")" .. "_" .. string.gsub(tostring(self), "table: ", "")
	self._level_package_id = Managers.package:load(level_name, self._reference_name, callback)
end

SingleLevelLoader._level_load_done_callback = function (self, item_definitions)
	self._level_loaded = true

	local level_name = self._level_name
	local theme_tag = self._theme_tag
	local item_packages_to_load = ItemPackage.level_resource_dependency_packages(item_definitions, level_name)
	local theme_packages_to_load = ThemePackage.level_resource_dependency_packages(level_name, theme_tag)

	if table.is_empty(item_packages_to_load) and table.is_empty(theme_packages_to_load) then
		self._load_state = LOAD_STATES.done
	else
		self._load_state = LOAD_STATES.packages_load

		local function callback(_pkg_name)
			self:_load_done_callback(_pkg_name)
		end

		local packages_to_load = self._packages_to_load

		for package_name, _ in pairs(item_packages_to_load) do
			packages_to_load[package_name] = false
		end

		for _, package_name in pairs(theme_packages_to_load) do
			packages_to_load[package_name] = false
		end

		local package_manager = Managers.package
		local package_ids = self._package_ids
		local reference_name = self._reference_name

		for package_name, _ in pairs(packages_to_load) do
			local id = package_manager:load(package_name, reference_name, callback)

			package_ids[id] = package_name
		end
	end
end

SingleLevelLoader._load_done_callback = function (self, package_id)
	local package_name = self._package_ids[package_id]
	local packages_to_load = self._packages_to_load

	packages_to_load[package_name] = true

	local all_packages_finished_loading = true

	for name, loaded in pairs(packages_to_load) do
		if loaded == false then
			all_packages_finished_loading = false

			break
		end
	end

	if all_packages_finished_loading then
		self._load_state = LOAD_STATES.done
	end
end

SingleLevelLoader.is_loading_done = function (self)
	return self._load_state == LOAD_STATES.done
end

SingleLevelLoader.cleanup = function (self)
	local package_manager = Managers.package
	local packages = self._package_ids

	for key, value in pairs(packages) do
		package_manager:release(key)
	end

	table.clear(self._package_ids)
	table.clear(self._packages_to_load)

	if self._level_package_id then
		package_manager:release(self._level_package_id)

		self._level_loaded = false
		self._level_package_id = nil
		self._level_name = nil
	end

	self._theme_tag = nil
	self._load_state = LOAD_STATES.none
end

SingleLevelLoader.dont_destroy = function (self)
	return false
end

implements(SingleLevelLoader, Loader)

return SingleLevelLoader
