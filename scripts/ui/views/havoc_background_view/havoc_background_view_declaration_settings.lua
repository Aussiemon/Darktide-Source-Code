-- chunkname: @scripts/ui/views/havoc_background_view/havoc_background_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local view_settings = {
	class = "HavocBackgroundView",
	disable_game_world = false,
	package = "packages/ui/views/havoc_background_view/havoc_background_view",
	path = "scripts/ui/views/havoc_background_view/havoc_background_view",
	preload_in_hub = "always",
	state_bound = true,
	use_transition_ui = true,
	levels = {
		"content/levels/ui/havoc/havoc",
	},
	enter_sound_events = {
		UISoundEvents.havoc_terminal_enter,
	},
	exit_sound_events = {
		UISoundEvents.havoc_terminal_exit,
	},
	wwise_states = {
		options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
	},
}

return settings("HavocBackgroundViewDeclarationSettings", view_settings)
