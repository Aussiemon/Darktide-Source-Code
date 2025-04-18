-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_frequency_settings.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local screen_ratio = UIWorkspaceSettings.screen.size[1] / UIWorkspaceSettings.screen.size[2]
local symbols_size_factor = 1.75
local edge_fade_widget_size = {
	screen_ratio * symbols_size_factor * 650,
	symbols_size_factor * 512,
}
local frequency_widget_size = {
	screen_ratio * symbols_size_factor * 60,
	symbols_size_factor * 60,
}
local stage_widget_size = {
	screen_ratio * symbols_size_factor * 40,
	symbols_size_factor * 40,
}
local scanner_display_view_frequency_settings = {
	frequency_slide_speed = 1,
	frequency_starting_offset_x = 0,
	frequency_starting_offset_y = 0,
	frequency_width = 1600,
	stage_spacing = 30,
	stages_starting_offset_x = 260,
	stages_starting_offset_y = 300,
	edge_fade_widget_size = edge_fade_widget_size,
	frequency_widget_size = frequency_widget_size,
	stage_widget_size = stage_widget_size,
}

return settings("ScannerDisplayViewFrequencySettings", scanner_display_view_frequency_settings)
