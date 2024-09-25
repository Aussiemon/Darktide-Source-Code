-- chunkname: @scripts/backend/platform/external_payment_platform_playstation.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local ExternalPaymentPlatformBase = require("scripts/backend/platform/external_payment_platform_base")
local Promise = require("scripts/foundation/utilities/promise")
local ExternalPaymentPlatformPlaystation = class("ExternalPaymentPlatformPlaystation", "ExternalPaymentPlatformBase")

ExternalPaymentPlatformPlaystation._get_payment_platform = function (self)
	return "psn"
end

ExternalPaymentPlatformPlaystation._get_platform_token = function (self)
	local request_id

	return Promise.until_value_is_true(function ()
		if not request_id then
			request_id = Playstation.request_auth_code()

			return false
		end

		local result, err = Playstation.get_auth_code_results(request_id)

		if err then
			Log.error("ExternalPayment", "get_auth_code_results() " .. "%s", err)

			return err
		end

		if result then
			return result.authorization_code
		end

		return false
	end)
end

local function _show_commerce_dialogue(product_id)
	return Promise.until_value_is_true(function ()
		local status = NpCommerceDialog.update()

		if status == NpCommerceDialog.NONE then
			NpCommerceDialog.initialize()

			return false
		end

		if status == NpCommerceDialog.INITIALIZED then
			NpCommerceDialog.open2(NpCommerceDialog.MODE_PRODUCT, PS5.initial_user_id(), product_id)

			return false
		end

		if status == NpCommerceDialog.RUNNING then
			return false
		end

		local result, authorized = NpCommerceDialog.result()

		NpCommerceDialog.terminate()

		if result == NpCommerceDialog.RESULT_PURCHASED then
			return {
				success = true,
			}
		else
			return {
				success = false,
			}
		end
	end)
end

ExternalPaymentPlatformPlaystation.update_account_store_status = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformPlaystation.payment_options = function (self)
	local language = "en"
	local builder = BackendUtilities.url_builder():path("/store/payment-options"):query("language", language)

	return Managers.backend:title_request(builder:to_string()):next(function (response)
		return response.body
	end)
end

ExternalPaymentPlatformPlaystation.reconcile_pending_txns = function (self)
	return self:_get_platform_token():next(function (token)
		return Managers.backend:authenticate():next(function (account)
			local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments/reconcile"):query("platform", self:_get_payment_platform())

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

ExternalPaymentPlatformPlaystation.reconcile_dlc = function (self, store_ids)
	return self:_get_platform_token():next(function (token)
		return Managers.backend:authenticate():next(function (account)
			local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/dlc/reconcile"):query("platform", self:_get_payment_platform())

			return Managers.backend:title_request(builder:to_string(), {
				method = "POST",
				headers = {
					["platform-token"] = token,
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

ExternalPaymentPlatformPlaystation.init_txn_tmp = function (self, payment_option)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformPlaystation.init_txn = function (self, payment_option)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments"):query("platform", self:_get_payment_platform())

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

ExternalPaymentPlatformPlaystation.finalize_txn = function (self, order_id)
	return self:_get_platform_token():next(function (token)
		return Managers.backend:authenticate():next(function (account)
			local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments/"):path(order_id):query("platform", self:_get_payment_platform())

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

ExternalPaymentPlatformPlaystation.fail_txn = function (self, order_id)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments/"):path(order_id):query("platform", self:_get_payment_platform())

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

ExternalPaymentPlatformPlaystation._get_entitlements = function (self)
	if self._platform_entitlements then
		return Promise.resolved({
			success = true,
			data = self._platform_entitlements,
		})
	end

	local web_api = WebApi
	local user_id = PS5.initial_user_id()
	local api_group = "inGameCatalog"
	local path = string.format("/v5/container?serviceLabel=%s&containerIds=%s", 0, "DTVCAQUILAS")
	local method = WebApi.GET
	local content
	local id = web_api.send_request(user_id, api_group, path, method, content)

	return Promise.until_value_is_true(function ()
		local status = web_api.status(id)

		if status == web_api.COMPLETED then
			local response = web_api.request_result(id, web_api.STRING)
			local parsed = cjson.decode(response)
			local result_by_id = {}

			for i, v in ipairs(parsed[1].children) do
				local product = {}

				product.displayPrice = v.skus[1].displayPrice
				result_by_id[v.label] = product
			end

			self._platform_entitlements = result_by_id

			return {
				success = true,
				data = self._platform_entitlements,
			}
		elseif status == web_api.ERROR then
			return {
				success = false,
			}
		end

		return false
	end)
end

ExternalPaymentPlatformPlaystation._decorate_option = function (self, option, platform_entitlements)
	option.description = {
		type = "currency",
		description = option.value.amount .. " " .. option.value.type,
	}
	option.price = {
		amount = {},
	}

	local offer_id = option.psn and option.psn.productId
	local offer = platform_entitlements[offer_id]

	if offer then
		option.price.amount.formattedPrice = offer.displayPrice
	end

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
			local product_id = self.psn and self.psn.productId

			if product_id then
				_show_commerce_dialogue(product_id):next(function (status)
					if status.success then
						return Managers.backend.interfaces.external_payment:finalize_txn(order_id):next(function (data)
							self.pending_txn_promise:resolve(data)

							self.pending_txn_promise = nil

							return data
						end):catch(function (data)
							self.pending_txn_promise:resolve(FAILED_TXN)

							self.pending_txn_promise = nil

							return data
						end)
					else
						self.pending_txn_promise:resolve(FAILED_TXN)

						self.pending_txn_promise = nil
					end
				end)
			else
				Log.error("ExternalPayment", "Attempted to make purchase on psn but psn product id was missing")
				self.pending_txn_promise:resolve(FAILED_TXN)

				self.pending_txn_promise = nil
			end
		end):catch(function (_)
			self.pending_txn_promise:resolve(FAILED_TXN)

			self.pending_txn_promise = nil
		end)

		return pending_txn_promise
	end
end

ExternalPaymentPlatformPlaystation.get_options = function (self)
	local entitlement_promise

	entitlement_promise = self:_get_entitlements()

	return entitlement_promise:next(function (platform_entitlements)
		return self:payment_options():next(function (body)
			local options = body.options

			for _, v in ipairs(options) do
				self:_decorate_option(v, platform_entitlements and platform_entitlements.data or {})
			end

			local result = {
				offers = options,
			}

			if body._links.layout then
				return Managers.backend:title_request(body._links.layout.href):next(function (data)
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

return ExternalPaymentPlatformPlaystation
