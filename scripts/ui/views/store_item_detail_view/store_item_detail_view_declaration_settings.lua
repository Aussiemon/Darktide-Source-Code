local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	state_bound = true,
	display_name = "loc_inventory_background_view_display_name",
	use_transition_ui = true,
	killswitch_unavailable_header = "loc_popup_unavailable_view_premium_store_header",
	killswitch_unavailable_description = "loc_popup_unavailable_view_premium_store_description",
	path = "scripts/ui/views/store_item_detail_view/store_item_detail_view",
	package = "packages/ui/views/store_item_detail_view/store_item_detail_view",
	killswitch = "show_premium_store",
	class = "StoreItemDetailView",
	disable_game_world = true,
	load_in_hub = true,
	levels = {
		"content/levels/ui/vendor_cosmetics_preview_gear/vendor_cosmetics_preview_gear"
	},
	testify_flags = {
		ui_views = false
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.credit_store_menu
	}
}

return settings("StoreItemDetailViewDeclarationSettings", view_settings)
