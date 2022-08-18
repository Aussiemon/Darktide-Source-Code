local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	placeholder_box = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			800,
			600
		},
		position = {
			0,
			0,
			1
		}
	}
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
					0
				}
			}
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "Training Ground WIP",
			style = text_style
		}
	}, "placeholder_box")
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "cb_on_close_pressed",
		display_name = "loc_settings_menu_close_menu",
		alignment = "left_alignment"
	}
}

return {
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
