-- chunkname: @scripts/ui/views/expedition_view/expedition_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "ExpeditionView",
	disable_game_world = false,
	package = "packages/ui/views/expedition_view/expedition_view",
	path = "scripts/ui/views/expedition_view/expedition_view",
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
		music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.mission_board,
		options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
	},
	testify_flags = {
		ui_views = true,
	},
}

return settings("ExpeditionViewDeclarationSettings", view_settings)
