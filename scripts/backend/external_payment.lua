local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local ExternalPayment = class("ExternalPayment")

local function is_steam()
	local authenticate_method = Managers.backend:get_auth_method()

	return authenticate_method == Managers.backend.AUTH_METHOD_STEAM and HAS_STEAM
end

local function is_xbox_live()
	local authenticate_method = Managers.backend:get_auth_method()

	return authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and XboxLive
end

local function get_payment_platform()
	if is_steam() then
		return "steam"
	elseif is_xbox_live() then
		return "xbox"
	else
		return nil
	end
end

local function get_entitlements()
	local async_job, error_code = XboxLive.query_associated_products_async({
		"consumable",
		"unmanaged"
	})

	if not async_job then
		return Promise.rejected({
			message = string.format("query_associated_products_async returned error_code=0x%x", error_code)
		})
	end

	return Promise.until_value_is_true(function ()
		local result, async_job, error_code = XboxLive.query_associated_products_async_result(async_job)

		if error_code then
			Log.error("ExternalPayment", string.format("Failed to fetch associated products, error_code=0x%x", error_code))

			return {
				success = false,
				code = error_code
			}
		end

		if result ~= nil and error_code == nil then
			local result_by_id = {}

			for _, v in ipairs(result) do
				result_by_id[v.storeId] = v
			end

			return {
				success = true,
				data = result_by_id
			}
		end

		return false
	end)
end

local function get_platform_token()
	if is_xbox_live() then
		local async_block, error_code = XUser.get_xbs_token_async(Managers.account:user_id())

		if error_code then
			return Promise.rejected({
				message = string.format("get_xbs_token_async returned error_code=0x%x", error_code)
			})
		end

		return Promise.until_value_is_true(function ()
			local token, error_code = XUser.get_xbs_token_async_result(async_block)

			if token then
				return token
			end

			if error_code then
				return nil, string.format("get_xbs_token_async_result returned error_code=0x%x", error_code)
			end
		end)
	else
		return Promise.resolved(nil)
	end
end

local function show_xbox_purchase_ui(product_id)
	local async_job, error_code = XboxLive.show_purchase_ui_async(product_id)

	if not async_job then
		return Promise.rejected({
			message = string.format("show_purchase_ui_async returned error_code=0x%x", error_code)
		})
	end

	return Promise.until_value_is_true(function ()
		local result = XboxLive.show_purchase_ui_async_result(async_job)

		if result == nil then
			return false
		end

		if result == 0 then
			return {
				success = true
			}
		else
			return {
				success = false
			}
		end
	end)
end

ExternalPayment.payment_options = function (self)
	local language = "en"

	if is_steam() then
		language = Steam.language()
	end

	local builder = BackendUtilities.url_builder():path("/store/payment-options"):query("language", language)

	return Managers.backend:title_request(builder:to_string()):next(function (response)
		return response.body
	end)
end

ExternalPayment.reconcile_pending_txns = function (self)
	return get_platform_token():next(function (token)
		return Managers.backend:authenticate():next(function (account)
			local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments/reconcile"):query("platform", get_payment_platform())

			return Managers.backend:title_request(builder:to_string(), {
				method = "POST",
				headers = {
					["platform-token"] = token
				}
			}):next(function (response)
				return response.body
			end)
		end)
	end)
end

ExternalPayment.init_txn = function (self, payment_option)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments"):query("platform", get_payment_platform())

		return Managers.backend:title_request(builder:to_string(), {
			method = "POST",
			body = {
				paymentOptionId = payment_option
			}
		}):next(function (response)
			return response.body.orderId
		end)
	end)
end

ExternalPayment.finalize_txn = function (self, order_id)
	return get_platform_token():next(function (token)
		return Managers.backend:authenticate():next(function (account)
			local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments/"):path(order_id):query("platform", get_payment_platform())

			return Managers.backend:title_request(builder:to_string(), {
				method = "POST",
				body = {
					placeholder = ""
				},
				headers = {
					["platform-token"] = token
				}
			}):next(function (response)
				return response.body.data
			end)
		end)
	end)
end

ExternalPayment.fail_txn = function (self, order_id)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/store/"):path(account.sub):path("/payments/"):path(order_id):query("platform", get_payment_platform())

		return Managers.backend:title_request(builder:to_string(), {
			method = "DELETE"
		}):catch(function (error)
			Log.error("ExternalPayment", "Failed to remove pending transaction %s", tostring(error))
		end)
	end)
end

ExternalPayment._decorate_option = function (self, option, platform_entitlements)
	option.description = {
		type = "currency",
		description = option.value.amount .. " " .. option.value.type
	}
	option.price = {
		amount = {}
	}

	if is_steam() then
		option.price.amount.amount = option.steam.priceCents / 100
		option.price.amount.type = option.steam.currency
	elseif is_xbox_live() then
		local offer_id = option.microsoft and option.microsoft.productId
		local offer = platform_entitlements[offer_id]

		if offer then
			option.description.description = offer.title
			option.price.amount.formattedPrice = offer.formattedPrice.formattedPrice
		else
			option.description.description = "??"
			option.price.amount.formattedPrice = "??"
		end
	else
		Log.error("ExternalPayment", "Failed finding appropriate price for %s", PLATFORM)

		option.price.amount.formattedPrice = "??"
	end

	option._on_micro_txn = function (self, authorized, order_id)
		fassert(self.pending_txn_promise, "txn promise unexpectedly not set for order_id %s", order_id)

		if authorized then
			Managers.backend.interfaces.external_payment:finalize_txn(order_id):next(function (data)
				self.pending_txn_promise:resolve(data)

				self.pending_txn_promise = nil

				return data
			end)
		else
			Managers.backend.interfaces.external_payment:fail_txn(order_id):next(function (data)
				self.pending_txn_promise:resolve(data)

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
			return Promise:rejected({
				message = "Called init transaction when a transaction was already pending"
			})
		end

		self.pending_txn_promise = Promise:new()

		Managers.backend.interfaces.external_payment:init_txn(self.id):next(function (order_id)
			if is_steam() then
				Managers.steam:register_micro_txn_callback(order_id, callback(self, "_on_micro_txn"))
			elseif is_xbox_live() then
				local microsoft_product_id = self.microsoft and self.microsoft.productId

				if microsoft_product_id then
					return show_xbox_purchase_ui(microsoft_product_id):next(function (status)
						if status.success then
							return Managers.backend.interfaces.external_payment:finalize_txn(order_id)
						else
							return Managers.backend.interfaces.external_payment:fail_txn(order_id)
						end
					end)
				else
					Log.error("ExternalPayment", "Attempted to make purchase on xbox but microsoft product id was missing")
				end
			end
		end)

		return self.pending_txn_promise
	end
end

ExternalPayment.get_options = function (self)
	local entitlement_promise = nil

	if is_xbox_live() then
		entitlement_promise = get_entitlements()
	else
		entitlement_promise = Promise.resolved(nil)
	end

	return entitlement_promise:next(function (platform_entitlements)
		return self:payment_options():next(function (body)
			local options = body.options

			for _, v in ipairs(options) do
				self:_decorate_option(v, platform_entitlements and platform_entitlements.data or {})
			end

			local result = {
				offers = options
			}

			if body._links.layout then
				return Managers.backend:title_request(body._links.layout.href):next(function (data)
					data.body._links = nil
					result.layout_config = {
						layout = data.body
					}

					return result
				end)
			else
				return result
			end
		end)
	end)
end

return ExternalPayment
