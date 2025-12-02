-- chunkname: @scripts/backend/platform/external_payment_platform_interface.lua

local ExternalPaymentPlatformInterface = {
	"get_platform_token",
	"get_payment_platform",
	"payment_options",
	"update_account_store_status",
	"reconcile_pending_txns",
	"reconcile_account_entitlements",
	"reconcile_dlc",
	"get_options",
	"init_txn",
	"finalize_txn",
	"fail_txn",
	"show_empty_store_error",
	"query_license_token",
	"invalidate_cache",
}

return ExternalPaymentPlatformInterface
