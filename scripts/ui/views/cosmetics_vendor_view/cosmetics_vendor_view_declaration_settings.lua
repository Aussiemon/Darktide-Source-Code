﻿-- chunkname: @scripts/ui/views/cosmetics_vendor_view/cosmetics_vendor_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	state_bound = true,
	display_name = "loc_cosmetics_vendor_view_display_name",
	use_transition_ui = true,
	killswitch_unavailable_header = "loc_popup_unavailable_view_crafting_header",
	killswitch_unavailable_description = "loc_popup_unavailable_view_crafting_description",
	path = "scripts/ui/views/cosmetics_vendor_view/cosmetics_vendor_view",
	package = "packages/ui/views/cosmetics_vendor_view/cosmetics_vendor_view",
	killswitch = "show_crafting",
	class = "CosmeticsVendorView",
	disable_game_world = true,
	load_in_hub = true,
	levels = {
		"content/levels/ui/vendor_cosmetics_preview_gear/vendor_cosmetics_preview_gear",
		"content/levels/ui/vendor_cosmetics_preview_weapon/vendor_cosmetics_preview_weapon"
	},
	enter_sound_events = {
		UISoundEvents.default_menu_enter
	},
	exit_sound_events = {
		UISoundEvents.default_menu_exit
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu
	}
}

return settings("CosmeticsVendorViewDeclarationSettings", view_settings)
