-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_drill.lua

local ScannerDisplayViewDefinitionsBase = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base")
local ScannerDisplayViewDrillSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_drill_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local edge_fade_widget_size = ScannerDisplayViewDrillSettings.edge_fade_widget_size
local scenegraph_definition = ScannerDisplayViewDefinitionsBase.scenegraph_definition
local widget_definitions = {
	scanner_background = ScannerDisplayViewDefinitionsBase.widget_definitions.scanner_background,
	noise_background = ScannerDisplayViewDefinitionsBase.widget_definitions.noise_background,
	decoration_left_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_left_mark,
	decoration_right_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_right_mark,
	decoration_inquisition = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_inquisition,
	decoration_skull = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_skull,
	cursor = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/backgrounds/scanner/scanner_drill_selection_cursor",
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
	}, "center_pivot", nil, ScannerDisplayViewDrillSettings.target_widget_size),
	search_fade = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/backgrounds/scanner/scanner_drill_circle_filled",
			style = {
				hdr = true,
				color = {
					0,
					0,
					0,
					0,
				},
			},
		},
	}, "center_pivot", nil, ScannerDisplayViewDrillSettings.target_widget_size),
	edge_fade = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/backgrounds/scanner/scanner_edge_to_center_fade",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0,
				},
				offset = {
					-edge_fade_widget_size[1] * 0.5,
					-edge_fade_widget_size[2] * 0.5,
					2,
				},
			},
		},
	}, "center_pivot", nil, edge_fade_widget_size),
}

return {
	drill = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition,
	},
}
