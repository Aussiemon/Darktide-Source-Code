-- chunkname: @scripts/foundation/managers/package/package_manager.lua

local PackageManager = class("PackageManager")

PackageManager.MAX_CONCURRENT_ASYNC_PACKAGES = 64

PackageManager.init = function (self)
	self._packages = {}
	self._async_packages = {}
	self._queued_async_packages = {}
	self._queue_order = {}
	self._queued_callback_items = {}
	self._packages_to_unload = {}
	self._unloading_packages = {}
	self._shutdown_has_started = false
	self._current_item = 1
	self._load_call_data = {}
	self._package_to_load_call_item = {}
	self._current_time = 0
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

	self._async_packages[package_name] = resource_handle
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

	local package_is_unloading = self._unloading_packages[package_name]
	local num_used_slots = table.size(self._async_packages) + table.size(self._unloading_packages)

	if package_is_unloading or num_used_slots >= PackageManager.MAX_CONCURRENT_ASYNC_PACKAGES then
		self:_queue_package(package_name, prioritize, use_resident_loading)
	else
		self:_start_loading_package(package_name, use_resident_loading)
	end

	return load_call_item.id
end

PackageManager._bring_in = function (self, package_name)
	local resource_handle = self._async_packages[package_name]

	ResourcePackage.flush(resource_handle)

	self._packages[package_name] = resource_handle
	self._async_packages[package_name] = nil

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

		local package_is_loading = self._async_packages[package_name]

		if package_is_loading then
			self:_start_unloading_package(package_name)
		else
			local num_used_slots = table.size(self._async_packages) + table.size(self._unloading_packages)

			if num_used_slots < PackageManager.MAX_CONCURRENT_ASYNC_PACKAGES then
				self:_start_unloading_package(package_name)
			end
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

PackageManager._start_unloading_package = function (self, package_name)
	local load_call_item = self._packages_to_unload[package_name]
	local reference_name = load_call_item.reference_name
	local resource_handle = self._packages[package_name] or self._async_packages[package_name]

	if resource_handle then
		ResourcePackage.unload(resource_handle)

		self._unloading_packages[package_name] = resource_handle
	end

	self._packages[package_name] = nil
	self._packages_to_unload[package_name] = nil
	self._package_to_load_call_item[package_name] = nil
	self._async_packages[package_name] = nil
	self._queued_async_packages[package_name] = nil
end

PackageManager.shutdown_has_started = function (self)
	self._shutdown_has_started = true

	self:_flush_unloads()
end

PackageManager._flush_unloads = function (self)
	for package_name, _ in pairs(self._packages_to_unload) do
		self:_start_unloading_package(package_name)
	end

	local unloading_packages = self._unloading_packages

	for package_name, resource_handle in pairs(unloading_packages) do
		local log_blocking_flush = false

		ResourcePackage.flush(resource_handle, log_blocking_flush)
		Application.release_resource_package(resource_handle)

		unloading_packages[package_name] = nil
	end
end

PackageManager.destroy = function (self)
	for id, item in pairs(self._load_call_data) do
		self:release(id)
	end

	self:_flush_unloads()
end

PackageManager.is_anything_loading_now = function (self)
	return not table.is_empty(self._async_packages)
end

PackageManager.is_loading_now = function (self, package_name)
	return self._async_packages[package_name] ~= nil
end

PackageManager.is_loading = function (self, package_name)
	return self._async_packages[package_name] ~= nil or self._queued_async_packages[package_name] ~= nil
end

PackageManager.has_loaded = function (self, package)
	return self._packages[package] ~= nil and self._async_packages[package] == nil and self._queued_async_packages[package] == nil
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

PackageManager.package_is_known = function (self, package_name)
	return self._package_to_load_call_item[package_name] ~= nil
end

local temp_callback_items = {}

PackageManager.update = function (self, dt, t)
	self._current_time = t

	local unloading_packages = self._unloading_packages

	for package_name, resource_handle in pairs(unloading_packages) do
		if ResourcePackage.has_unloaded(resource_handle) then
			ResourcePackage.flush(resource_handle)
			Application.release_resource_package(resource_handle)

			unloading_packages[package_name] = nil
		end
	end

	for package_name, resource_handle in pairs(self._async_packages) do
		if ResourcePackage.has_loaded(resource_handle) then
			self:_bring_in(package_name)
		end
	end

	local num_used_slots = math.min(table.size(self._async_packages) + table.size(unloading_packages), PackageManager.MAX_CONCURRENT_ASYNC_PACKAGES)
	local num_free_slots = PackageManager.MAX_CONCURRENT_ASYNC_PACKAGES - num_used_slots

	if num_free_slots > 0 then
		for package_name, _ in pairs(self._packages_to_unload) do
			if num_free_slots == 0 then
				break
			end

			self:_start_unloading_package(package_name)

			num_used_slots = num_used_slots + 1
			num_free_slots = num_free_slots - 1
		end
	end

	local num_packages_in_queue = #self._queue_order
	local num_slots_to_pop = math.min(num_free_slots, num_packages_in_queue)

	for i = 1, num_slots_to_pop do
		self:_pop_queue()
	end

	local queued_callback_items = self._queued_callback_items

	self._queued_callback_items = temp_callback_items

	for i = 1, #queued_callback_items do
		local item = queued_callback_items[i]

		item.callback(item.id)

		item.callback = nil
	end

	table.clear(queued_callback_items)

	temp_callback_items = queued_callback_items

	return next(self._async_packages) == nil
end

PackageManager.apply_backend_game_settings = function (self)
	if GameParameters.extra_persistent_package ~= "" then
		local info = string.split(GameParameters.extra_persistent_package, ",")
		local chance = tonumber(info[1])
		local package_name = info[2]

		if chance >= math.random() then
			print(string.format("[PackageManager] Loading extra persistent package '%s'", package_name))
			self:load(package_name)
		end
	end
end

return PackageManager
