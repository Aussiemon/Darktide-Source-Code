-- chunkname: @scripts/managers/ui/ui_character_profile_package_loader.lua

local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local UICharacterProfilePackageLoader = class("UICharacterProfilePackageLoader")

UICharacterProfilePackageLoader.init = function (self, unique_id, item_definitions, optional_mission_template)
	self._reference_name = self.__class_name .. "_" .. unique_id
	self._item_definitions = item_definitions
	self._mission_template = optional_mission_template
	self._slots_loading_data = {}
	self._slots_item_loaded = {}
	self._slots_package_ids = {}
end

UICharacterProfilePackageLoader.destroy = function (self)
	local packages_to_unload = {}

	self:_unload_all(packages_to_unload)
	self:_unload_packages(packages_to_unload)
end

UICharacterProfilePackageLoader.load_profile = function (self, profile)
	local packages_to_unload = {}

	self:_unload_all(packages_to_unload)

	local loading_items = {}
	local loadout = profile.loadout

	for slot_id, item in pairs(loadout) do
		local item_name = item.name

		loading_items[slot_id] = item_name

		self:load_slot_item(slot_id, item)
	end

	self:_unload_packages(packages_to_unload)

	return loading_items
end

UICharacterProfilePackageLoader._unload_all = function (self, packages_to_unload)
	for slot_id, _ in pairs(self._slots_item_loaded) do
		self:_unload_slot(slot_id, packages_to_unload)
	end

	for slot_id, _ in pairs(self._slots_loading_data) do
		self:_unload_slot(slot_id, packages_to_unload)
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
	if not table.is_empty(self._slots_loading_data) then
		return false
	end

	if not table.is_empty(self._slots_item_loaded) then
		return true
	end

	return false
end

UICharacterProfilePackageLoader.unload_slot = function (self, slot_id)
	local packages_to_unload = {}

	self:_unload_slot(slot_id, packages_to_unload)
	self:_unload_packages(packages_to_unload)
end

local item_instance_dependencies = Script.new_map(32)

UICharacterProfilePackageLoader.load_slot_item = function (self, slot_id, item, complete_callback)
	local packages_to_unload = {}

	self:_unload_slot(slot_id, packages_to_unload)

	if not item or table.is_empty(item) then
		if complete_callback then
			complete_callback()
		end

		return
	end

	local item_definitions = self._item_definitions
	local mission_template = self._mission_template

	table.clear(item_instance_dependencies)
	ItemPackage.compile_item_instance_dependencies(item, item_definitions, item_instance_dependencies, mission_template)

	local packages_to_load = {}

	for package_name, _ in pairs(item_instance_dependencies) do
		packages_to_load[#packages_to_load + 1] = package_name
	end

	local item_name = item.name
	local num_packages_to_load = #packages_to_load

	if num_packages_to_load > 0 then
		local reference_name = self._reference_name
		local package_manager = Managers.package

		self._slots_item_loaded[slot_id] = nil
		self._slots_loading_data[slot_id] = {
			packages = packages_to_load,
			item_name = item_name
		}

		local package_ids = Script.new_array(num_packages_to_load)
		local use_resident_loading = true

		if IS_XBS and Xbox.console_type() == Xbox.CONSOLE_TYPE_XBOX_SCARLETT_LOCKHEART then
			use_resident_loading = false
		end

		for i = 1, num_packages_to_load do
			local package_name = packages_to_load[i]
			local on_loaded_callback = callback(self, "cb_on_slot_item_package_loaded", slot_id, item_name, package_name, complete_callback)
			local prioritize = true

			package_ids[i] = package_manager:load(package_name, reference_name, on_loaded_callback, prioritize, use_resident_loading)
		end

		self._slots_package_ids[slot_id] = package_ids
	else
		self._slots_item_loaded[slot_id] = item_name
		self._slots_package_ids[slot_id] = {}

		if complete_callback then
			complete_callback()
		end
	end

	self:_unload_packages(packages_to_unload)
end

UICharacterProfilePackageLoader.cb_on_slot_item_package_loaded = function (self, slot_id, item_name, package_name, complete_callback)
	local slot_loading_data = self._slots_loading_data[slot_id]

	if not slot_loading_data then
		return
	end

	local item_packages = slot_loading_data.packages

	for i = 1, #item_packages do
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

UICharacterProfilePackageLoader._unload_slot = function (self, slot_id, packages_to_unload)
	local packages = self._slots_package_ids[slot_id]

	if packages then
		for i = 1, #packages do
			packages_to_unload[#packages_to_unload + 1] = packages[i]
		end
	end

	self._slots_item_loaded[slot_id] = nil
	self._slots_loading_data[slot_id] = nil
	self._slots_package_ids[slot_id] = nil
end

UICharacterProfilePackageLoader._unload_packages = function (self, packages_to_unload)
	local package_manager = Managers.package

	for i = 1, #packages_to_unload do
		package_manager:release(packages_to_unload[i])
	end

	table.clear(packages_to_unload)
end

return UICharacterProfilePackageLoader
