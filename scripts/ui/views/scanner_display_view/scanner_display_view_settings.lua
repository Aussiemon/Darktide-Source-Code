local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local screen_ratio = UIWorkspaceSettings.screen.size[1] / UIWorkspaceSettings.screen.size[2]
local stage_amount = MinigameSettings.decode_symbols_stage_amount
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
local symbols_per_stage = MinigameSettings.decode_symbols_items_per_stage
local symbols_size_factor = 1.75
local symbols_spacing = 1
local symbols_widget_size = {
	screen_ratio * symbols_size_factor * 60,
	symbols_size_factor * 60
}
local scanner_display_view_settings = {
	scan_size_factor = 1.75,
	scan_num_skulls_rows = 2,
	size_factor = 2.5,
	scan_num_segments = 14,
	scan_num_skulls_columns = 5,
	scan_skulls_start_offset = scan_skull_widget_offset,
	scan_skulls_spacing = scan_skull_widget_spacing,
	scan_skull_widget_size = scan_skull_widget_size,
	scan_segment_widget_size = scan_segment_widget_size,
	scan_segment_widget_offset = scan_segment_widget_offset,
	scan_segment_widget_pivot = scan_segment_widget_pivot,
	scan_segment_half_angle = math.degrees_to_radians(18),
	decode_symbols_size_factor = symbols_size_factor,
	decode_symbol_spacing = symbols_spacing,
	decode_symbol_widget_size = symbols_widget_size,
	decode_symbol_starting_offset_x = -(symbols_widget_size[1] * symbols_per_stage + symbols_spacing * (symbols_per_stage - 1)) * 0.5,
	decode_symbol_starting_offset_y = -(symbols_widget_size[2] * stage_amount + symbols_spacing * (stage_amount - 1)) * 0.5
}

return settings("ScannerDisplayViewSettings", scanner_display_view_settings)
