-- chunkname: @scripts/extension_systems/visual_loadout/mispredict_package_handler.lua

local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local MispredictPackageHandler = class("MispredictPackageHandler")

MispredictPackageHandler.init = function (self, unit_data_extension, item_definitions, mission)
	self._unit_data_extension = unit_data_extension
	self._item_definitions = item_definitions
	self._mission = mission
	self._pending_unloads = {}
	self._loaded_packages = {}
end

MispredictPackageHandler.item_equipped = function (self, item)
	self:_load_item_packages(item)
end

MispredictPackageHandler.item_unequipped = function (self, item, fixed_frame)
	local pending_unloads = self._pending_unloads[fixed_frame] or {}

	pending_unloads[#pending_unloads + 1] = item
	self._pending_unloads[fixed_frame] = pending_unloads
end

MispredictPackageHandler.post_update = function (self)
	local unit_data_extension = self._unit_data_extension
	local last_recieved_fixed_frame = unit_data_extension:last_received_fixed_frame()

	for fixed_frame, items in pairs(self._pending_unloads) do
		if fixed_frame <= last_recieved_fixed_frame then
			for i = 1, #items do
				local item = items[i]

				self:_unload_item_packages(item)
			end

			self._pending_unloads[fixed_frame] = nil
		end
	end
end

MispredictPackageHandler._load_item_packages = function (self, item)
	local mission = self._mission
	local dependencies = ItemPackage.compile_item_instance_dependencies(item, self._item_definitions, nil, mission)
	local package_manager = Managers.package

	for package_name, _ in pairs(dependencies) do
		if package_manager:package_is_known(package_name) then
			local load_id = Managers.package:load(package_name, "MispredictPackageHandler", nil, true)

			self._loaded_packages[package_name] = self._loaded_packages[package_name] or {}

			table.insert(self._loaded_packages[package_name], load_id)
		else
			ferror("MispredictPackageHandler attempted to load a package when it should only increase reference counts,\tsomething has gone wrong with package loading if this has occured")
		end
	end
end

MispredictPackageHandler._unload_item_packages = function (self, item)
	local mission = self._mission
	local dependencies = ItemPackage.compile_item_instance_dependencies(item, self._item_definitions, nil, mission)

	for package_name, _ in pairs(dependencies) do
		local loaded_packages = self._loaded_packages[package_name]
		local load_id = table.remove(loaded_packages, #loaded_packages)

		Managers.package:release(load_id)

		if table.is_empty(loaded_packages) then
			self._loaded_packages[package_name] = nil
		end
	end
end

MispredictPackageHandler.destroy = function (self)
	for fixed_frame, items in pairs(self._pending_unloads) do
		for i = 1, #items do
			local item = items[i]

			self:_unload_item_packages(item)
		end
	end

	if next(self._loaded_packages) then
		table.dump(self._loaded_packages)
		ferror("MispredictPackageHandler loaded packages and has not correctly unloaded them")
	end

	self._pending_unloads = nil
	self._loaded_packages = nil
end

return MispredictPackageHandler
