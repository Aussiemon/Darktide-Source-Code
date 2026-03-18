-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_decode_search_settings.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local render_size = 1024
local board_width = MinigameSettings.decode_search_board_width
local board_height = MinigameSettings.decode_search_board_height
local symbols_spacing = 1
local symbols_widget_size = {
	render_size * 0.08,
	render_size * 0.08,
}
local scanner_display_view_decode_search_settings = {
	symbol_spacing = symbols_spacing,
	symbol_widget_size = symbols_widget_size,
	cursor_widget_offset = {
		-render_size * 0.005,
		-render_size * 0.005,
	},
	cursor_widget_size = {
		symbols_widget_size[1] * 2 + render_size * 0.01,
		symbols_widget_size[2] * 2 + render_size * 0.01,
	},
	symbol_starting_offset_x = -(symbols_widget_size[1] * board_width + symbols_spacing * (board_width - 1)) * 0.5,
	symbol_starting_offset_y = -(symbols_widget_size[2] * board_height + symbols_spacing * (board_height - 1)) * 0.5,
	target_starting_offset_x = -render_size * 0.28 - symbols_widget_size[1] * 2,
	target_starting_offset_y = -symbols_widget_size[2] / 2,
	stage_widget_size = {
		render_size * 0.08,
		render_size * 0.08,
	},
	stages_starting_offset_x = render_size * 0.1,
	stages_starting_offset_y = render_size * 0.25,
	stage_spacing = render_size * 0.03,
}

return settings("ScannerDisplayViewDecodeSearchSettings", scanner_display_view_decode_search_settings)
