﻿-- chunkname: @scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	top_panel = UIWorkspaceSettings.top_panel,
	grid_content_pivot = {
		horizontal_alignment = "center",
		parent = "top_panel",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local input_text_style_left = table.clone(UIFontSettings.body)

input_text_style_left.font_size = 30
input_text_style_left.text_horizontal_alignment = "right"
input_text_style_left.text_vertical_alignment = "center"
input_text_style_left.horizontal_alignment = "left"
input_text_style_left.vertical_alignment = "top"
input_text_style_left.offset = {
	-10,
	0,
	15,
}
input_text_style_left.size = {
	200,
	UIWorkspaceSettings.top_panel.size[2],
}
input_text_style_left.text_color = Color.ui_terminal(255, true)
input_text_style_left.visible = false

local input_text_style_right = table.clone(input_text_style_left)

input_text_style_right.text_horizontal_alignment = "left"
input_text_style_right.offset[1] = 10

local widget_definitions = {
	top_panel = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.terminal_background(64, true),
			},
		},
	}, "top_panel"),
	top_panel_edge = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					2,
				},
				color = {
					255,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "top_panel"),
	headline_effect = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/headline_terminal",
			style = {
				scale_to_material = true,
				color = Color.terminal_grid_background(100, true),
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "top_panel"),
	input_text_left = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "left",
			value_id = "text",
			style = input_text_style_left,
		},
	}, "grid_content_pivot"),
	input_text_right = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "right",
			value_id = "text",
			style = input_text_style_right,
		},
	}, "grid_content_pivot"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
