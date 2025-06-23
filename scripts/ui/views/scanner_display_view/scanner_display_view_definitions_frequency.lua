-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_frequency.lua

local ScannerDisplayViewDefinitionsBase = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base")
local ScannerDisplayViewFrequencySettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_frequency_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local edge_fade_widget_size = ScannerDisplayViewFrequencySettings.edge_fade_widget_size
local scenegraph_definition = ScannerDisplayViewDefinitionsBase.scenegraph_definition
local widget_definitions = {
	scanner_background = ScannerDisplayViewDefinitionsBase.widget_definitions.scanner_background,
	noise_background = ScannerDisplayViewDefinitionsBase.widget_definitions.noise_background,
	decoration_left_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_left_mark,
	decoration_right_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_right_mark,
	decoration_inquisition = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_inquisition,
	decoration_skull = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_skull,
	edge_fade = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_left_to_right_fade_01",
			style_id = "highlight",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-edge_fade_widget_size[1] * 0.5,
					-edge_fade_widget_size[2] * 0.5,
					2
				}
			}
		}
	}, "center_pivot", nil, edge_fade_widget_size)
}

return {
	frequency = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
}
