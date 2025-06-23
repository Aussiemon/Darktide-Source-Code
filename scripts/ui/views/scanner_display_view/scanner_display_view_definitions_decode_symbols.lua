-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_decode_symbols.lua

local ScannerDisplayViewDefinitionsBase = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base")
local ScannerDisplayViewDecodeSymbolsSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_decode_symbols_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = ScannerDisplayViewDefinitionsBase.scenegraph_definition
local widget_definitions = {
	scanner_background = ScannerDisplayViewDefinitionsBase.widget_definitions.scanner_background,
	noise_background = ScannerDisplayViewDefinitionsBase.widget_definitions.noise_background,
	decoration_left_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_left_mark,
	decoration_right_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_right_mark,
	decoration_inquisition = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_inquisition,
	decoration_eagle = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_eagle,
	decoration_skull = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_skull,
	symbol_frame = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_symbol_frame",
			style_id = "frame",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "center_pivot", nil, ScannerDisplayViewDecodeSymbolsSettings.decode_symbol_widget_size),
	symbol_highlight = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_symbol_highlight",
			style_id = "highlight",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "center_pivot", nil, ScannerDisplayViewDecodeSymbolsSettings.decode_symbol_widget_size)
}

return {
	decode_symbols = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
}
