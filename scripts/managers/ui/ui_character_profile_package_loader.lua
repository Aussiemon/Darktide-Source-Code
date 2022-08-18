local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local UICharacterProfilePackageLoader = class("UICharacterProfilePackageLoader")

UICharacterProfilePackageLoader.init = function (self, unique_id, item_definitions)
	self._reference_name = self.__class_name .. "_" .. unique_id
	self._item_definitions = item_definitions
	self._slots_loading_data = {}
	self._slots_item_loaded = {}
	self._slots_package_ids = {}
end

UICharacterProfilePackageLoader.destroy = function (self)
	self:_unload_all()
end

UICharacterProfilePackageLoader.load_profile = function (self, profile)
	self:_unload_all()

	local loading_items = {}
	local loadout = profile.loadout

	for slot_id, item in pairs(loadout) do
		local item_name = item.name
		loading_items[slot_id] = item_name

		self:load_slot_item(slot_id, item)
	end

	return loading_items
end

UICharacterProfilePackageLoader._unload_all = function (self)
	for slot_id, _ in pairs(self._slots_item_loaded) do
		self:_unload_slot(slot_id)
	end

	for slot_id, _ in pairs(self._slots_loading_data) do
		self:_unload_slot(slot_id)
	end

	self._slots_item_loaded = {}
	self._slots_loading_data = {}
	self._slots_package_ids = {}
end

UICharacterProfilePackageLoader.is_slot_item_loading = function (self, slot_id, item_name)
	local slot_loading_data = self._slots_loading_data[slot_id]

	return slot_loading_data and slot_loading_data.item_name == item_name
end

UICharacterProfilePackageLoader.is_slot_loaded = function (self, slot_id, item_name)
	return self._slots_item_loaded[slot_id] == item_name
end

UICharacterProfilePackageLoader.is_all_loaded = function (self)
	for _, loading_data in pairs(self._slots_loading_data) do
		return false
	end

	for _, item_name in pairs(self._slots_item_loaded) do
		return true
	end

	return false
end

UICharacterProfilePackageLoader.unload_slot = function (self, slot_id)
	self:_unload_slot(slot_id)
end

UICharacterProfilePackageLoader.load_slot_item = function (self, slot_id, item, complete_callback)
	local item_name = item.name

	self:_unload_slot(slot_id)

	if not item then
		if complete_callback then
			complete_callback()
		end

		return
	end

	local item_definitions = self._item_definitions
	local dependencies = ItemPackage.compile_item_instance_dependencies(item, item_definitions)
	local packages_to_load = {}

	for package_name, _ in pairs(dependencies) do
		packages_to_load[#packages_to_load + 1] = package_name
	end

	local num_packages_to_load = #packages_to_load

	if num_packages_to_load > 0 then
		local reference_name = self._reference_name
		local package_manager = Managers.package
		self._slots_item_loaded[slot_id] = nil
		self._slots_loading_data[slot_id] = {
			packages = table.clone(packages_to_load),
			item_name = item_name
		}
		local package_ids = {}

		for i = 1, num_packages_to_load, 1 do
			local package_name = packages_to_load[i]
			local on_loaded_callback = callback(self, "cb_on_slot_item_package_loaded", slot_id, item_name, package_name, complete_callback)
			local prioritize = true
			package_ids[i] = package_manager:load(package_name, reference_name, on_loaded_callback, prioritize)
		end

		self._slots_package_ids[slot_id] = package_ids
	else
		self._slots_item_loaded[slot_id] = item_name
		self._slots_package_ids[slot_id] = {}

		if complete_callback then
			complete_callback()
		end
	end
end

UICharacterProfilePackageLoader.cb_on_slot_item_package_loaded = function (self, slot_id, item_name, package_name, complete_callback)
	local slot_loading_data = self._slots_loading_data[slot_id]

	if not slot_loading_data then
		return
	end

	local item_packages = slot_loading_data.packages

	for i = 1, #item_packages, 1 do
		if item_packages[i] == package_name then
			table.remove(item_packages, i)

			break
		end
	end

	local num_packages_left = #item_packages

	if num_packages_left == 0 then
		self._slots_loading_data[slot_id] = nil
		self._slots_item_loaded[slot_id] = item_name

		if complete_callback then
			complete_callback()
		end
	end
end

UICharacterProfilePackageLoader._unload_slot = function (self, slot_id)
	local package_manager = Managers.package
	local packages = self._slots_package_ids[slot_id]

	if packages then
		for i = 1, #packages, 1 do
			package_manager:release(packages[i])
		end
	end

	self._slots_item_loaded[slot_id] = nil
	self._slots_loading_data[slot_id] = nil
	self._slots_package_ids[slot_id] = nil
end

return UICharacterProfilePackageLoader
