-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_scan_settings.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local screen_ratio = UIWorkspaceSettings.screen.size[1] / UIWorkspaceSettings.screen.size[2]
local scan_skull_size_factor = 0.92
local scan_skull_widget_size = {
	screen_ratio * scan_skull_size_factor * 128,
	scan_skull_size_factor * 128
}
local scan_skull_widget_spacing = {
	screen_ratio * scan_skull_size_factor * 32,
	scan_skull_size_factor * 22
}
local scan_skull_widget_offset = {
	screen_ratio * scan_skull_size_factor * -544,
	scan_skull_size_factor * -195
}
local scan_segment_size_factor = 0.9
local scan_segment_widget_size = {
	screen_ratio * scan_segment_size_factor * 32,
	scan_segment_size_factor * 128
}
local scan_segment_widget_offset = {
	screen_ratio * scan_segment_size_factor * 0,
	scan_segment_size_factor * -1950,
	1
}
local scan_segment_widget_pivot = {
	screen_ratio * scan_segment_size_factor * 0,
	scan_segment_size_factor * 1950
}
local scanner_display_view_scan_settings = {
	scan_num_skulls_columns = 5,
	scan_num_skulls_rows = 2,
	scan_size_factor = 1.75,
	size_factor = 2.5,
	scan_num_segments = 14,
	scan_skulls_start_offset = scan_skull_widget_offset,
	scan_skulls_spacing = scan_skull_widget_spacing,
	scan_skull_widget_size = scan_skull_widget_size,
	scan_segment_widget_size = scan_segment_widget_size,
	scan_segment_widget_offset = scan_segment_widget_offset,
	scan_segment_widget_pivot = scan_segment_widget_pivot,
	scan_segment_half_angle = math.degrees_to_radians(18)
}

return settings("ScannerDisplayViewScanSettings", scanner_display_view_scan_settings)
