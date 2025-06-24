-- chunkname: @scripts/managers/data_service/services/havoc_service.lua

local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local HavocService = class("HavocService")

HavocService.init = function (self, backend_interface)
	self._backend_interface = backend_interface

	Managers.event:register(self, "backend_havoc_mark_change", "_backend_havoc_mark_change")
end

HavocService.destroy = function (self)
	Managers.event:unregister(self, "backend_havoc_mark_change")
end

HavocService.set_show_promotion_info = function (self, value)
	self._show_promotion_info = value
end

HavocService.show_promotion_info = function (self)
	return self._show_promotion_info
end

HavocService.order_by_id = function (self, order_id)
	return Managers.backend.interfaces.orders:order_by_id(order_id):next(function (data)
		if data and data.charges and data.charges < 0 then
			local err = string.format("Backend returned an order with charge count below zero: %i\n", data.charges)

			Log.error("HavocService", err)
		end

		return data.body.order
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("HavocService", "Error fetching havoc orders: %s", error_string)

		return {}
	end)
end

HavocService.available_orders = function (self)
	return Managers.backend.interfaces.orders:orders_by_order_type("havoc"):next(function (data)
		return data
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("HavocService", "Error fetching havoc orders: %s", error_string)

		return {}
	end)
end

HavocService.default_havoc_cadence_status = function (self)
	return {
		active = true,
		current_cadence = {},
	}
end

HavocService.refresh_havoc_cadence_status = function (self)
	return Managers.data_service.havoc:summary():next(function (results)
		local havoc_cadence_status = results.cadence_status

		self._havoc_cadence_status = havoc_cadence_status

		return havoc_cadence_status
	end):catch(function (err)
		Log.exception("HavocService", err)
		Managers.data_service.havoc:_set_fallback_havoc_cadence_status()

		return self._havoc_cadence_status
	end)
end

HavocService.get_havoc_cadence_status = function (self)
	if self._havoc_cadence_status == nil then
		local err = "HavocService:get_havoc_cadence_status() called before HavocService:refresh_havoc_cadence_status was ever called"

		Log.error("HavocService", err)
		self:_set_fallback_havoc_cadence_status()
	end

	return self._havoc_cadence_status
end

HavocService._set_fallback_havoc_cadence_status = function (self)
	self._havoc_cadence_status = Managers.data_service.havoc:default_havoc_cadence_status()

	Log.info("Using fallback havoc_cadence_status")
end

HavocService.refresh_ever_received_havoc_order = function (self)
	return Managers.data_service.havoc:latest():next(function (results)
		local ever_received_havoc_order

		ever_received_havoc_order = results ~= nil and not table.is_empty(results) and results.id ~= nil and true or false
		self._ever_received_havoc_order = ever_received_havoc_order

		return ever_received_havoc_order
	end):catch(function (err)
		Log.exception("HavocService", err)
		self:_set_fallback_ever_received_havoc_order()

		return self._ever_received_havoc_order
	end)
end

HavocService.get_ever_received_havoc_order = function (self)
	if self._ever_received_havoc_order == nil then
		local err = "HavocService:get_ever_received_havoc_order() called before HavocService:refresh_get_ever_received_havoc_order() was ever called"

		Log.error("HavocService", err)
		self:_set_fallback_ever_received_havoc_order()
	end

	return self._ever_received_havoc_order
end

HavocService._set_fallback_ever_received_havoc_order = function (self)
	self._ever_received_havoc_order = false

	Log.info("Using fallback ever_received_havoc_order")
end

HavocService.refresh_havoc_unlock_status = function (self)
	return Managers.backend.interfaces.account:get_havoc_unlock_status():next(function (value)
		if value == nil then
			Log.info("Backend provided nil value for havoc_unlock_status")
			self:_set_fallback_havoc_unlock_status()

			return
		end

		local adjusted_value = value + 1

		if adjusted_value < 1 then
			local err = string.format("Backend provided index for havoc_unlock_status that was too low: %i", value)

			Log.exception("HavocService", err)
			self:_set_fallback_havoc_unlock_status()

			return
		end

		if adjusted_value > #NetworkLookup.havoc_unlock_status then
			local err = string.format("Backend provided index for havoc_unlock_status that was out of bounds for NetworkLookup.havoc_unlock_status: %i\n", value)

			Log.exception("HavocService", err)
			self:_set_fallback_havoc_unlock_status()

			return
		end

		local havoc_unlock_status = NetworkLookup.havoc_unlock_status[adjusted_value]

		self._havoc_unlock_status = havoc_unlock_status

		return havoc_unlock_status
	end):catch(function (err)
		Log.exception("HavocService", err)
		self:_set_fallback_havoc_unlock_status()

		return self._havoc_unlock_status
	end)
end

HavocService.get_havoc_unlock_status = function (self)
	if not self._havoc_unlock_status then
		local err = "HavocService:get_havoc_unlock_status() called before HavocService:refresh_havoc_status() was ever called"

		Log.error("HavocService", err)
		self:_set_fallback_havoc_unlock_status()
	end

	return self._havoc_unlock_status
end

HavocService._set_fallback_havoc_unlock_status = function (self)
	self._havoc_unlock_status = NetworkLookup.havoc_unlock_status[1]

	Log.info("Using fallback havoc_unlock_status.")
end

HavocService.set_havoc_unlock_status = function (self, value)
	local backend_value

	for i = 1, #NetworkLookup.havoc_unlock_status do
		if value == NetworkLookup.havoc_unlock_status[i] then
			backend_value = i - 1

			break
		end
	end

	Managers.backend.interfaces.account:set_havoc_unlock_status(backend_value):next(function ()
		self._havoc_unlock_status = value
	end):catch(function (err)
		local error_message = string.format("Error setting havoc_unlock_status: %s", err)

		Log.error("HavocService", error_message)
	end)
end

HavocService.summary = function (self)
	return Managers.backend.interfaces.havoc:summary():next(function (data)
		return data
	end):catch(function (err)
		local error_string = tostring(err)

		Log.error("HavocService", "Error fetching havoc summary: %s", error_string)
		ferror(error_string)

		return {}
	end)
end

HavocService.highest_rank = function (self)
	return Managers.backend.interfaces.havoc:summary():next(function (data)
		return data.highest_rank
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("HavocService", "Error fetching havoc highest rank: %s", error_string)

		return {}
	end)
end

HavocService.current_order = function (self)
	return Managers.backend.interfaces.havoc:summary():next(function (data)
		return data.current_order
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("HavocService", "Error fetching havoc current order: %s", error_string)

		return {}
	end)
end

HavocService.activate_havoc_mission = function (self, order_id)
	local party_members, party_manager

	if not party_manager then
		local party_manager = Managers.party_immaterium

		party_members = party_manager:all_members()
	end

	local participants = {}

	for i = 1, #party_members do
		participants[#participants + 1] = {
			accountId = party_members[i]:account_id(),
		}
	end

	return Managers.backend.interfaces.orders:activate_order_by_id(order_id, participants):next(function (data)
		return data
	end):catch(function (error)
		if error and error.code == 400 and string.find(error.description, "already_has_ongoing_mission") then
			Log.warning("HavocService", "Aborting Havoc mission activation; strike team member already has ongoing mission\n%s", error)
		else
			Log.warning("HavocService", "Exception activating havoc order:\n%s", tostring(error))
		end

		return Promise.rejected(error)
	end)
end

HavocService.check_ongoing_havoc = function (self)
	return Managers.backend.interfaces.orders:check_ongoing_missions():next(function (data)
		return data
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("HavocService", "Error fetching havoc orders: %s", error_string)

		return {}
	end)
end

HavocService.latest = function (self)
	return Managers.backend.interfaces.havoc:latest():next(function (data)
		return data
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("HavocService", "Error fetching latest havoc status: %s", error_string)

		return {}
	end)
end

HavocService.get_rewards_if_available = function (self)
	return Managers.backend.interfaces.havoc:sync():next(function (data)
		if data and data.rewards and not table.is_empty(data.rewards) then
			for i = 1, #data.rewards do
				local reward = data.rewards[i]
				local amount = reward.amount or 0

				if amount > 0 then
					Managers.data_service.store:invalidate_wallets_cache()

					break
				end
			end
		end

		return data
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("HavocService", "Error while syncing havoc: %s", error_string)

		return {}
	end)
end

HavocService._backend_havoc_mark_change = function (self, payload)
	self:refresh_havoc_status()
end

HavocService.refresh_havoc_status = function (self)
	if not GameParameters.prod_like_backend then
		return Promise.resolved()
	end

	return self._backend_interface.havoc:eligible():next(function (result)
		local status = result.eligible and "ok" or result.status_code

		Managers.presence:set_havoc_status(status)
		Managers.event:trigger("event_havoc_status_refreshed", status)
	end):catch(function (err)
		local status

		Managers.presence:set_havoc_status(status)
		Managers.event:trigger("event_havoc_status_refreshed", status)
		Log.error("HavocService", "Error fetching havoc status: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

local denied_info = {}

HavocService.can_all_party_members_play_havoc = function (self)
	table.clear(denied_info)

	local all_can_play = true
	local party_immaterium = Managers.party_immaterium

	if party_immaterium then
		local all_members = party_immaterium:all_members()

		for i = 1, #all_members do
			local member = all_members[i]
			local presence = member:presence()
			local status = presence:havoc_status()

			if status ~= "ok" then
				denied_info[#denied_info + 1] = {
					member = member,
					denied_reason = status,
					is_myself = presence:is_myself(),
				}
				all_can_play = false
			end
		end
	end

	return all_can_play, denied_info
end

HavocService.get_settings = function (self)
	return Managers.backend.interfaces.havoc:settings()
end

HavocService.status_by_id = function (self, status_id)
	return Managers.backend.interfaces.havoc:status_by_id(status_id)
end

HavocService.history = function (self, status_id, size)
	local status_promise

	if not status_id then
		status_promise = self:latest():next(function (data)
			return Promise.resolved(data.id)
		end)
	else
		status_promise = Promise.resolved(status_id)
	end

	return status_promise:next(function (id)
		return Managers.backend.interfaces.havoc:fetch_paged_history(id, size)
	end)
end

HavocService.refresh_havoc_rank = function (self)
	if not GameParameters.prod_like_backend then
		return Promise.resolved()
	end

	return self._backend_interface.havoc:latest():next(function (result)
		Managers.presence:set_havoc_rank_all_time_high(result.rank_all_time)
		Managers.presence:set_havoc_rank_cadence_high(result.rank_cadence)
	end):catch(function (err)
		Managers.presence:set_havoc_rank_cadence_high(nil)
		Managers.presence:set_havoc_rank_all_time_high(nil)
		Log.error("HavocService", "Error fetching havoc data: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

HavocService.havoc_rank_cadence_high = function (self, account_id)
	local rank_promise = Promise.new()

	if not GameParameters.prod_like_backend or not math.is_uuid(account_id) then
		rank_promise:resolve(nil)

		return rank_promise
	end

	local _, presence_promise = Managers.presence:get_presence(account_id)

	presence_promise:next(function (presence)
		local rank = presence and presence:havoc_rank_cadence_high()

		rank_promise:resolve(rank)
	end):catch(function (err)
		Log.error("HavocService", "Failed getting presence: %s", table.tostring(err, 5))
		rank_promise:resolve(nil)
	end)

	return rank_promise
end

HavocService.havoc_rank_all_time_high = function (self, account_id)
	local rank_promise = Promise.new()

	if not GameParameters.prod_like_backend or not math.is_uuid(account_id) then
		rank_promise:resolve(nil)

		return rank_promise
	end

	local _, presence_promise = Managers.presence:get_presence(account_id)

	presence_promise:next(function (presence)
		local rank = presence and presence:havoc_rank_all_time_high()

		rank_promise:resolve(rank)
	end):catch(function (err)
		Log.error("HavocService", "Failed getting presence: %s", table.tostring(err, 5))
		rank_promise:resolve(nil)
	end)

	return rank_promise
end

HavocService.reject_order = function (self, order_id)
	return Managers.backend.interfaces.havoc:reject_order(order_id)
end

HavocService.delete_personal_mission = function (self, mission_id)
	return Managers.backend.interfaces.havoc:delete_personal_mission(mission_id)
end

HavocService.personal_mission = function (self, mission_id)
	return Managers.backend.interfaces.havoc:personal_mission(mission_id)
end

return HavocService
