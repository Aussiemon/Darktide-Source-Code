-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_expedition_map.lua

local ScannerDisplayViewDefinitionsBase = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base")
local ScannerDisplayViewExpeditionsMapSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_expedition_map_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = ScannerDisplayViewDefinitionsBase.scenegraph_definition
local widget_definitions = {
	scanner_background = ScannerDisplayViewDefinitionsBase.widget_definitions.scanner_background,
	noise_background = ScannerDisplayViewDefinitionsBase.widget_definitions.noise_background,
	cursor = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_symbol_frame",
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
	}, "center_pivot", nil, ScannerDisplayViewExpeditionsMapSettings.target_widget_size),
}

return {
	expedition_map = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition,
	},
}
