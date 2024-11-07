-- chunkname: @scripts/backend/platform/external_payment_platform_interface.lua

local ExternalPaymentPlatformInterface = {
	"payment_options",
	"update_account_store_status",
	"reconcile_pending_txns",
	"reconcile_dlc",
	"get_options",
	"init_txn",
	"finalize_txn",
	"fail_txn",
	"show_empty_store_error",
}

return ExternalPaymentPlatformInterface
