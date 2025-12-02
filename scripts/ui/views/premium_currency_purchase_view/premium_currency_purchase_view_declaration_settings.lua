-- chunkname: @scripts/ui/views/premium_currency_purchase_view/premium_currency_purchase_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "PremiumCurrencyPurchaseView",
	disable_game_world = true,
	display_name = "loc_premium_currency_view_name",
	killswitch = "show_premium_currency_store",
	killswitch_unavailable_description = "loc_popup_unavailable_view_premium_store_description",
	killswitch_unavailable_header = "loc_popup_unavailable_view_premium_store_header",
	package = "packages/ui/views/premium_currency_purchase_view/premium_currency_purchase_view",
	path = "scripts/ui/views/premium_currency_purchase_view/premium_currency_purchase_view",
	state_bound = false,
	use_transition_ui = false,
	enter_sound_events = {
		UISoundEvents.aquilas_vendor_on_enter,
	},
	exit_sound_events = {
		UISoundEvents.aquilas_vendor_on_exit,
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.credit_store_menu,
	},
}

return settings("PremiumCurrencyViewDeclarationSettings", view_settings)
