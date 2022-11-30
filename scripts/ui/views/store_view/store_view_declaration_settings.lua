local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	display_name = "loc_store_view_display_name",
	state_bound = true,
	use_transition_ui = true,
	killswitch_unavailable_header = "loc_popup_unavailable_view_premium_store_header",
	killswitch_unavailable_description = "loc_popup_unavailable_view_premium_store_description",
	path = "scripts/ui/views/store_view/store_view",
	package = "packages/ui/views/store_view/store_view",
	killswitch = "show_premium_store",
	class = "StoreView",
	disable_game_world = true,
	load_in_hub = true,
	levels = {
		"content/levels/ui/store/store"
	},
	enter_sound_events = {
		UISoundEvents.aquilas_vendor_on_enter
	},
	exit_sound_events = {
		UISoundEvents.aquilas_vendor_on_exit
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.credit_store_menu
	},
	testify_flags = {
		ui_views = false
	}
}

return settings("StoreViewDeclarationSettings", view_settings)
