-- chunkname: @scripts/ui/views/expedition_background_view/expedition_background_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "ExpeditionBackgroundView",
	disable_game_world = true,
	package = "packages/ui/views/expedition_background_view/expedition_background_view",
	path = "scripts/ui/views/expedition_background_view/expedition_background_view",
	state_bound = true,
	use_transition_ui = true,
	levels = {
		"content/levels/ui/expedition/world",
	},
	enter_sound_events = {
		UISoundEvents.expedition_menu_enter,
	},
	exit_sound_events = {
		UISoundEvents.expedition_menu_exit,
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
	},
	testify_flags = {
		ui_views = false,
	},
}

return settings("ExpeditionBackgroundViewDeclarationSettings", view_settings)
