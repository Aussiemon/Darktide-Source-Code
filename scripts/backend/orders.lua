-- chunkname: @scripts/backend/orders.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local Orders = class("Orders")

Orders.order_by_id = function (self, order_id, optional_account_id)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/orders/"):path(order_id)
		local options = {
			method = "GET"
		}

		return Managers.backend:title_request(builder:to_string(), options)
	end):catch(function (error)
		return Promise.rejected(error)
	end)
end

Orders.orders_by_order_type = function (self, order_type, optional_account_id)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/orders/"):path("type/"):path(order_type)
		local options = {
			method = "GET"
		}

		return Managers.backend:title_request(builder:to_string(), options):next(function (data)
			if data.status == 200 then
				return data.body.orders
			else
				return Promise.rejected(data)
			end
		end)
	end):catch(function (error)
		return Promise.rejected(error)
	end)
end

Orders.join_personal_mission = function (self, owner_id, mission_id, joiner_id)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/data/"):path(owner_id):path("/account"):path("/missions/"):path(mission_id):path("/data")
		local options = {
			method = "POST",
			body = {
				type = "playerJoin",
				accountId = joiner_id
			}
		}

		return Managers.backend:title_request(builder:to_string(), options):next(function (data)
			if data.status == 200 then
				return data
			else
				return Promise.rejected(data)
			end
		end):catch(function (error)
			local error_string = tostring(error)

			Log.error("Orders", "Error caught in Orders:join_personal_mission():\n%s", error_string)

			return {}
		end)
	end)
end

Orders.activate_order_by_id = function (self, order_id, participants, optional_account_id)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/orders/"):path(order_id):path("/activate")
		local options = {
			method = "POST",
			body = {
				participants = participants
			}
		}

		return Managers.backend:title_request(builder:to_string(), options):next(function (data)
			if data.status == 200 then
				return data.body.mission
			end
		end):catch(function (error)
			return Promise.rejected(error)
		end)
	end):catch(function (error)
		return Promise.rejected(error)
	end)
end

Orders.check_ongoing_missions = function (self)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/account"):path("/missions")
		local options = {
			method = "GET"
		}

		return Managers.backend:title_request(builder:to_string(), options):next(function (data)
			if data.status == 200 then
				return data.body.missions
			else
				return Promise.rejected(data)
			end
		end)
	end):catch(function (error)
		return Promise.rejected(error)
	end)
end

return Orders
