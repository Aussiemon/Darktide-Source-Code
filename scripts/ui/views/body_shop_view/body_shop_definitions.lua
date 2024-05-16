-- chunkname: @scripts/ui/views/body_shop_view/body_shop_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	placeholder_box = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			800,
			600,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local text_style = table.clone(UIFontSettings.header_1)

text_style.text_horizontal_alignment = "center"
text_style.text_vertical_alignment = "center"

local widget_definitions = {
	placeholder_box = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					160,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "Body Shop WIP",
			value_id = "text",
			style = text_style,
		},
	}, "placeholder_box"),
}
local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_settings_menu_close_menu",
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
	},
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
