local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local GearService = class("GearService")

GearService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
end

GearService.force_offline_mode = function (self)
	self._offline_mode = true
end

local function _fetch_placeholder_inventory(slot_filter_list)
	local items = {}
	local gear_id_counter = 1
	local item_definitions = MasterItems.get_cached()

	for _, item_definition in pairs(item_definitions) do
		local gear_id = gear_id_counter
		gear_id_counter = gear_id_counter + 1
		local item = table.clone(item_definition)
		item.gear_id = gear_id
		items[gear_id] = item
	end

	if slot_filter_list then
		for gear_id, item in pairs(items) do
			local slot_approved = false
			local slots = item.slots

			if slots then
				for _, slot_name in ipairs(slots) do
					if table.contains(slot_filter_list, slot_name) then
						slot_approved = true

						break
					end
				end
			end

			if not slot_approved then
				items[gear_id] = nil
			end
		end
	end

	return Promise.resolved(items)
end

GearService.fetch_inventory = function (self, character_id)
	if self._offline_mode or not Managers.backend:authenticated() then
		return _fetch_placeholder_inventory()
	end

	local backend_interface = self._backend_interface
	local gear_promise = backend_interface.gear:fetch()

	return gear_promise:next(function (gear_list)
		local items = {}

		for gear_id, gear in pairs(gear_list) do
			if gear.characterId == character_id then
				gear_id = gear.uuid or gear_id
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

GearService.fetch_inventory_paged = function (self, character_id, item_amount, slot_filter_list)
	if self._offline_mode or not Managers.backend:authenticated() then
		return _fetch_placeholder_inventory(slot_filter_list)
	end

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

GearService.fetch_account_items_paged = function (self, item_amount, slot_filter_list)
	local backend_interface = self._backend_interface
	local gear_promise = backend_interface.gear:fetch_paged(item_amount or 100, slot_filter_list)

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

		return Promise.resolved(items)
	end):catch(function (errors)
		local gear_list_error = unpack(errors)
		local error_string = tostring(gear_list_error)

		Log.error("GearService", "Error fetching account items: %s", error_string)
	end)
end

return GearService
