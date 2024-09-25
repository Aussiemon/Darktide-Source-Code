-- chunkname: @scripts/ui/views/crafting_view/crafting_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "CraftingView",
	disable_game_world = true,
	display_name = "loc_crafting_view_display_name",
	killswitch = "show_crafting",
	killswitch_unavailable_description = "loc_popup_unavailable_view_crafting_description",
	killswitch_unavailable_header = "loc_popup_unavailable_view_crafting_header",
	load_in_hub = true,
	package = "packages/ui/views/crafting_view/crafting_view",
	path = "scripts/ui/views/crafting_view/crafting_view",
	state_bound = true,
	use_transition_ui = true,
	levels = {
		"content/levels/ui/crafting_view_itemization/crafting_view_itemization",
	},
	enter_sound_events = {
		UISoundEvents.crafting_view_on_enter,
	},
	exit_sound_events = {
		UISoundEvents.crafting_view_on_exit,
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
	},
}

return settings("CraftingViewDeclarationSettings", view_settings)
