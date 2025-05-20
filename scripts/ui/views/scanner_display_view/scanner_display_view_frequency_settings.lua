-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_frequency_settings.lua

local render_size = 1024
local scanner_display_view_frequency_settings = {
	frequency_slide_speed = 1,
	frequency_starting_offset_x = 0,
	frequency_starting_offset_y = 0,
	edge_fade_widget_size = {
		render_size * 1.05,
		render_size * 0.5,
	},
	frequency_widget_size = {
		render_size * 0.1,
		render_size * 0.1,
	},
	frequency_width = render_size * 0.8,
	stage_widget_size = {
		render_size * 0.08,
		render_size * 0.08,
	},
	stages_starting_offset_x = render_size * 0.1,
	stages_starting_offset_y = render_size * 0.25,
	stage_spacing = render_size * 0.03,
}

return settings("ScannerDisplayViewFrequencySettings", scanner_display_view_frequency_settings)
