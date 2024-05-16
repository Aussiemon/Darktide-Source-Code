-- chunkname: @scripts/ui/views/cosmetics_vendor_background_view/cosmetics_vendor_background_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "CosmeticsVendorBackgroundView",
	disable_game_world = true,
	display_name = "loc_cosmetics_vendor_background_view_display_name",
	load_in_hub = true,
	package = "packages/ui/views/cosmetics_vendor_background_view/cosmetics_vendor_background_view",
	path = "scripts/ui/views/cosmetics_vendor_background_view/cosmetics_vendor_background_view",
	state_bound = true,
	use_transition_ui = true,
	levels = {
		"content/levels/ui/credits_cosmetics_vendor/credits_cosmetics_vendor",
	},
	enter_sound_events = {
		UISoundEvents.cosmetics_vendor_on_enter,
	},
	exit_sound_events = {
		UISoundEvents.cosmetics_vendor_on_exit,
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
	},
}

return settings("CosmeticsVendorBackgroundViewDeclarationSettings", view_settings)
