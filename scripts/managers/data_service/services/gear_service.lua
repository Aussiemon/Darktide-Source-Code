-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
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

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._offline_mode or not Managers.backend:authenticated() then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 11-13, warpins: 2 ---
		return _fetch_placeholder_inventory(slot_filter_list)
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 14-19, warpins: 1 ---
	local backend_interface = self._backend_interface
	local gear_promise = backend_interface.gear:fetch_paged(item_amount or 100, slot_filter_list)

	return gear_promise:next(function (gear_list)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-3, warpins: 1 ---
		if gear_list.has_next then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 4-8, warpins: 1 ---
			Log.warning("GearService", "Response had more items than fits a page, remaining items will be ignored")
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 9-13, warpins: 2 ---
		local items = {}

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 14-40, warpins: 0 ---
		for _, gear in pairs(gear_list.items) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 14-17, warpins: 1 ---
			local character_match = gear.characterId == character_id
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 21-23, warpins: 2 ---
			local account_owned = gear.characterId == nil
			--- END OF BLOCK #1 ---

			FLOW; TARGET BLOCK #2



			-- Decompilation error in this vicinity:
			--- BLOCK #2 27-28, warpins: 2 ---
			local include_item = character_match or account_owned

			--- END OF BLOCK #2 ---

			FLOW; TARGET BLOCK #3



			-- Decompilation error in this vicinity:
			--- BLOCK #3 30-31, warpins: 2 ---
			if include_item then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 32-38, warpins: 1 ---
				local gear_id = gear.uuid
				local gear_item = MasterItems.get_item_instance(gear, gear_id)
				items[gear_id] = gear_item
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #3 ---

			FLOW; TARGET BLOCK #4



			-- Decompilation error in this vicinity:
			--- BLOCK #4 39-40, warpins: 3 ---
			--- END OF BLOCK #4 ---



		end

		--- END OF BLOCK #2 ---

		FLOW; TARGET BLOCK #3



		-- Decompilation error in this vicinity:
		--- BLOCK #3 41-44, warpins: 1 ---
		return Promise.resolved(items)
		--- END OF BLOCK #3 ---



	end):catch(function (errors)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-13, warpins: 1 ---
		local gear_list_error = unpack(errors)
		local error_string = tostring(gear_list_error)

		Log.error("GearService", "Error fetching inventory items: %s", error_string)

		return
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 21-31, warpins: 2 ---
	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 32-32, warpins: 2 ---
	--- END OF BLOCK #3 ---



end

GearService.fetch_account_items_paged = function (self, item_amount, slot_filter_list)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local backend_interface = self._backend_interface
	local gear_promise = backend_interface.gear:fetch_paged(item_amount or 100, slot_filter_list)

	return gear_promise:next(function (gear_list)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-3, warpins: 1 ---
		if gear_list.has_next then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 4-8, warpins: 1 ---
			Log.warning("GearService", "Response had more items than fits a page, remaining items will be ignored")
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 9-13, warpins: 2 ---
		local items = {}

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 14-22, warpins: 0 ---
		for _, gear in pairs(gear_list.items) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 14-20, warpins: 1 ---
			local gear_id = gear.uuid
			local gear_item = MasterItems.get_item_instance(gear, gear_id)
			items[gear_id] = gear_item
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 21-22, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #2 ---

		FLOW; TARGET BLOCK #3



		-- Decompilation error in this vicinity:
		--- BLOCK #3 23-26, warpins: 1 ---
		return Promise.resolved(items)
		--- END OF BLOCK #3 ---



	end):catch(function (errors)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-13, warpins: 1 ---
		local gear_list_error = unpack(errors)
		local error_string = tostring(gear_list_error)

		Log.error("GearService", "Error fetching account items: %s", error_string)

		return
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-18, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

return GearService
