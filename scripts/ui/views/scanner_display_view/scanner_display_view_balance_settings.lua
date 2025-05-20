-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_balance_settings.lua

local render_size = 1024
local board_size = render_size * 0.2
local background_size = 2.45 * board_size
local center_offset_x = 0
local center_offset_y = -render_size * 0.04
local scanner_display_view_balance_settings = {
	cursor_widget_size = {
		render_size * 0.09,
		render_size * 0.09,
	},
	center_offset_x = center_offset_x,
	center_offset_y = center_offset_y,
	board_width = board_size,
	board_height = board_size,
	background_size = {
		background_size,
		background_size,
	},
	background_position = {
		center_offset_x - background_size / 2,
		center_offset_y - background_size / 2,
		0,
	},
	progress_starting_offset_x = render_size * 0.24,
	progress_starting_offset_y = center_offset_y - render_size * 0.21,
	progress_widget_size = {
		render_size * 0.13,
		render_size * 0.4,
	},
}

return settings("ScannerDisplayViewBalanceSettings", scanner_display_view_balance_settings)
