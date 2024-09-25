-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_defuse.lua

local ScannerDisplayViewDefinitionsBase = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base")
local ScannerDisplayViewDefuseSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_defuse_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = ScannerDisplayViewDefinitionsBase.scenegraph_definition
local widget_definitions = {
	scanner_background = ScannerDisplayViewDefinitionsBase.widget_definitions.scanner_background,
	noise_background = ScannerDisplayViewDefinitionsBase.widget_definitions.noise_background,
	decoration_left_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_left_mark,
	decoration_right_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_right_mark,
	decoration_eagle = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_eagle,
	decoration_skull = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_skull,
	defuse_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/scanner/scanner_background_defuse",
			style = {
				hdr = true,
				color = {
					196,
					0,
					255,
					0,
				},
				offset = {
					-960,
					-540,
					0,
				},
			},
		},
	}, "center_pivot", nil, {
		1920,
		1080,
	}),
	symbol_frame = UIWidget.create_definition({
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
	}, "center_pivot", nil, ScannerDisplayViewDefuseSettings.cursor_widget_size),
	symbol_highlight = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_symbol_highlight",
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
	}, "center_pivot", nil, ScannerDisplayViewDefuseSettings.cursor_widget_size),
}

return {
	defuse = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition,
	},
}
