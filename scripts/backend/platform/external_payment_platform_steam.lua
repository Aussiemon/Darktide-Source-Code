-- chunkname: @scripts/backend/platform/external_payment_platform_steam.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local ExternalPaymentPlatformSteam = class("ExternalPaymentPlatformSteam", "ExternalPaymentPlatformBase")

ExternalPaymentPlatformSteam.get_payment_platform = function (self)
	return "steam"
end

ExternalPaymentPlatformSteam.get_platform_token = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformSteam.update_account_store_status = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformSteam.reconcile_pending_txns = function (self)
	return self:get_platform_token():next(function (token)
		return Managers.backend:authenticate():next(function (account)
			local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments/reconcile"):query("platform", self:get_payment_platform())

			return Managers.backend:title_request(builder:to_string(), {
				method = "POST",
				headers = {
					["platform-token"] = token,
				},
			}):next(function (response)
				return response.body
			end)
		end)
	end)
end

ExternalPaymentPlatformSteam.reconcile_account_entitlements = function (self)
	return self:get_platform_token():next(function (token)
		return Managers.backend:authenticate():next(function (account)
			local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/entitlements/reconcile"):query("platform", self:get_payment_platform())

			return Managers.backend:title_request(builder:to_string(), {
				method = "POST",
			}):next(function (response)
				return response.body
			end)
		end)
	end):catch(function (error)
		if type(error) == "table" and error.message then
			error = error.message
		end

		Log.exception("ExternalPayment", "Failed to reconcile account entitlements, error: %s", tostring(error))

		return Promise.rejected({
			error,
		})
	end)
end

ExternalPaymentPlatformSteam.init_txn = function (self, payment_option)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments"):query("platform", self:get_payment_platform())

		return Managers.backend:title_request(builder:to_string(), {
			method = "POST",
			body = {
				paymentOptionId = payment_option,
			},
		}):next(function (response)
			return response.body.orderId
		end)
	end)
end

ExternalPaymentPlatformSteam.finalize_txn = function (self, order_id)
	return self:get_platform_token():next(function (token)
		return Managers.backend:authenticate():next(function (account)
			local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments/"):path(order_id):query("platform", self:get_payment_platform())

			return Managers.backend:title_request(builder:to_string(), {
				method = "POST",
				body = {
					placeholder = "",
				},
				headers = {
					["platform-token"] = token,
				},
			}):next(function (response)
				return response.body.data
			end)
		end)
	end)
end

ExternalPaymentPlatformSteam.fail_txn = function (self, order_id)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments/"):path(order_id):query("platform", self:get_payment_platform())

		return Managers.backend:title_request(builder:to_string(), {
			method = "DELETE",
		}):catch(function (error)
			Log.error("ExternalPayment", "Failed to remove pending transaction %s", tostring(error))

			return Promise.rejected({
				error = error,
			})
		end)
	end)
end

local FAILED_TXN = {
	body = {
		state = "failed",
	},
}

ExternalPaymentPlatformSteam._decorate_option = function (self, option, platform_entitlements)
	option.description = {
		type = "currency",
		description = option.value.amount .. " " .. option.value.type,
	}
	option.price = {
		amount = {},
	}
	option.price.amount.amount = option.steam.priceCents / 100
	option.price.amount.type = option.steam.currency

	option._on_micro_txn = function (self, authorized, order_id)
		if authorized then
			Managers.backend.interfaces.external_payment:finalize_txn(order_id):next(function (data)
				self.pending_txn_promise:resolve(data)

				self.pending_txn_promise = nil

				return data
			end):catch(function (data)
				self.pending_txn_promise:resolve(FAILED_TXN)

				self.pending_txn_promise = nil

				return data
			end)
		else
			Managers.backend.interfaces.external_payment:fail_txn(order_id):next(function (data)
				self.pending_txn_promise:resolve(data)

				self.pending_txn_promise = nil

				return data
			end):catch(function (data)
				self.pending_txn_promise:resolve(FAILED_TXN)

				self.pending_txn_promise = nil

				return data
			end)
		end
	end

	option.seconds_remaining = function (self, now)
		return nil
	end

	option.make_purchase = function (self)
		if self.pending_txn_promise then
			return Promise.rejected({
				message = "Called init transaction when a transaction was already pending",
			})
		end

		local pending_txn_promise = Promise:new()

		self.pending_txn_promise = pending_txn_promise

		Managers.backend.interfaces.external_payment:init_txn(self.id):next(function (order_id)
			Managers.steam:register_micro_txn_callback(order_id, callback(self, "_on_micro_txn"))
		end):catch(function (_)
			self.pending_txn_promise:resolve(FAILED_TXN)

			self.pending_txn_promise = nil
		end)

		return pending_txn_promise
	end
end

ExternalPaymentPlatformSteam._get_entitlements = function (self)
	return Promise.resolved({
		success = true,
	})
end

return ExternalPaymentPlatformSteam
