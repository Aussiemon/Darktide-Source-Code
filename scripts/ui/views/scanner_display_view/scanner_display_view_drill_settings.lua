local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local size_factor = 1.75
local screen_ratio = UIWorkspaceSettings.screen.size[1] / UIWorkspaceSettings.screen.size[2]
local target_widget_size = {
	screen_ratio * 60 * size_factor,
	60 * size_factor
}
local stage_widget_size = {
	screen_ratio * 70,
	70
}
local background_rings_size = {
	screen_ratio * 800,
	800
}
local edge_fade_widget_size = {
	screen_ratio * size_factor * 670,
	size_factor * 670
}
local scanner_display_view_drill_settings = {
	board_starting_offset_x = 0,
	board_height = 400,
	stage_spacing = 30,
	stages_starting_offset_y = 300,
	board_starting_offset_y = 0,
	stages_starting_offset_x = 260,
	size_factor = size_factor,
	target_widget_size = target_widget_size,
	stage_widget_size = stage_widget_size,
	edge_fade_widget_size = edge_fade_widget_size,
	background_rings_size = background_rings_size,
	board_width = 400 * screen_ratio
}

return settings("ScannerDisplayViewDrillSettings", scanner_display_view_drill_settings)
