-- chunkname: @scripts/backend/platform/external_payment_platform_xbox.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local XboxLiveUtils = require("scripts/foundation/utilities/xbox_live_utils")
local ExternalPaymentPlatformXbox = class("ExternalPaymentPlatformXbox", "ExternalPaymentPlatformBase")

local function _handle_error(error_data)
	if error_data.error_handled then
		return Promise.rejected(error_data)
	end

	local header = error_data.header and error_data.header .. ": " or ""

	if error_data.message then
		Log.error("ExternalPayment", header .. "%s", error_data.message)
	elseif error_data.error_code then
		Log.error("ExternalPayment", header .. "0x%x", tostring(error_data.error_code))
	else
		Log.error("ExternalPayment", header .. "%s", table.tostring(error_data))
	end

	error_data.error_handled = true

	return Promise.rejected(error_data)
end

ExternalPaymentPlatformXbox.get_payment_platform = function (self)
	return "xbox"
end

ExternalPaymentPlatformXbox.get_platform_token = function (self)
	local user_id = Managers.account:user_id()

	if user_id then
		local async_block, error_code = XUser.get_xbs_token_async(user_id)

		if error_code then
			return Promise.rejected({
				message = string.format("get_xbs_token_async returned error_code=0x%x", error_code),
			})
		end

		return Managers.xasync:wrap(async_block):next(function (async_block)
			local token, error_code = XUser.get_xbs_token_async_result(async_block)

			if token then
				return token
			end

			if error_code then
				return nil, string.format("get_xbs_token_async_result returned error_code=0x%x", error_code)
			end
		end):catch(_handle_error)
	else
		return Promise.rejected({
			message = string.format("get_xbs_token_async rejecte with invalid user id"),
		})
	end
end

local function get_purchase_id(access_token)
	local async_block, error_code = XboxLive.get_purchase_id_async(access_token)

	if error_code then
		return Promise.rejected({
			message = string.format("get_purchase_id_async returned error_code=0x%x", error_code),
		})
	end

	return Managers.xasync:wrap(async_block):next(function (async_block)
		local id, error_code = XboxLive.get_purchase_id_result(async_block)

		if id then
			return id
		end

		if error_code then
			local errorStr = string.format("0x%x", error_code)

			Log.error("ExternalPayment", "get_purchase_id_result failed with code: %s", errorStr)

			return nil, {
				message = string.format("get_purchase_id_result returned error_code=%s", errorStr),
			}
		end
	end):catch(_handle_error)
end

local function get_collections_id(access_token)
	local async_block, error_code = XboxLive.get_user_collection_id_async(access_token)

	if error_code then
		return Promise.rejected({
			message = string.format("get_user_collection_id_async returned error_code=0x%x", error_code),
		})
	end

	return Managers.xasync:wrap(async_block):next(function (async_block)
		local id, error_code = XboxLive.get_user_collection_id_result(async_block)

		if id then
			return id
		end

		if error_code then
			local errorStr = string.format("0x%x", error_code)

			Log.error("ExternalPayment", "get_user_collection_id_result failed with code: %s", errorStr)

			return nil, {
				message = string.format("get_user_collection_id_result returned error_code=%s", errorStr),
			}
		end
	end):catch(_handle_error)
end

local function show_xbox_purchase_ui(product_id)
	local async_job, error_code = XboxLive.show_purchase_ui_async(product_id)

	if not async_job then
		return Promise.rejected({
			message = string.format("show_purchase_ui_async returned error_code=0x%x", error_code),
		})
	end

	return Promise.until_value_is_true(function ()
		local result = XboxLive.show_purchase_ui_async_result(async_job)

		if result == nil then
			return false
		end

		if result == 0 then
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

local function get_account_status(platform, account_id)
	local builder = BackendUtilities.url_builder():path("/store/"):path(account_id):path("/status"):query("platform", platform)

	return Managers.backend:title_request(builder:to_string()):next(function (response)
		return response.body
	end)
end

local function update_user_id(user_id_type, account_id)
	return Managers.backend:title_request(BackendUtilities.url_builder():path("/store/"):path(account_id):path("/xbox/token/accessToken"):query("type", user_id_type):to_string()):next(function (response)
		local access_token = response.body.token

		if user_id_type == "collectionId" then
			return get_collections_id(access_token)
		elseif user_id_type == "purchaseId" then
			return get_purchase_id(access_token)
		end
	end):next(function (user_id)
		return Managers.backend:title_request(BackendUtilities.url_builder():path("/store/"):path(account_id):path("/xbox/token/"):path(user_id_type):to_string(), {
			method = "PUT",
			body = {
				token = user_id,
			},
		})
	end)
end

ExternalPaymentPlatformXbox.update_account_store_status = function (self)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub

		return get_account_status("xbox", account_id):next(function (account_status)
			local has_collection_id = account_status and account_status.xbox and account_status.xbox.userIds and account_status.xbox.userIds.userCollectionId
			local has_purchase_id = account_status and account_status.xbox and account_status.xbox.userIds and account_status.xbox.userIds.userPurchaseId
			local promises = {}

			if not has_collection_id then
				table.insert(promises, update_user_id("collectionId", account_id))
			end

			if not has_purchase_id then
				table.insert(promises, update_user_id("purchaseId", account_id))
			end

			return Promise.all(unpack(promises))
		end)
	end)
end

ExternalPaymentPlatformXbox.reconcile_pending_txns = function (self)
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

ExternalPaymentPlatformXbox.reconcile_account_entitlements = function (self)
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

ExternalPaymentPlatformXbox.init_txn = function (self, payment_option)
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

ExternalPaymentPlatformXbox.finalize_txn = function (self, order_id)
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

ExternalPaymentPlatformXbox.fail_txn = function (self, order_id)
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

ExternalPaymentPlatformXbox._decorate_option = function (self, option, platform_entitlements)
	option.description = {
		type = "currency",
		description = option.value.amount .. " " .. option.value.type,
	}
	option.price = {
		amount = {},
	}

	local offer_id = option.microsoft and option.microsoft.productId
	local offer = platform_entitlements[offer_id]
	local is_store_managed_consumable = offer and table.array_contains(offer.productKind, "consumable")

	if is_store_managed_consumable then
		option.description.title = offer.title
		option.price.amount.formattedPrice = offer.formattedPrice.formattedPrice
	else
		option.description.description = "??"
		option.price.amount.formattedPrice = "??"
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
			local success = Managers.account:verify_gdk_store_account()

			if not success then
				return Promise.rejected({
					message = "Could not verify store profile match",
				})
			end

			local microsoft_product_id = self.microsoft and self.microsoft.productId

			if microsoft_product_id then
				return show_xbox_purchase_ui(microsoft_product_id):next(function (status)
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
						return Managers.backend.interfaces.external_payment:fail_txn(order_id):next(function (data)
							self.pending_txn_promise:resolve(data)

							self.pending_txn_promise = nil

							return data
						end):catch(function (data)
							self.pending_txn_promise:resolve(FAILED_TXN)

							self.pending_txn_promise = nil

							return data
						end)
					end
				end):catch(function (error)
					Log.warning("ExternalPayment", "Failed to open purchase ui with error: %s", table.tostring(error, 3))
					self.pending_txn_promise:resolve(FAILED_TXN)

					self.pending_txn_promise = nil
				end)
			else
				Log.error("ExternalPayment", "Attempted to make purchase on xbox but microsoft product id was missing")
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

ExternalPaymentPlatformXbox._get_entitlements = function (self)
	return XboxLiveUtils.get_associated_products()
end

ExternalPaymentPlatformXbox.query_license_token = function (self, product_ids, signature_string)
	local async_job, error_code = XStore.query_license_token_async(product_ids, signature_string)

	if not async_job then
		return Promise.rejected({
			error_code = error_code,
			message = string.format("query_license_token_async returned error_code=0x%x", error_code),
		})
	end

	return Promise.until_value_is_true(function ()
		local result, error_code = XStore.query_license_token_async_result(async_job)

		if result == nil and error_code == nil then
			return false
		end

		if error_code ~= nil then
			return false, {
				error_code = error_code,
				error = string.format("query_license_token_async_result returned error_code=0x%x", error_code),
			}
		end

		return result
	end)
end

return ExternalPaymentPlatformXbox
