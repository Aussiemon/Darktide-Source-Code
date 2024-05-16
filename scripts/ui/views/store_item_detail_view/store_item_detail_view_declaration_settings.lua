-- chunkname: @scripts/ui/views/store_item_detail_view/store_item_detail_view_declaration_settings.lua

local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "StoreItemDetailView",
	disable_game_world = true,
	display_name = "loc_inventory_background_view_display_name",
	killswitch = "show_premium_store",
	killswitch_unavailable_description = "loc_popup_unavailable_view_premium_store_description",
	killswitch_unavailable_header = "loc_popup_unavailable_view_premium_store_header",
	load_in_hub = true,
	package = "packages/ui/views/store_item_detail_view/store_item_detail_view",
	path = "scripts/ui/views/store_item_detail_view/store_item_detail_view",
	state_bound = true,
	use_transition_ui = true,
	levels = {
		"content/levels/ui/vendor_cosmetics_preview_gear/vendor_cosmetics_preview_gear",
	},
	testify_flags = {
		ui_views = false,
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.credit_store_menu,
	},
}

return settings("StoreItemDetailViewDeclarationSettings", view_settings)
