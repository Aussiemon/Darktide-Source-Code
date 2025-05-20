-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_decode_symbols_settings.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local render_size = 1024
local stage_amount = MinigameSettings.decode_symbols_stage_amount
local symbols_per_stage = MinigameSettings.decode_symbols_items_per_stage
local symbols_spacing = render_size * 0.001
local symbols_widget_size = {
	render_size * 0.095,
	render_size * 0.095,
}
local scanner_display_view_decode_symbols_settings = {
	decode_symbol_spacing = symbols_spacing,
	decode_symbol_widget_size = symbols_widget_size,
	decode_symbol_starting_offset_x = -(symbols_widget_size[1] * symbols_per_stage + symbols_spacing * (symbols_per_stage - 1)) * 0.5,
	decode_symbol_starting_offset_y = -(symbols_widget_size[2] * stage_amount + symbols_spacing * (stage_amount - 1)) * 0.5,
}

return settings("ScannerDisplayViewDecodeSymbolsSettings", scanner_display_view_decode_symbols_settings)
