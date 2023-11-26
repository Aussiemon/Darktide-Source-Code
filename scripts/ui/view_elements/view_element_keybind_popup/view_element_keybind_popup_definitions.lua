-- chunkname: @scripts/ui/view_elements/view_element_keybind_popup/view_element_keybind_popup_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local start_layer = 1
local background_height = 200
local text_box_height = background_height - 60
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	text_box = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1000,
			text_box_height
		},
		position = {
			0,
			0,
			start_layer + 1
		}
	},
	description_text = {
		vertical_alignment = "center",
		parent = "text_box",
		horizontal_alignment = "center",
		size = {
			1000,
			text_box_height - 20
		},
		position = {
			0,
			0,
			2
		}
	},
	value_background = {
		vertical_alignment = "bottom",
		parent = "text_box",
		horizontal_alignment = "center",
		size = {
			1000,
			50
		},
		position = {
			0,
			0,
			1
		}
	}
}
local action_text_style = table.clone(UIFontSettings.header_2)

action_text_style.text_horizontal_alignment = "center"
action_text_style.text_vertical_alignment = "top"

local description_text_style = table.clone(UIFontSettings.body)

description_text_style.text_horizontal_alignment = "center"
description_text_style.text_vertical_alignment = "center"

local warning_text_style = table.clone(UIFontSettings.body)

warning_text_style.text_horizontal_alignment = "center"
warning_text_style.text_vertical_alignment = "bottom"
warning_text_style.text_color = {
	150,
	255,
	0,
	0
}

local value_text_style = table.clone(UIFontSettings.header_3)

value_text_style.text_horizontal_alignment = "center"
value_text_style.text_vertical_alignment = "center"

local widget_definitions = {
	popup_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				offset = {
					0,
					0,
					start_layer
				},
				size = {
					[2] = background_height
				},
				color = {
					166,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	edge_top = UIWidget.create_definition({
		{
			value = "content/ui/materials/buttons/background_selected_edge",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				hdr = true,
				offset = {
					0,
					-background_height * 0.5,
					start_layer + 1
				},
				size = {
					nil,
					2
				},
				color = Color.terminal_corner(255, true)
			}
		}
	}, "screen"),
	edge_bottom = UIWidget.create_definition({
		{
			value = "content/ui/materials/buttons/background_selected_edge",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				hdr = true,
				offset = {
					0,
					background_height * 0.5,
					start_layer + 1
				},
				size = {
					nil,
					2
				},
				color = Color.terminal_corner(255, true)
			}
		}
	}, "screen"),
	action_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = action_text_style
		}
	}, "text_box"),
	description_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = description_text_style
		}
	}, "description_text"),
	value_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = value_text_style
		}
	}, "value_background")
}

return {
	background_widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					start_layer - 1
				},
				color = Color.terminal_corner(30, true)
			}
		}
	}, "screen"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
