-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_balance_settings.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local screen_ratio = UIWorkspaceSettings.screen.size[1] / UIWorkspaceSettings.screen.size[2]
local cursor_widget_size = 100
local board_size = 220
local background_size = 2.45 * board_size
local center_offset_x = 0
local center_offset_y = -40
local scanner_display_view_balance_settings = {
	cursor_widget_size = {
		screen_ratio * cursor_widget_size,
		cursor_widget_size,
	},
	center_offset_x = center_offset_x,
	center_offset_y = center_offset_y,
	board_width = board_size * screen_ratio,
	board_height = board_size,
	background_size = {
		background_size * screen_ratio,
		background_size,
	},
	background_position = {
		(center_offset_x - background_size / 2) * screen_ratio,
		center_offset_y - background_size / 2,
		0,
	},
	progress_starting_offset_x = 260 * screen_ratio,
	progress_starting_offset_y = center_offset_y - 225,
	progress_widget_size = {
		140 * screen_ratio,
		450,
	},
}

return settings("ScannerDisplayViewBalanceSettings", scanner_display_view_balance_settings)
