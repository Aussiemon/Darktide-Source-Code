-- chunkname: @scripts/managers/data_service/services/havoc_service.lua

local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
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

HavocService.get_havoc_unlock_status = function (self)
	return Managers.backend.interfaces.account:get_havoc_unlock_status():next(function (value)
		return value
	end):catch(function (err)
		Log.error("HavocService", "Error getting havoc_unlock_status")

		return Promise.rejected(err)
	end)
end

HavocService.set_havoc_unlock_status = function (self, value)
	return Managers.backend.interfaces.account:set_havoc_unlock_status(value):catch(function (err)
		Log.error("HavocService", "Error setting havoc_unlock_status")

		return Promise.rejected(err)
	end)
end

HavocService.summary = function (self)
	return Managers.backend.interfaces.account:summary():next(function (data)
		return data
	end):catch(function (err)
		local error_string = tostring(err)

		Log.error("HavocService", "Error fetching havoc summary: %s", error_string)

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
		local error_string = tostring(error)

		Log.error("HavocService", "Error fetching havoc orders: %s", error_string)

		return {}
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
	end):catch(function (err)
		Managers.presence:set_havoc_rank_all_time_high(nil)
		Log.error("HavocService", "Error fetching havoc rank all time high: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
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

return HavocService
