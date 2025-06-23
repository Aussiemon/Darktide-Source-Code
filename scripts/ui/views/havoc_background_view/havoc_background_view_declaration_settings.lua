-- chunkname: @scripts/ui/views/havoc_background_view/havoc_background_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	disable_game_world = false,
	state_bound = true,
	load_in_hub = true,
	use_transition_ui = true,
	path = "scripts/ui/views/havoc_background_view/havoc_background_view",
	package = "packages/ui/views/havoc_background_view/havoc_background_view",
	class = "HavocBackgroundView",
	levels = {
		"content/levels/ui/havoc/havoc"
	},
	enter_sound_events = {
		UISoundEvents.havoc_terminal_enter
	},
	exit_sound_events = {
		UISoundEvents.havoc_terminal_exit
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu
	},
	testify_flags = {
		ui_views = false
	}
}

return settings("HavocBackgroundViewDeclarationSettings", view_settings)
