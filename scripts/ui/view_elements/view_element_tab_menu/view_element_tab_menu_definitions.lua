-- chunkname: @scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu_definitions.lua

local ViewElementTabMenuSettings = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local button_size = ViewElementTabMenuSettings.button_size
local panel_size = UIWorkspaceSettings.top_panel.size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	entry_pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			button_size[2]
		},
		position = {
			0,
			0,
			1
		}
	}
}
local input_text_style_left = table.clone(UIFontSettings.body)

input_text_style_left.text_horizontal_alignment = "right"
input_text_style_left.text_vertical_alignment = "top"
input_text_style_left.vertical_alignment = "center"
input_text_style_left.horizontal_alignment = "right"
input_text_style_left.size = {
	200,
	50
}
input_text_style_left.text_color = Color.ui_input_color(255, true)

local input_text_style_right = table.clone(input_text_style_left)

input_text_style_right.text_horizontal_alignment = "left"
input_text_style_right.horizontal_alignment = "left"

local widget_definitions = {
	input_text_left = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "left",
			style = input_text_style_left
		}
	}, "entry_pivot"),
	input_text_right = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "right",
			style = input_text_style_right
		}
	}, "entry_pivot")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
