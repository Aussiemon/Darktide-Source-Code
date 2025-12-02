-- chunkname: @scripts/ui/views/premium_currency_purchase_view/premium_currency_purchase_view_settings.lua

local view_settings = {
	min_time_to_disply_timer = 86400,
	row_separation_height = 32,
	timer_name = "ui",
	wallet_sync_delay = 60,
}

return settings("PremiumCurrencyPurchaseViewSettings", view_settings)
