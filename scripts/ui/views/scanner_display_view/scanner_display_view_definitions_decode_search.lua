-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_decode_search.lua

local ScannerDisplayViewDefinitionsBase = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base")
local ScannerDisplayViewDecodeSearchSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_decode_search_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = ScannerDisplayViewDefinitionsBase.scenegraph_definition
local widget_definitions = {
	scanner_background = ScannerDisplayViewDefinitionsBase.widget_definitions.scanner_background,
	noise_background = ScannerDisplayViewDefinitionsBase.widget_definitions.noise_background,
	decoration_right_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_right_mark,
	decoration_inquisition = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_inquisition,
	decoration_skull = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_skull,
	symbol_frame = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_search_symbol_frame",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "center_pivot", nil, ScannerDisplayViewDecodeSearchSettings.cursor_widget_size),
	symbol_highlight = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_search_symbol_frame",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "center_pivot", nil, ScannerDisplayViewDecodeSearchSettings.cursor_widget_size),
}

return {
	decode_search = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition,
	},
}
