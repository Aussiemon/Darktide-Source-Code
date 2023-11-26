-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_decode_symbols_settings.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local screen_ratio = UIWorkspaceSettings.screen.size[1] / UIWorkspaceSettings.screen.size[2]
local stage_amount = MinigameSettings.decode_symbols_stage_amount
local symbols_per_stage = MinigameSettings.decode_symbols_items_per_stage
local symbols_size_factor = 1.75
local symbols_spacing = 1
local symbols_widget_size = {
	screen_ratio * symbols_size_factor * 60,
	symbols_size_factor * 60
}
local scanner_display_view_decode_symbols_settings = {
	decode_symbols_size_factor = symbols_size_factor,
	decode_symbol_spacing = symbols_spacing,
	decode_symbol_widget_size = symbols_widget_size,
	decode_symbol_starting_offset_x = -(symbols_widget_size[1] * symbols_per_stage + symbols_spacing * (symbols_per_stage - 1)) * 0.5,
	decode_symbol_starting_offset_y = -(symbols_widget_size[2] * stage_amount + symbols_spacing * (stage_amount - 1)) * 0.5
}

return settings("ScannerDisplayViewDecodeSymbolsSettings", scanner_display_view_decode_symbols_settings)
