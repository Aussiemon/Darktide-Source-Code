﻿-- chunkname: @scripts/foundation/managers/package/package_manager.lua

local PackageManager = class("PackageManager")

PackageManager.FIRST_ITEM = 1
PackageManager.MAX_CONCURRENT_ASYNC_PACKAGES = 64

PackageManager.init = function (self)
	self._packages = {}
	self._asynch_packages = {}
	self._queued_async_packages = {}
	self._queue_order = {}
	self._queued_callback_items = {}
	self._packages_to_unload = {}
	self._shutdown_has_started = false
	self._current_item = PackageManager.FIRST_ITEM
	self._load_call_data = {}
	self._package_to_load_call_item = {}
	self._current_time = 0
	self._pause_unloading = false
end

PackageManager._new_load_call_item = function (self, package_name, reference_name, callback)
	local load_call_item = {
		unload_time = -1,
		id = self._current_item,
		package_name = package_name,
		reference_name = reference_name,
		callback = callback,
		load_call_time = self._current_time,
	}

	self._load_call_data[self._current_item] = load_call_item
	self._current_item = self._current_item + 1

	return load_call_item
end

PackageManager._prioritize_package = function (self, package_name, use_resident_loading)
	local index

	for i = 1, #self._queue_order do
		local package_data = self._queue_order[i]

		if package_data.package_name == package_name then
			index = i

			break
		end
	end

	table.remove(self._queue_order, index)

	local package_data = {
		package_name = package_name,
		use_resident_loading = use_resident_loading,
	}

	table.insert(self._queue_order, 1, package_data)
end

PackageManager._queue_package = function (self, package_name, prioritize, use_resident_loading)
	self._queued_async_packages[package_name] = true

	local package_data = {
		package_name = package_name,
		use_resident_loading = use_resident_loading,
	}

	if prioritize then
		table.insert(self._queue_order, 1, package_data)
	else
		self._queue_order[#self._queue_order + 1] = package_data
	end
end

PackageManager._start_loading_package = function (self, package_name, use_resident_loading)
	local resource_handle = Application.resource_package(package_name)

	if use_resident_loading then
		ResourcePackage.load_resident(resource_handle)
	else
		ResourcePackage.load(resource_handle)
	end

	self._asynch_packages[package_name] = resource_handle
end

PackageManager.load = function (self, package_name, reference_name, callback, prioritize, use_resident_loading)
	local load_call_item = self:_new_load_call_item(package_name, reference_name, callback)

	self._packages_to_unload[package_name] = nil

	if self._package_to_load_call_item[package_name] then
		table.insert(self._package_to_load_call_item[package_name], load_call_item)

		if self._packages[package_name] and callback then
			table.insert(self._queued_callback_items, load_call_item)

			return load_call_item.id
		end

		if self._queued_async_packages[package_name] and prioritize then
			self:_prioritize_package(package_name, use_resident_loading)
		end

		return load_call_item.id
	end

	self._package_to_load_call_item[package_name] = {
		load_call_item,
	}

	if table.size(self._asynch_packages) >= PackageManager.MAX_CONCURRENT_ASYNC_PACKAGES then
		self:_queue_package(package_name, prioritize, use_resident_loading)
	else
		self:_start_loading_package(package_name, use_resident_loading)
	end

	return load_call_item.id
end

PackageManager._bring_in = function (self, package_name)
	local resource_handle = self._asynch_packages[package_name]

	ResourcePackage.flush(resource_handle)

	self._packages[package_name] = resource_handle
	self._asynch_packages[package_name] = nil

	local items = self._package_to_load_call_item[package_name]

	for i = 1, #items do
		local item = items[i]
		local callback = item.callback

		if callback then
			table.insert(self._queued_callback_items, item)
		end
	end
end

PackageManager._pop_queue = function (self)
	if self._shutdown_has_started then
		return
	end

	local queued_package_name
	local use_resident_loading = false
	local index = 1

	while #self._queue_order > 0 and index <= #self._queue_order do
		local queued_package_data = self._queue_order[index]

		queued_package_name = queued_package_data.package_name
		use_resident_loading = queued_package_data.use_resident_loading

		if self._queued_async_packages[queued_package_name] then
			break
		end

		index = index + 1
		queued_package_name = nil
	end

	if queued_package_name then
		self:_start_loading_package(queued_package_name, use_resident_loading)

		self._queued_async_packages[queued_package_name] = nil
		self._queue_order = table.crop(self._queue_order, index + 1)
	else
		table.clear(self._queue_order)
	end
end

PackageManager.release = function (self, id)
	local load_call_item = self._load_call_data[id]
	local package_name = load_call_item.package_name

	self:_remove_load_call_item(package_name, load_call_item)

	if table.is_empty(self._package_to_load_call_item[package_name]) then
		self._packages_to_unload[package_name] = load_call_item

		if self._pause_unloading or self._asynch_packages[package_name] and not self._shutdown_has_started then
			-- Nothing
		else
			self:_release_internal(package_name)
		end
	end

	self:_remove_queued_callback_item(load_call_item)

	self._load_call_data[id] = nil
end

PackageManager._remove_load_call_item = function (self, package_name, load_call_item)
	local load_call_list = self._package_to_load_call_item[package_name]

	for i = #load_call_list, 1, -1 do
		if load_call_list[i] == load_call_item then
			table.remove(load_call_list, i)
		end
	end
end

PackageManager._remove_queued_callback_item = function (self, load_call_item)
	local queued_callback_items = self._queued_callback_items

	for i = #queued_callback_items, 1, -1 do
		if queued_callback_items[i] == load_call_item then
			table.remove(queued_callback_items, i)
		end
	end
end

PackageManager._release_internal = function (self, package_name)
	local load_call_item = self._packages_to_unload[package_name]
	local reference_name = load_call_item.reference_name
	local resource_handle = self._packages[package_name] or self._asynch_packages[package_name]

	if resource_handle then
		ResourcePackage.unload(resource_handle)
		Application.release_resource_package(resource_handle)
	end

	self._packages[package_name] = nil
	self._packages_to_unload[package_name] = nil
	self._package_to_load_call_item[package_name] = nil
	self._asynch_packages[package_name] = nil
	self._queued_async_packages[package_name] = nil
end

PackageManager.shutdown_has_started = function (self)
	self._shutdown_has_started = true

	for package_name, _ in pairs(self._packages_to_unload) do
		self:_release_internal(package_name)
	end
end

PackageManager.pause_unloading = function (self)
	self._pause_unloading = true
end

PackageManager.resume_unloading = function (self)
	for package_name, _ in pairs(self._packages_to_unload) do
		if not self._asynch_packages[package_name] then
			self:_release_internal(package_name)
		end
	end

	self._pause_unloading = false
end

PackageManager.destroy = function (self)
	for id, item in pairs(self._load_call_data) do
		self:release(id)
	end
end

PackageManager.is_anything_loading_now = function (self)
	return not table.is_empty(self._asynch_packages)
end

PackageManager.is_loading_now = function (self, package_name)
	return self._asynch_packages[package_name] ~= nil
end

PackageManager.is_loading = function (self, package_name)
	return self._asynch_packages[package_name] ~= nil or self._queued_async_packages[package_name] ~= nil
end

PackageManager.has_loaded = function (self, package)
	return self._packages[package] ~= nil and self._asynch_packages[package] == nil and self._queued_async_packages[package] == nil
end

PackageManager.has_loaded_id = function (self, id)
	local load_call_item = self._load_call_data[id]

	if load_call_item then
		local package_name = load_call_item.package_name

		if self._packages[package_name] then
			return true
		end
	end

	return false
end

PackageManager.reference_count = function (self, package, reference_name)
	local reference_count = 0
	local load_call_item_list = self._package_to_load_call_item[package]

	if load_call_item_list then
		for i = 1, #load_call_item_list do
			if reference_name == nil then
				reference_count = reference_count + 1
			elseif load_call_item_list[i].reference_name == reference_name then
				reference_count = reference_count + 1
			end
		end
	end

	return reference_count
end

PackageManager.all_reference_count = function (self, reference_name)
	local reference_count = 0

	for id, item in pairs(self._load_call_data) do
		if item.reference_name == reference_name then
			reference_count = reference_count + 1
		end
	end

	return reference_count
end

PackageManager.package_is_known = function (self, package)
	return self._package_to_load_call_item[package] ~= nil
end

local temp_callback_items = {}

PackageManager.update = function (self, dt, t)
	self._current_time = t

	local freed_slots = 0

	for package_name, resource_handle in pairs(self._asynch_packages) do
		if ResourcePackage.has_loaded(resource_handle) then
			self:_bring_in(package_name)

			if self._packages_to_unload[package_name] and not self._pause_unloading then
				self:_release_internal(package_name)
			end

			freed_slots = freed_slots + 1
		end
	end

	for i = 1, freed_slots do
		self:_pop_queue()
	end

	local queued_callback_items = self._queued_callback_items

	self._queued_callback_items = temp_callback_items

	for i = 1, #queued_callback_items do
		local item = queued_callback_items[i]

		item.callback(item.id)
	end

	table.clear(queued_callback_items)

	temp_callback_items = queued_callback_items

	return next(self._asynch_packages) == nil
end

return PackageManager
