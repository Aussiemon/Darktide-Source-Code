-- chunkname: @scripts/ui/views/store_view/store_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "StoreView",
	disable_game_world = true,
	display_name = "loc_store_view_display_name",
	killswitch = "show_premium_store",
	killswitch_unavailable_description = "loc_popup_unavailable_view_premium_store_description",
	killswitch_unavailable_header = "loc_popup_unavailable_view_premium_store_header",
	package = "packages/ui/views/store_view/store_view",
	path = "scripts/ui/views/store_view/store_view",
	preload_in_hub = "not_ps5",
	state_bound = true,
	use_transition_ui = true,
	levels = {
		"content/levels/ui/store/store",
	},
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

return settings("StoreViewDeclarationSettings", view_settings)
