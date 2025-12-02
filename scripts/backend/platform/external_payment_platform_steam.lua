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

		if not Steam.is_overlay_enabled() then
			return Promise.rejected({
				message = "Cannot purchase premium currency with overlay disabled",
				player_message = "loc_premium_currency_steam_overlay_disabled",
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

ExternalPaymentPlatformSteam._clean_options = function (self, options)
	for i, v in ipairs(options) do
		local clean_offer
		local steam_data = v.steam or v.productIds and v.productIds.steam

		if steam_data and steam_data.priceCents then
			clean_offer = {}

			local currency = steam_data.currency

			clean_offer.base_price = steam_data.priceCentsOriginal or steam_data.priceCents
			clean_offer.discount_price = steam_data.priceCentsOriginal and steam_data.priceCents
			clean_offer.item_id = steam_data.itemId
			clean_offer.product_id = type(steam_data.productId) == "number" and steam_data.productId or tonumber(steam_data.productId, 10)
			clean_offer.description = steam_data.description
			clean_offer.formatted_price = string.format("%.2f %s", clean_offer.base_price / 100, currency)
			clean_offer.is_platform_option = v.description.type == "platform_option"
			clean_offer.metadata = v.metadata or {}

			if clean_offer.discount_price then
				clean_offer.formatted_original_price = clean_offer.formatted_price
				clean_offer.formatted_price = string.format("%.2f %s", clean_offer.discount_price / 100, currency)
			end
		end

		options[i].clean_offer = clean_offer
	end

	return options
end

ExternalPaymentPlatformSteam._is_platform_option_owned = function (self, offer)
	if offer.productIds.steam then
		return Promise.resolved({
			is_owner = Steam.is_subscribed(offer.productIds.steam.productId),
		})
	end

	return Promise.resolved({
		is_owner = false,
	})
end

ExternalPaymentPlatformSteam._offer_id_from_option = function (self, option)
	local option_data = option.steam or option.productIds.steam

	return option_data and option_data.productId
end

ExternalPaymentPlatformSteam._get_entitlements = function (self)
	return Promise.resolved({
		success = true,
	})
end

return ExternalPaymentPlatformSteam
