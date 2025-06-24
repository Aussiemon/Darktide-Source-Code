-- chunkname: @scripts/backend/platform/external_payment_platform_base.lua

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
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.update_account_store_status = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.reconcile_pending_txns = function (self)
	return Promise.resolved(nil)
end

ExternalPaymentPlatformBase.reconcile_dlc = function (self, store_ids)
	return Promise.rejected({})
end

ExternalPaymentPlatformBase.get_options = function (self)
	return Promise.resolved(nil)
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
