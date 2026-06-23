-- chunkname: @scripts/utilities/dlc_utils.lua

local DLCSettings = require("scripts/settings/dlc/dlc_settings")
local ItemUtils = require("scripts/utilities/items")
local Promise = require("scripts/foundation/utilities/promise")
local MasterItems = require("scripts/backend/master_items")
local DLCUtils = {}

local function _also_grants_recursive(dlc_id, ids_out, backend_auth_method, found_map)
	found_map = found_map or {
		[dlc_id] = true,
	}

	local also_grants = DLCSettings.also_grants[dlc_id]

	for i = 1, #also_grants do
		repeat
			local other_dlc_id = also_grants[i]

			if found_map[other_dlc_id] then
				break
			end

			found_map[other_dlc_id] = true
			ids_out[#ids_out + 1] = DLCSettings.dlcs[other_dlc_id].ids[backend_auth_method].id

			_also_grants_recursive(other_dlc_id, ids_out, backend_auth_method, found_map)
		until true
	end

	return ids_out
end

DLCUtils.get_ids_for_auth_method = function (dlc_id, backend_auth_method)
	local dlc_settings = DLCSettings.dlcs[dlc_id]
	local platform_settings = dlc_settings.ids[backend_auth_method]
	local ids = {
		platform_settings.id,
	}

	if not DLCSettings.client_predicted_includes_platforms[backend_auth_method] then
		return ids
	end

	ids = _also_grants_recursive(dlc_id, ids, backend_auth_method)

	return ids
end

DLCUtils.is_archetype_available = function (archetype)
	local requires_dlc = archetype.requires_dlc

	if not requires_dlc then
		return Promise.resolved({
			available = true,
			archetype = archetype,
		})
	end

	local availability_promise = Promise:new(function (resolve, reject)
		Managers.dlc:is_owner_of(archetype.requires_dlc):next(function (ok)
			resolve({
				archetype = archetype,
				available = ok,
			})
		end):catch(function (err)
			reject({
				archetype = archetype,
				error = err,
			})
		end)
	end)

	return availability_promise
end

DLCUtils.show_reward_notifications = function (dlc_updates)
	for i = 1, #dlc_updates do
		local dlc = dlc_updates[i]

		if dlc.status == "granted" then
			for j = 1, #dlc.rewards do
				local reward = dlc.rewards[j]

				if reward.rewardType == "item" then
					local gear_id = reward.gearId
					local master_id = reward.masterId

					if gear_id and master_id then
						local item = MasterItems.get_item(master_id)

						if item then
							local item_type = item.item_type

							if not table.array_contains(Managers.dlc.ITEM_TYPE_NOTIFICATION_BLACKLIST, item_type) then
								Managers.event:trigger("event_add_notification_message", "item_granted", MasterItems.get_item(master_id))
							end

							ItemUtils.mark_item_id_as_new({
								gear_id = gear_id,
								item_type = item_type,
							}, true)
						end
					end
				elseif reward.rewardType == "currency" then
					Managers.event:trigger("event_add_notification_message", "currency", {
						currency = reward.currencyType,
						amount = reward.amount,
					})
				end
			end
		end
	end
end

DLCUtils.update_local_gear_cache = function (dlc_updates)
	local gear_granted = {}
	local gear_revoked = {}
	local currency_granted = {}

	for i = 1, #dlc_updates do
		local dlc = dlc_updates[i]

		for j = 1, #dlc.rewards do
			local reward = dlc.rewards[j]

			if reward.rewardType == "item" then
				local gear_id = reward.gearId
				local master_id = reward.masterId

				if gear_id and master_id then
					local rewarded_master_item = MasterItems.get_item(master_id)

					rewarded_master_item.uuid = gear_id
					rewarded_master_item.masterDataInstance = {
						id = master_id,
						overrides = {},
						slots = rewarded_master_item.slots,
					}

					local _, gear = ItemUtils.track_reward_item_to_gear(rewarded_master_item)
					local gear_data = {
						gear_id = gear_id,
						gear = gear,
					}

					if dlc.status == "granted" then
						gear_granted[#gear_granted + 1] = gear_data
					elseif dlc.status == "revoked" then
						gear_revoked[#gear_revoked + 1] = gear_data
					end
				end
			elseif reward.rewardType == "currency" and dlc.status == "granted" then
				currency_granted[#currency_granted + 1] = {
					currency_type = reward.currencyType,
					amount = reward.amount,
				}
			end
		end
	end

	if #gear_granted > 0 or #gear_revoked > 0 then
		for i = 1, #gear_granted do
			Managers.data_service.gear:on_gear_created(gear_granted[i].gear_id, gear_granted[i].gear)
		end

		for i = 1, #gear_revoked do
			Managers.data_service.gear:on_gear_deleted(gear_revoked[i].gear_id, gear_revoked[i].gear)
		end

		Managers.event:trigger("event_gear_refresh_requested")
	end

	if #currency_granted > 0 then
		for i = 1, #currency_granted do
			Managers.data_service.store:change_cached_wallet_balance(currency_granted.currency_type, currency_granted.amount, true, "DLCUtils.update_local_gear_cache")
		end

		Managers.data_service.store:invalidate_wallets_cache()
	end
end

return DLCUtils
