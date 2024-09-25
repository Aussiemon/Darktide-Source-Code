-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_balance.lua

local ScannerDisplayViewDefinitionsBase = require("scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base")
local ScannerDisplayViewBalanceSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_balance_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = ScannerDisplayViewDefinitionsBase.scenegraph_definition
local background_pos = ScannerDisplayViewBalanceSettings.background_position
local background_size = ScannerDisplayViewBalanceSettings.background_size
local widget_definitions = {
	scanner_background = ScannerDisplayViewDefinitionsBase.widget_definitions.scanner_background,
	noise_background = ScannerDisplayViewDefinitionsBase.widget_definitions.noise_background,
	decoration_left_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_left_mark,
	decoration_right_mark = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_right_mark,
	decoration_eagle = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_eagle,
	decoration_skull = ScannerDisplayViewDefinitionsBase.widget_definitions.decoration_skull,
	cursor = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/backgrounds/scanner/scanner_drill_circle_filled",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					1,
				},
			},
		},
	}, "center_pivot", nil, ScannerDisplayViewBalanceSettings.cursor_widget_size),
	balance_progress = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "progress_texture",
			value = "content/ui/materials/backgrounds/scanner/scanner_balance_progress",
			style = {
				hdr = true,
				color = {
					255,
					0,
					196,
					0,
				},
				offset = {
					background_pos[1] - background_size[1] * 0.1,
					background_pos[2] - background_size[2] * 0.1,
					0,
				},
			},
		},
	}, "center_pivot", nil, {
		background_size[1] * 1.2,
		background_size[2] * 1.2,
	}),
	balance_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/scanner/scanner_drill_circle_filled",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0,
				},
				offset = {
					background_pos[1] + background_size[1] * 0.01,
					background_pos[2] + background_size[2] * 0.01,
					1,
				},
				size = {
					background_size[1] * 0.98,
					background_size[2] * 0.98,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/scanner/scanner_drill_wireframe_small",
			style = {
				hdr = true,
				color = {
					255,
					0,
					196,
					0,
				},
				offset = {
					background_pos[1],
					background_pos[2],
					2,
				},
			},
		},
	}, "center_pivot", nil, ScannerDisplayViewBalanceSettings.background_size),
}

return {
	balance = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition,
	},
}
