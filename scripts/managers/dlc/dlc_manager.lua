-- chunkname: @scripts/managers/dlc/dlc_manager.lua

local DLCSettings = require("scripts/managers/dlc/dlc_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtils = require("scripts/foundation/utilities/xbox_live_utils")
local DLCManager = class("DLCManager")
local EVALUATE_CONSUMABLES_TIMER = 30
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
	self._initialized = false
end

DLCManager.initialize = function (self)
	local is_psn = Backend.get_auth_method() == Backend.AUTH_METHOD_PSN

	if IS_XBS or IS_GDK then
		if not rawget(_G, "XboxDLC") then
			return
		end

		self._evaluate_consumables_timer = 0

		XboxDLC.enumerate_dlcs()
	elseif is_psn then
		self._evaluate_consumables_timer = 0
	else
		self._check_steam_dlc = true
	end

	self._state = "idle"

	table.clear(self._durable_dlcs)

	local durable_dlc_settings = DLCSettings.durable_dlcs

	for i = 1, #durable_dlc_settings do
		local durable_dlc_data = durable_dlc_settings[i]
		local name = durable_dlc_data.name
		local class_name = durable_dlc_data.class_name
		local class = CLASSES[class_name]

		self._durable_dlcs[name] = class:new(durable_dlc_data)
	end

	self._initialized = true
end

DLCManager.destroy = function (self)
	return
end

DLCManager.evaluate_consumables = function (self)
	self._evaluate_consumables = true
end

DLCManager.is_owner_of = function (self, product_ids)
	local result_promises = {}

	for k, v in pairs(product_ids) do
		table.insert(result_promises, Managers.account:is_owner_of(v))
	end

	return Promise.all(unpack(result_promises)):next(function (results)
		for _, result in ipairs(results) do
			if result.is_owner then
				return true
			end
		end

		return false
	end, function (errors)
		return false
	end)
end

DLCManager.open_dlc_view = function (self, dlc_settings, on_flow_finished_callback)
	local has_steam_overlay = Backend.get_auth_method() == Backend.AUTH_METHOD_STEAM and Steam.is_overlay_enabled()

	if not has_steam_overlay then
		Managers.ui:open_view("dlc_purchase_view", nil, false, false, nil, {
			dlc_settings = dlc_settings,
			on_flow_finished_callback = on_flow_finished_callback,
		})

		return
	end

	self:open_to_store(dlc_settings.steam_dlc_target, on_flow_finished_callback)
end

DLCManager.open_to_store = function (self, product_id, on_flow_finished_callback)
	Managers.account:open_to_store(product_id):next(function (result)
		if on_flow_finished_callback then
			on_flow_finished_callback(result.success)
		end
	end)
end

DLCManager._ui_in_blocked_state = function (self)
	if Managers.ui:has_active_view() then
		local active_views = Managers.ui:active_views()
		local top_view = active_views[#active_views]

		return top_view ~= "main_menu_view"
	end

	return false
end

DLCManager._try_check_steam_dlc = function (self, t)
	if not self._initialized then
		return
	end

	if not self._check_steam_dlc then
		return
	end

	local is_psn = Backend.get_auth_method() == Backend.AUTH_METHOD_PSN

	if IS_XBS or IS_GDK or is_psn then
		self._check_steam_dlc = false

		return
	end

	if self:_ui_in_blocked_state() then
		return
	end

	self._check_steam_dlc = false

	local cb_query_backend_result = callback(self, "cb_query_backend_result")

	Managers.backend.interfaces.external_payment:reconcile_dlc():next(cb_query_backend_result)
end

DLCManager._try_evaluate_consumables = function (self, t)
	if not self._initialized then
		return
	end

	local is_psn = Backend.get_auth_method() == Backend.AUTH_METHOD_PSN

	if not IS_XBS and not IS_GDK and not is_psn then
		self._evaluate_consumables = false

		return
	end

	if not self._evaluate_consumables then
		return
	end

	if self:_ui_in_blocked_state() then
		return
	end

	local mechanism_name = Managers.mechanism:mechanism_name()

	if mechanism_name ~= "hub" then
		self._evaluate_consumables = false

		return
	end

	if t > self._evaluate_consumables_timer then
		if IS_XBS or IS_GDK then
			local success_cb = callback(self, "cb_get_entitlements")

			XboxLiveUtils.get_entitlements():next(success_cb)
		else
			local cb_query_backend_result = callback(self, "cb_query_backend_result")

			Managers.backend.interfaces.external_payment:reconcile_dlc():next(cb_query_backend_result)
		end

		self._evaluate_consumables_timer = t + EVALUATE_CONSUMABLES_TIMER
		self._evaluate_consumables = false
	end
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
			is_consumable = product_kind == "consumable" or product_kind == "unmanaged" or is_consumable
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
				description_text = "loc_dlc_installed",
				title_text = "loc_popup_header_new_dlc_installed",
				description_text_params = {
					dlc_name = data.title,
					dlc_description = data.description,
				},
				options = {
					{
						close_on_pressed = true,
						text = "loc_popup_unavailable_view_button_confirm",
						callback = callback(self, "_cb_popup_closed"),
					},
				},
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

	if #results == 0 and (IS_XBS or IS_GDK) then
		Crashify.print_exception("DLCManager", "Got empty dlcUpdates from backend, can not parse dlc rewards")
	end

	for i = 1, #results do
		local result_data = results[i]

		reward_queue[#reward_queue + 1] = result_data
	end

	self._rewards_dirty = true
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
		description_text = "loc_dlc_installed",
		title_text = "loc_popup_header_new_dlc_installed",
		description_text_params = {
			dlc_name = dlc_details.display_name,
			dlc_description = dlc_details.description,
		},
		options = {
			{
				close_on_pressed = true,
				text = "loc_popup_unavailable_view_button_confirm",
				callback = callback(self, "_cb_popup_closed"),
			},
		},
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
				text = Localize("loc_failed_to_redeem_dlc", true, {
					dlc_name = self._pending_dlc_lookup[store_id],
				}),
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
	if dlc_manager._rewards_dirty then
		dlc_manager:_change_state("present_rewards")

		return
	end

	local is_psn = Backend.get_auth_method() == Backend.AUTH_METHOD_PSN

	if IS_XBS or IS_GDK then
		local dlc_status = XboxDLC.state()

		if dlc_status == XboxDLCState.PACKAGE_INSTALLED then
			dlc_manager:_change_state("check_durable_licenses")
		else
			dlc_manager:_try_evaluate_consumables(t)
		end
	elseif is_psn then
		dlc_manager:_try_evaluate_consumables(t)
	else
		dlc_manager:_try_check_steam_dlc(t)
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

		Managers.backend.interfaces.external_payment:reconcile_dlc(NEW_DLCS):next(cb_query_backend_result)
	end

	dlc_manager:_change_state("idle")
end

DLCStates.present_rewards = function (dlc_manager, dt, t)
	if table.size(dlc_manager._popup_ids) > 0 then
		return
	end

	local item_rewards = {}
	local currency_rewarded = false

	for i = 1, #dlc_manager._reward_queue do
		local reward_data = dlc_manager._reward_queue[i]
		local store_id = reward_data.platformId
		local rewards = reward_data.rewards

		for j = 1, #rewards do
			local reward = rewards[j]

			if reward.rewardType == "currency" then
				Managers.event:trigger("event_add_notification_message", "currency", {
					currency = reward.currencyType,
					amount = reward.amount,
				})

				currency_rewarded = true
			elseif reward.rewardType == "item" then
				local gear_id = reward.gearId
				local master_id = reward.masterId

				if gear_id and master_id then
					local item = MasterItems.get_item(master_id)

					if item then
						local item_type = item.item_type

						item_rewards[#item_rewards + 1] = {
							gear_id = gear_id,
							item_type = item_type,
						}
					end
				end
			end
		end

		dlc_manager:_consume_pending_dlc(store_id)
	end

	if #item_rewards > 0 then
		Managers.data_service.gear:invalidate_gear_cache()

		for i = 1, #item_rewards do
			local reward = item_rewards[i]

			ItemUtils.mark_item_id_as_new(reward)
		end
	end

	if currency_rewarded then
		Managers.data_service.store:invalidate_wallets_cache()
	end

	dlc_manager:_handle_dangling_pending_dlcs()
	table.clear(dlc_manager._reward_queue)

	dlc_manager._rewards_dirty = nil

	dlc_manager:_change_state("idle")
end

return DLCManager
