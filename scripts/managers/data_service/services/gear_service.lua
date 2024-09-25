﻿-- chunkname: @scripts/managers/data_service/services/gear_service.lua

local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local GearService = class("GearService")

GearService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._gear_promises = {}
	self._backend_gear_promise = nil
	self._cached_gear_list = nil
end

GearService._refresh_gear_cache = function (self)
	if self._backend_gear_promise then
		self._backend_gear_promise:cancel()

		self._backend_gear_promise = nil
	end

	self._backend_gear_promise = self._backend_interface.gear:fetch()

	self._backend_gear_promise:next(function (gear_list)
		self._backend_gear_promise = nil
		self._cached_gear_list = gear_list

		local gear_promises = self._gear_promises

		for i = 1, #gear_promises do
			local p = gear_promises[i]

			if p:is_pending() then
				p:resolve(table.clone(gear_list))
			end
		end

		table.clear(gear_promises)
	end):catch(function (error)
		self._backend_gear_promise = nil
		self._cached_gear_list = nil

		local gear_promises = self._gear_promises

		for i = 1, #gear_promises do
			local p = gear_promises[i]

			if p:is_pending() then
				p:reject(error)
			end
		end

		table.clear(gear_promises)
		Log.error("GearService", "Failed refreshing gear cache: %s", table.tostring(error))
	end)
end

GearService.fetch_gear = function (self)
	if not GameParameters.enable_backend_gear_cache then
		return self._backend_interface.gear:fetch()
	end

	local promise = Promise.new()

	if self._cached_gear_list then
		promise:resolve(table.clone(self._cached_gear_list))
	else
		self._gear_promises[#self._gear_promises + 1] = promise

		self:_refresh_gear_cache()
	end

	return promise
end

GearService.invalidate_gear_cache = function (self)
	if not GameParameters.enable_backend_gear_cache then
		return
	end

	self._cached_gear_list = nil

	if self._backend_gear_promise then
		self._backend_gear_promise:cancel()

		self._backend_gear_promise = nil
	end

	if #self._gear_promises > 0 then
		self:_refresh_gear_cache()
	end
end

GearService.populate_gear_cache = function (self)
	if not GameParameters.enable_backend_gear_cache then
		return
	end

	if self._cached_gear_list then
		return
	end

	if self._backend_gear_promise then
		return
	end

	self:_refresh_gear_cache()
end

GearService.on_character_deleted = function (self, character_id)
	local cache = self._cached_gear_list

	if cache then
		for gear_id, gear in pairs(cache) do
			if gear.characterId == character_id then
				cache[gear_id] = nil
			end
		end
	end
end

GearService.on_gear_deleted = function (self, gear_id)
	local cache = self._cached_gear_list

	if cache then
		cache[gear_id] = nil
	end
end

GearService.on_gear_created = function (self, gear_id, gear)
	local cache = self._cached_gear_list

	if cache then
		cache[gear_id] = gear
	end
end

GearService.on_gear_updated = function (self, gear_id, gear)
	local cache = self._cached_gear_list

	if cache then
		cache[gear_id] = gear
	end
end

GearService.reset = function (self)
	self._cached_gear_list = nil

	if self._backend_gear_promise then
		self._backend_gear_promise:cancel()

		self._backend_gear_promise = nil
	end

	local gear_promises = self._gear_promises

	for i = 1, #gear_promises do
		local p = gear_promises[i]

		if p:is_pending() then
			p:cancel()
		end
	end

	table.clear(gear_promises)
end

local function _invalidate_gear_cache(promise)
	return promise:next(function (result)
		Managers.data_service.gear:invalidate_gear_cache()

		return result
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.rejected(err)
	end)
end

GearService.delete_gear = function (self, gear_id)
	return self._backend_interface.gear:delete_gear(gear_id):next(function (result)
		self:on_gear_deleted(gear_id)

		return Managers.data_service.store:on_gear_deleted(result):next(function ()
			return result
		end)
	end):catch(function (err)
		self:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

GearService.delete_gear_batch = function (self, items)
	local max_operations = 25
	local num_batches = items and math.floor(#items / max_operations + 1) or 0
	local item_batches = {}

	if num_batches > 0 then
		for i = 1, num_batches do
			item_batches[i] = {}

			local start_batch = (i - 1) * max_operations + 1
			local end_batch = i < num_batches and start_batch + max_operations or #items

			for ii = start_batch, end_batch do
				item_batches[i][#item_batches[i] + 1] = items[ii]
			end
		end
	end

	return self:_delete_item_batches(item_batches, {})
end

GearService._delete_item_batches = function (self, item_batches, result)
	if item_batches[1] then
		local items = item_batches[1]

		return self._backend_interface.gear:delete_gear_batch(items):next(function (data)
			if data and data.operations then
				for i = 1, #data.operations do
					local operation = data.operations[i]
					local gear_id = operation.gearId

					result[#result + 1] = operation

					if gear_id then
						self:on_gear_deleted(gear_id)
					end
				end
			end

			table.remove(item_batches, 1)

			return self:_delete_item_batches(item_batches, result)
		end):catch(function (data)
			table.remove(item_batches, 1)

			return self:_delete_item_batches(item_batches, result)
		end)
	else
		self:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		return result
	end
end

GearService.fetch_inventory = function (self, character_id, slot_filter_list, item_type_filter_list)
	local gear_promise = self:fetch_gear()

	return gear_promise:next(function (gear_list)
		local items = {}
		local require_item_type_filter = item_type_filter_list and #item_type_filter_list > 0
		local require_slot_filter = slot_filter_list and #slot_filter_list > 0

		for gear_id, gear in pairs(gear_list) do
			if not gear.characterId or gear.characterId == character_id then
				gear_id = gear.uuid or gear_id

				local gear_item = MasterItems.get_item_instance(gear, gear_id)
				local valid = gear_item

				if valid and require_item_type_filter then
					local item_type = gear_item.item_type

					if not item_type or not table.contains(item_type_filter_list, item_type) then
						valid = false
					end
				end

				if valid and require_slot_filter then
					local slots = gear_item.slots

					if slots then
						local slot_found = false

						for _, slot_name in ipairs(slots) do
							if table.contains(slot_filter_list, slot_name) then
								slot_found = true

								break
							end
						end

						valid = slot_found
					else
						valid = false
					end
				end

				if valid then
					items[gear_id] = gear_item
				end
			end
		end

		return Promise.resolved(items)
	end):catch(function (errors)
		local gear_list_error = unpack(errors)
		local error_string = tostring(gear_list_error)

		Log.error("GearService", "Error fetching inventory items: %s", error_string)
	end)
end

GearService.fetch_inventory_paged = function (self, character_id, item_amount, slot_filter_list)
	local backend_interface = self._backend_interface
	local gear_promise = backend_interface.gear:fetch_paged(item_amount or 100, slot_filter_list)

	return gear_promise:next(function (gear_list)
		if gear_list.has_next then
			Log.warning("GearService", "Response had more items than fits a page, remaining items will be ignored")
		end

		local items = {}

		for _, gear in pairs(gear_list.items) do
			local character_match = gear.characterId == character_id
			local account_owned = gear.characterId == nil
			local include_item = character_match or account_owned

			if include_item then
				local gear_id = gear.uuid
				local gear_item = MasterItems.get_item_instance(gear, gear_id)

				items[gear_id] = gear_item
			end
		end

		return Promise.resolved(items)
	end):catch(function (errors)
		local gear_list_error = unpack(errors)
		local error_string = tostring(gear_list_error)

		Log.error("GearService", "Error fetching inventory items: %s", error_string)
	end)
end

GearService.fetch_account_items_paged = function (self, item_amount, slot_filter_list, chained_promise)
	local backend_interface = self._backend_interface
	local gear_promise = chained_promise or backend_interface.gear:fetch_paged(item_amount or 100, slot_filter_list)

	return gear_promise:next(function (gear_list)
		if gear_list.has_next then
			Log.warning("GearService", "Response had more items than fits a page, remaining items will be ignored")
		end

		local items = {}

		for _, gear in pairs(gear_list.items) do
			local gear_id = gear.uuid
			local gear_item = MasterItems.get_item_instance(gear, gear_id)

			items[gear_id] = gear_item
		end

		return Promise.resolved({
			items = items,
			has_next = gear_list.has_next,
			next_page = function (data)
				return self:fetch_account_items_paged(nil, nil, gear_list.next_page(data))
			end,
		})
	end):catch(function (errors)
		local gear_list_error = unpack(errors)
		local error_string = tostring(gear_list_error)

		Log.error("GearService", "Error fetching account items: %s", error_string)
	end)
end

GearService.attach_item_as_override = function (self, item_id, attach_point, gear_id)
	return self._backend_interface.gear:attach_item_as_override(item_id, attach_point, gear_id):next(function (result)
		local gear = table.clone(result.item)
		local uuid = gear.uuid

		gear.uuid = nil

		self:on_gear_updated(uuid, gear)

		return result
	end):catch(function (err)
		self:invalidate_gear_cache()

		return Promise.rejected(err)
	end)
end

return GearService
