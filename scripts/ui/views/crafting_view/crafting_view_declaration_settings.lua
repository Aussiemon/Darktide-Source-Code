local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	load_in_hub = true,
	state_bound = true,
	display_name = "loc_crafting_view_display_name",
	use_transition_ui = true,
	killswitch_unavailable_header = "loc_popup_unavailable_view_crafting_header",
	killswitch_unavailable_description = "loc_popup_unavailable_view_crafting_description",
	path = "scripts/ui/views/crafting_view/crafting_view",
	package = "packages/ui/views/crafting_view/crafting_view",
	killswitch = "show_crafting",
	class = "CraftingView",
	disable_game_world = true,
	levels = {
		"content/levels/ui/crafting_view/crafting_view"
	},
	enter_sound_events = {
		UISoundEvents.crafting_view_on_enter
	},
	exit_sound_events = {
		UISoundEvents.crafting_view_on_exit
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu
	}
}

return settings("CraftingViewDeclarationSettings", view_settings)
