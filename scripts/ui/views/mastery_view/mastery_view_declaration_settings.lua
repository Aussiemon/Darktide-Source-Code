-- chunkname: @scripts/ui/views/mastery_view/mastery_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "MasteryView",
	disable_game_world = false,
	package = "packages/ui/views/mastery_view/mastery_view",
	path = "scripts/ui/views/mastery_view/mastery_view",
	preload_in_hub = "not_ps5_nor_lockhart",
	state_bound = true,
	use_transition_ui = true,
	levels = {
		"content/levels/ui/cosmetics_preview/cosmetics_preview",
	},
	enter_sound_events = {
		UISoundEvents.default_menu_enter,
	},
	exit_sound_events = {
		UISoundEvents.default_menu_exit,
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
	},
	testify_flags = {
		ui_views = false,
	},
}

return settings("MasteryViewDeclarationSettings", view_settings)
