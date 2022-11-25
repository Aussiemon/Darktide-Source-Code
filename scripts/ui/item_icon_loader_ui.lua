local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local MasterItems = require("scripts/backend/master_items")
local ItemIconLoaderUI = class("ItemIconLoaderUI")

ItemIconLoaderUI.init = function (self)
	self._reference_name = self.__class_name
	self._requests_queue_order = {}
	self._requests = {}
	self._id_counter = 0
	self._id_prefix = "ItemIconLoaderUI"
	self._active_request = nil
end

ItemIconLoaderUI.load_icon = function (self, item, on_load_callback)
	local id = self._id_prefix .. "_" .. self._id_counter
	self._id_counter = self._id_counter + 1
	local gear_id = item.gear_id or item.name

	if not self._requests[gear_id] then
		local item_name = item.name
		local item_definitions = MasterItems.get_cached()
		local dependencies = ItemPackage.compile_item_instance_dependencies(item, item_definitions)
		local packages_to_load = {}

		for package_name, _ in pairs(dependencies) do
			packages_to_load[#packages_to_load + 1] = package_name
		end

		self._requests[gear_id] = {
			loaded = false,
			loading = false,
			references_lookup = {},
			references_array = {},
			callbacks = {},
			gear_id = gear_id,
			item = item,
			item_name = item_name,
			packages_to_load = packages_to_load,
			id = id
		}
		self._requests_queue_order[#self._requests_queue_order + 1] = gear_id
	end

	local data = self._requests[gear_id]
	data.references_lookup[id] = true
	data.references_array[#data.references_array + 1] = id

	if not data.loaded then
		data.callbacks[id] = on_load_callback
	elseif on_load_callback then
		on_load_callback(item)
	end

	return id
end

ItemIconLoaderUI.unload_icon = function (self, id)
	local data = self:_request_by_id(id)
	local gear_id = data.gear_id
	local references_array = data.references_array
	local references_lookup = data.references_lookup
	local callbacks = data.callbacks

	if #references_array == 1 then
		local package_manager = Managers.package
		local package_ids = data.package_ids

		if package_ids then
			for i = 1, #package_ids do
				local package_load_id = package_ids[i]

				package_manager:release(package_load_id)
			end
		end

		self._requests[gear_id] = nil

		if self._active_request and self._active_request.gear_id == gear_id then
			self._active_request = nil
		end

		for i = 1, #self._requests_queue_order do
			if self._requests_queue_order[i] == gear_id then
				table.remove(self._requests_queue_order, i)

				break
			end
		end
	else
		if callbacks then
			callbacks[id] = nil
		end

		references_lookup[id] = nil

		for i = 1, #references_array do
			if references_array[i] == id then
				table.remove(references_array, i)

				break
			end
		end
	end
end

ItemIconLoaderUI._request_by_id = function (self, id, ignore_assert)
	local requests = self._requests

	for gear_id, data in pairs(requests) do
		local references_lookup = data.references_lookup

		if references_lookup[id] then
			return data
		end
	end

	if ignore_assert then
		-- Nothing
	end
end

ItemIconLoaderUI.has_request = function (self, id)
	local data = self:_request_by_id(id, true)

	return data ~= nil
end

ItemIconLoaderUI.destroy = function (self)
	return
end

ItemIconLoaderUI.load_request = function (self, request)
	local gear_id = request.gear_id
	local packages_to_load = request.packages_to_load
	local num_packages_to_load = #packages_to_load

	if num_packages_to_load > 0 then
		local reference_name = self._reference_name
		local package_manager = Managers.package
		local package_ids = {}
		request.package_ids = package_ids

		for i = 1, num_packages_to_load do
			local package_name = packages_to_load[i]
			local on_loaded_callback = callback(self, "_cb_on_item_package_loaded", gear_id, package_name)
			local prioritize = true
			package_ids[i] = package_manager:load(package_name, reference_name, on_loaded_callback, prioritize)
		end
	else
		request.loaded = true
	end
end

ItemIconLoaderUI._cb_on_item_package_loaded = function (self, gear_id, package_name)
	local request = self._requests[gear_id]

	if not request then
		return
	end

	local packages_to_load = request.packages_to_load

	for i = 1, #packages_to_load do
		if packages_to_load[i] == package_name then
			table.remove(packages_to_load, i)

			break
		end
	end

	local num_packages_left = #packages_to_load

	if num_packages_left == 0 then
		request.loaded = true
	end
end

ItemIconLoaderUI._handle_request_queue = function (self)
	local active_request = self._active_request

	if active_request then
		if active_request.loaded then
			local callbacks = active_request.callbacks
			local item = active_request.item

			for id, on_load_callback in pairs(callbacks) do
				on_load_callback(item)
			end

			table.clear(callbacks)

			active_request.loading = false
			self._active_request = nil
		end
	elseif #self._requests_queue_order > 0 then
		self:_handle_next_request_in_queue()
	end
end

ItemIconLoaderUI._handle_next_request_in_queue = function (self)
	self._active_request = nil
	local num_in_queue = #self._requests_queue_order

	if num_in_queue > 0 then
		local character_id = table.remove(self._requests_queue_order, 1)
		local request = self._requests[character_id]
		self._active_request = request
		request.loading = true

		self:load_request(request)
	end
end

ItemIconLoaderUI.update = function (self, dt, t)
	self:_handle_request_queue()
end

return ItemIconLoaderUI
