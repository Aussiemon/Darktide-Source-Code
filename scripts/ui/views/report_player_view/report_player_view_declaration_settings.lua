-- chunkname: @scripts/ui/views/report_player_view/report_player_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local view_settings = {
	class = "ReportPlayerView",
	close_on_hotkey_pressed = true,
	disable_game_world = false,
	game_world_blur = 1.1,
	package = "packages/ui/views/report_player_view/report_player_view",
	path = "scripts/ui/views/report_player_view/report_player_view",
	preload_in_hub = "not_ps5_nor_lockhart",
	state_bound = true,
	enter_sound_events = {
		UISoundEvents.default_menu_enter,
	},
	exit_sound_events = {
		UISoundEvents.default_menu_exit,
	},
}

return settings("ReportPlayerViewDeclarationSettings", view_settings)
