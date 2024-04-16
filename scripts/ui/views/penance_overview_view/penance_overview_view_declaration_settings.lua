local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	load_in_hub = true,
	state_bound = true,
	disable_game_world = true,
	use_transition_ui = true,
	path = "scripts/ui/views/penance_overview_view/penance_overview_view",
	package = "packages/ui/views/penance_overview_view/penance_overview_view",
	class = "PenanceOverviewView",
	game_world_blur = 1.1,
	levels = {
		"content/levels/ui/penances/world"
	},
	enter_sound_events = {
		UISoundEvents.penance_menu_enter
	},
	exit_sound_events = {
		UISoundEvents.penance_menu_exit
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu
	},
	testify_flags = {
		ui_views = true
	}
}

return settings("PenanceOverviewViewDeclarationSettings", view_settings)
