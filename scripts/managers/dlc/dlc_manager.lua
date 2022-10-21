local DLCDurable = require("scripts/managers/dlc/dlc_durable")
local DLCSettings = require("scripts/managers/dlc/dlc_settings")
local XboxLiveUtils = require("scripts/foundation/utilities/xbox_live")
local DLCManager = class("DLCManager")
local DEBUG = true

local function dprint(...)
	if DEBUG then
		print("[DLCManager]", string.format(...))
	end
end

DLCManager.init = function (self)
	self._state = "none"
	self._durable_dlcs = {}
	self._popup_ids = {}
	self._reward_queue = {}
	self._pending_dlcs = {}
	self._pending_dlc_lookup = {}
end

DLCManager.initialize = function (self)
	if IS_XBS or IS_GDK then
		if not rawget(_G, "XboxDLC") then
			return
		end

		XboxDLC.enumerate_dlcs()
		self:evaluate_consumables()

		self._state = "idle"

		Managers.event:register(self, "event_loading_finished", "evaluate_consumables")
	end

	table.clear(self._durable_dlcs)

	local durable_dlc_settings = DLCSettings.durable_dlcs

	for i = 1, #durable_dlc_settings do
		local durable_dlc_data = durable_dlc_settings[i]
		local name = durable_dlc_data.name
		local class_name = durable_dlc_data.class_name
		local class = CLASSES[class_name]
		self._durable_dlcs[name] = class:new(durable_dlc_data)
	end
end

DLCManager.destroy = function (self)
	Managers.event:unregister(self, "event_loading_finished")
end

DLCManager.evaluate_consumables = function (self)
	local success_cb = callback(self, "cb_get_entitlements")

	XboxLiveUtils.get_entitlements():next(success_cb)
end

local TEMP_STORE_IDS = {}
local TEMP_STORE_DATA = {}

DLCManager.cb_get_entitlements = function (self, data)
	local success = data.success

	if not success then
		return
	end

	table.clear(TEMP_STORE_IDS)
	table.clear(TEMP_STORE_DATA)

	local results = data.data or {}

	for store_id, data in pairs(results) do
		local is_in_user_collection = data.isInUserCollection
		local product_kinds = data.productKind
		local is_consumable = false

		for _, product_kind in ipairs(product_kinds) do
			if product_kind ~= "consumable" and product_kind ~= "unmanaged" then
				if false then
					is_consumable = false
				end
			else
				is_consumable = true
			end
		end

		if is_in_user_collection and is_consumable then
			local skus = data.skus

			for _, sku_data in ipairs(skus) do
				local collection_data = sku_data.collectionData

				if collection_data.quantity > 0 then
					for i = 1, collection_data.quantity do
						TEMP_STORE_DATA[#TEMP_STORE_DATA + 1] = data
					end

					TEMP_STORE_IDS[#TEMP_STORE_IDS + 1] = data.storeId

					break
				end
			end
		end
	end

	if table.size(TEMP_STORE_IDS) > 0 then
		Log.info("DLCManager", "************ Found new consumables ************")

		for _, data in ipairs(TEMP_STORE_DATA) do
			Log.info("DLCManager", "Name: %q StoreID: %q", data.title, data.storeId)
		end

		Log.info("DLCManager", "***********************************************")

		for _, data in pairs(TEMP_STORE_DATA) do
			local context = {
				title_text = "loc_popup_header_new_dlc_installed",
				description_text = "loc_dlc_installed",
				description_text_params = {
					dlc_name = data.title,
					dlc_description = data.description
				},
				options = {
					{
						text = "loc_popup_unavailable_view_button_confirm",
						close_on_pressed = true,
						callback = callback(self, "_cb_popup_closed")
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context, function (id)
				self._popup_ids[#self._popup_ids + 1] = id
			end)
			self:_add_pending_dlc(data.storeId, data.title)
		end

		local cb_query_backend_result = callback(self, "cb_query_backend_result")

		Managers.backend.interfaces.external_payment:reconcile_dlc(TEMP_STORE_IDS):next(cb_query_backend_result)
	end
end

DLCManager.cb_query_backend_result = function (self, data)
	local reward_queue = self._reward_queue
	local results = data.dlcUpdates

	for i = 1, #results do
		local result_data = results[i]
		reward_queue[#reward_queue + 1] = result_data
	end
end

DLCManager.is_dlc_unlocked = function (self, dlc_name)
	local durable_dlc = self._durable_dlcs[dlc_name]

	if durable_dlc then
		return durable_dlc:has_license()
	end

	return false
end

DLCManager.update = function (self, dt, t)
	if IS_XBS and not rawget(_G, "XboxDLC") then
		return
	end

	if table.is_empty(self._popup_ids) then
		DLCStates[self._state](self, dt, t)
	end
end

DLCManager.trigger_new_durable_dlc_popup = function (self, dlc_details)
	local context = {
		title_text = "loc_popup_header_new_dlc_installed",
		description_text = "loc_dlc_installed",
		description_text_params = {
			dlc_name = dlc_details.display_name,
			dlc_description = dlc_details.description
		},
		options = {
			{
				text = "loc_popup_unavailable_view_button_confirm",
				close_on_pressed = true,
				callback = callback(self, "_cb_popup_closed")
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._popup_ids[#self._popup_ids + 1] = id
	end)
end

DLCManager._cb_popup_closed = function (self, popup_id)
	local index = table.find(self._popup_ids, popup_id)

	table.remove(self._popup_ids, index)
end

DLCManager._add_pending_dlc = function (self, store_id, display_name)
	self._pending_dlcs[store_id] = (self._pending_dlcs[store_id] or 0) + 1
	self._pending_dlc_lookup[store_id] = display_name
end

DLCManager._consume_pending_dlc = function (self, store_id)
	if not self._pending_dlcs[store_id] then
		return
	end

	self._pending_dlcs[store_id] = math.max((self._pending_dlcs[store_id] or 0) - 1, 0)
end

DLCManager._handle_dangling_pending_dlcs = function (self)
	for store_id, instances in pairs(self._pending_dlcs) do
		for i = 1, instances do
			Managers.event:trigger("event_add_notification_message", "alert", {
				text = string.format("%s: %s", "Failed granting", self._pending_dlc_lookup[store_id])
			})
		end
	end

	table.clear(self._pending_dlcs)
end

DLCManager._change_state = function (self, state_name)
	dprint("Leaving state: %q", self._state)

	self._state = state_name

	dprint("Entering state: %q", self._state)
end

DLCStates = DLCStates or {}

DLCStates.none = function ()
	return
end

DLCStates.idle = function (dlc_manager, dt, t)
	if table.size(dlc_manager._reward_queue) > 0 then
		dlc_manager:_change_state("present_rewards")
	end

	local dlc_status = XboxDLC.state()

	if dlc_status == XboxDLCState.PACKAGE_INSTALLED then
		dlc_manager:_change_state("check_durable_licenses")
	end
end

DLCStates.check_durable_licenses = function (dlc_manager, dt, t)
	if XboxDLC.is_refreshing() then
		return
	end

	local dlcs = dlc_manager._durable_dlcs

	for name, dlc in pairs(dlcs) do
		dlc:refresh_data()
	end

	dlc_manager:_change_state("handle_status_changes")
end

local NEW_DLCS = {}

DLCStates.handle_status_changes = function (dlc_manager, dt, t)
	local dlcs = dlc_manager._durable_dlcs

	table.clear(NEW_DLCS)

	for name, dlc in pairs(dlcs) do
		if dlc:license_status_changed() and dlc:has_license() then
			local store_id = dlc:id()
			local package_details = dlc:package_details()

			dlc_manager:trigger_new_durable_dlc_popup(package_details)

			NEW_DLCS[#NEW_DLCS + 1] = store_id

			dlc_manager:_add_pending_dlc(store_id, package_details.display_name)
		end
	end

	if table.size(NEW_DLCS) > 0 then
		local cb_query_backend_result = callback(dlc_manager, "cb_query_backend_result")

		Managers.backend.interfaces.external_payment:reconcile_dlc(new_dlcs):next(cb_query_backend_result)
	end

	dlc_manager:_change_state("idle")
end

DLCStates.present_rewards = function (dlc_manager, dt, t)
	if table.size(dlc_manager._popup_ids) > 0 then
		return
	end

	for i = 1, #dlc_manager._reward_queue do
		local reward_data = dlc_manager._reward_queue[i]
		local store_id = reward_data.storeId
		local rewards = reward_data.rewards

		for i = 1, #rewards do
			local reward = rewards[1]

			if reward.rewardType == "currency" then
				Managers.event:trigger("event_add_notification_message", "currency", {
					currency = reward.currencyType,
					amount = reward.amount
				})
			elseif reward.rewardType == "item" then
				local gear_id = reward.gear_id
				local item = MasterItems.get_item(gear_id)
				local item_type = item.item_type

				ItemUtils.mark_item_id_as_new(gear_id, item_type)
			end
		end

		dlc_manager:_consume_pending_dlc(store_id)
	end

	dlc_manager:_handle_dangling_pending_dlcs()
	table.clear(dlc_manager._reward_queue)
	dlc_manager:_change_state("idle")
end

return DLCManager
