-- chunkname: @scripts/backend/platform/external_payment_platform_base.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local ExternalPaymentPlatformInterface = require("scripts/backend/platform/external_payment_platform_interface")
local Promise = require("scripts/foundation/utilities/promise")
local ExternalPaymentPlatformBase = class("ExternalPaymentPlatformBase")

ExternalPaymentPlatformBase.get_platform_token = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.get_payment_platform = function (self)
	return "none"
end

ExternalPaymentPlatformBase.payment_options = function (self)
	local language = "en"
	local builder = BackendUtilities.url_builder():path("/store/payment-options"):query("language", language)

	return Managers.backend:title_request(builder:to_string()):next(function (response)
		return response.body
	end)
end

ExternalPaymentPlatformBase.update_account_store_status = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.reconcile_pending_txns = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.reconcile_account_entitlements = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.reconcile_dlc = function (self, store_ids)
	return self:get_platform_token():next(function (token)
		return Managers.backend:authenticate():next(function (account)
			local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/dlc/reconcile"):query("platform", self:get_payment_platform())

			return Managers.backend:title_request(builder:to_string(), {
				method = "POST",
				headers = {
					["platform-token"] = token,
				},
				body = {
					productIds = store_ids,
				},
			}):next(function (response)
				return response.body
			end):catch(function (error)
				Log.error("ExternalPayment", "Failed to reconcile dlc", tostring(error))

				return Promise.rejected({
					error = error,
				})
			end)
		end)
	end)
end

ExternalPaymentPlatformBase.get_options = function (self)
	return self:_get_entitlements():next(function (platform_entitlements)
		if platform_entitlements.success == false then
			return Promise.rejected({
				error = "empty_store",
			})
		end

		return Promise.all(self:payment_options()):next(function (results)
			local payment_body = results[1]
			local options = payment_body.options
			local entitlement_data = platform_entitlements and platform_entitlements.data or {}

			for _, v in ipairs(options) do
				self:_decorate_option(v, entitlement_data)
			end

			local result = {
				offers = options,
			}

			if payment_body._links.layout then
				return Managers.backend:title_request(payment_body._links.layout.href):next(function (data)
					data.body._links = nil
					result.layout_config = {
						layout = data.body,
					}

					return result
				end)
			else
				return result
			end
		end)
	end)
end

ExternalPaymentPlatformBase._get_entitlements = function (self)
	return Promise.resolved({
		success = false,
		data = {},
	})
end

ExternalPaymentPlatformBase.init_txn = function (self, payment_option)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.finalize_txn = function (self, order_id)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.fail_txn = function (self, order_id)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.show_empty_store_error = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.query_license_token = function (self, product_ids, signature_string)
	return Promise.resolved(nil)
end

implements(ExternalPaymentPlatformBase, ExternalPaymentPlatformInterface)

return ExternalPaymentPlatformBase
