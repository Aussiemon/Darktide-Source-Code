-- chunkname: @scripts/ui/views/penance_overview_view/penance_overview_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "PenanceOverviewView",
	disable_game_world = true,
	game_world_blur = 1.1,
	load_in_hub = true,
	package = "packages/ui/views/penance_overview_view/penance_overview_view",
	path = "scripts/ui/views/penance_overview_view/penance_overview_view",
	state_bound = true,
	use_transition_ui = true,
	levels = {
		"content/levels/ui/penances/world",
	},
	enter_sound_events = {
		UISoundEvents.penance_menu_enter,
	},
	exit_sound_events = {
		UISoundEvents.penance_menu_exit,
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
	},
	testify_flags = {
		ui_views = false,
	},
}

return settings("PenanceOverviewViewDeclarationSettings", view_settings)
