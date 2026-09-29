-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_drill_settings.lua

local render_size = 1024
local scanner_display_view_drill_settings = {
	board_starting_offset_x = 0,
	board_starting_offset_y = 0,
	target_widget_size = {
		render_size * 0.097,
		render_size * 0.097
	},
	edge_fade_widget_size = {
		render_size * 1.08,
		render_size * 1.08
	},
	background_rings_size = {
		render_size * 0.74,
		render_size * 0.74
	},
	board_width = render_size * 0.37,
	board_height = render_size * 0.37,
	stage_widget_size = {
		render_size * 0.08,
		render_size * 0.08
	},
	stages_starting_offset_x = render_size * 0.1,
	stages_starting_offset_y = render_size * 0.25,
	stage_spacing = render_size * 0.03
}

return settings("ScannerDisplayViewDrillSettings", scanner_display_view_drill_settings)
