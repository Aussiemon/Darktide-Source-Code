local BreedResourceDependencies = require("scripts/utilities/breed_resource_dependencies")
local Breeds = require("scripts/settings/breed/breeds")
local Loader = require("scripts/loading/loader")
local MasterItems = require("scripts/backend/master_items")
local Missions = require("scripts/settings/mission/mission_templates")
local BreedLoader = class("BreedLoader")
local LOAD_STATES = table.enum("none", "packages_load", "done")

BreedLoader.init = function (self)
	self._packages_to_load = {}
	self._package_ids = {}
	self._load_state = LOAD_STATES.none
end

BreedLoader.destroy = function (self)
	self:_cleanup()
end

BreedLoader.start_loading = function (self, mission_name, level_editor_level, circumstance_name)
	local chosen_breeds = {}
	local mission_settings = Missions[mission_name]
	local is_hub = mission_settings.is_hub

	if is_hub then
		chosen_breeds.human = Breeds.human
		chosen_breeds.ogryn = Breeds.ogryn
	else
		chosen_breeds = Breeds
	end

	local item_definitions = MasterItems.get_cached()
	local breeds_to_load = BreedResourceDependencies.generate(chosen_breeds, item_definitions)

	if table.is_empty(breeds_to_load) then
		self._load_state = LOAD_STATES.done

		return
	end

	local packages_to_load = self._packages_to_load
	local new_package_added = false

	for package_name, _ in pairs(breeds_to_load) do
		if not packages_to_load[package_name] then
			packages_to_load[package_name] = false
			new_package_added = true
		end
	end

	if not new_package_added then
		self._load_state = LOAD_STATES.done

		return
	end

	self._load_state = LOAD_STATES.packages_load
	local callback = callback(self, "_load_done_callback")
	local package_manager = Managers.package

	for package_name, loaded in pairs(packages_to_load) do
		if not loaded then
			local id = package_manager:load(package_name, "BreedLoader", callback)
			self._package_ids[id] = package_name
		end
	end
end

BreedLoader._load_done_callback = function (self, id)
	local package_name = self._package_ids[id]
	local packages_to_load = self._packages_to_load
	packages_to_load[package_name] = true
	local all_packages_finished_loading = true

	for _, loaded in pairs(packages_to_load) do
		if loaded == false then
			all_packages_finished_loading = false

			break
		end
	end

	if all_packages_finished_loading then
		self._load_state = LOAD_STATES.done
	end
end

BreedLoader.is_loading_done = function (self)
	return self._load_state == LOAD_STATES.done
end

BreedLoader.cleanup = function (self)
	return
end

BreedLoader._cleanup = function (self)
	local package_manager = Managers.package
	local packages = self._package_ids

	for id, package_name in pairs(packages) do
		package_manager:release(id)

		packages[id] = nil
	end

	self._load_state = LOAD_STATES.none

	table.clear(self._packages_to_load)
end

BreedLoader.dont_destroy = function (self)
	return true
end

implements(BreedLoader, Loader)

return BreedLoader
