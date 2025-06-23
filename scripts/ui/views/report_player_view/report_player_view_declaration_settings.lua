-- chunkname: @scripts/ui/views/report_player_view/report_player_view_declaration_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local view_settings = {
	close_on_hotkey_pressed = true,
	state_bound = true,
	path = "scripts/ui/views/report_player_view/report_player_view",
	package = "packages/ui/views/report_player_view/report_player_view",
	class = "ReportPlayerView",
	disable_game_world = false,
	load_in_hub = true,
	game_world_blur = 1.1,
	enter_sound_events = {
		UISoundEvents.default_menu_enter
	},
	exit_sound_events = {
		UISoundEvents.default_menu_exit
	}
}

return settings("ReportPlayerViewDeclarationSettings", view_settings)
