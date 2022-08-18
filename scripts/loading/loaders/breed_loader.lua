local BreedResourceDependencies = require("scripts/utilities/breed_resource_dependencies")
local Breeds = require("scripts/settings/breed/breeds")
local Loader = require("scripts/loading/loader")
local MasterItems = require("scripts/backend/master_items")
local BreedLoader = class("BreedLoader")
local LOAD_STATES = table.enum("none", "packages_load", "done")

BreedLoader.init = function (self)
	self._packages_to_load = {}
	self._package_ids = {}
	self._load_state = LOAD_STATES.none
end

BreedLoader.destroy = function (self)
	self:cleanup()
end

BreedLoader.start_loading = function (self, mission_name, level_editor_level, circumstance_name)
	local chosen_breeds = Breeds
	local item_definitions = MasterItems.get_cached()
	local breeds_to_load = BreedResourceDependencies.generate(chosen_breeds, item_definitions)

	if table.is_empty(breeds_to_load) then
		self._load_state = LOAD_STATES.done
	else
		self._load_state = LOAD_STATES.packages_load
		local callback = callback(self, "_load_done_callback")
		local packages_to_load = self._packages_to_load

		for package_name, _ in pairs(breeds_to_load) do
			packages_to_load[package_name] = false
		end

		local package_manager = Managers.package

		for package_name, _ in pairs(packages_to_load) do
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
	local package_manager = Managers.package
	local packages = self._package_ids

	for id, package_name in pairs(packages) do
		package_manager:release(id)

		packages[id] = nil
	end

	self._load_state = LOAD_STATES.none
end

implements(BreedLoader, Loader)

return BreedLoader
