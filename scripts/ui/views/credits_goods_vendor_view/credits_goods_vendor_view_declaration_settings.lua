-- chunkname: @scripts/ui/views/credits_goods_vendor_view/credits_goods_vendor_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "CreditsGoodsVendorView",
	disable_game_world = true,
	killswitch = "show_contracts",
	killswitch_unavailable_description = "loc_popup_unavailable_view_credits_store_description",
	killswitch_unavailable_header = "loc_popup_unavailable_view_credits_store_header",
	load_in_hub = true,
	package = "packages/ui/views/credits_goods_vendor_view/credits_goods_vendor_view",
	path = "scripts/ui/views/credits_goods_vendor_view/credits_goods_vendor_view",
	state_bound = true,
	use_transition_ui = false,
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
	},
	dummy_data = {
		debug = true,
	},
	enter_sound_events = {
		UISoundEvents.default_menu_enter,
	},
	exit_sound_events = {
		UISoundEvents.default_menu_exit,
	},
}

return settings("CreditsGoodsVendorViewDeclarationSettings", view_settings)
