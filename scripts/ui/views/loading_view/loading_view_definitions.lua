local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	title_background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			470,
			64
		},
		position = {
			0,
			-100,
			2
		}
	},
	title_divider_bottom = {
		vertical_alignment = "bottom",
		parent = "title_background",
		horizontal_alignment = "center",
		size = {
			306,
			48
		},
		position = {
			0,
			50,
			1
		}
	},
	hint_text = {
		vertical_alignment = "center",
		parent = "title_background",
		horizontal_alignment = "center",
		size = {
			1800,
			40
		},
		position = {
			0,
			0,
			1
		}
	},
	hint_input_description = {
		vertical_alignment = "center",
		parent = "title_divider_bottom",
		horizontal_alignment = "center",
		size = {
			1000,
			32
		},
		position = {
			0,
			50,
			1
		}
	},
	hint_input_icon = {
		vertical_alignment = "center",
		parent = "hint_input_description",
		horizontal_alignment = "center",
		size = {
			24,
			32
		},
		position = {
			0,
			0,
			1
		}
	},
	logo = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			2500,
			2500
		},
		position = {
			0,
			0,
			0
		}
	}
}
local hint_text_font_setting_name = "header_2"
local hint_text_font_settings = UIFontSettings[hint_text_font_setting_name]
local hint_text_font_color = hint_text_font_settings.text_color
local input_text_font_setting_name = "body"
local input_text_font_settings = UIFontSettings[input_text_font_setting_name]
local input_text_font_color = input_text_font_settings.text_color
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/loading/loading_screen_background"
		}
	}, "screen"),
	title_divider_bottom = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_rendered_center_02",
			pass_type = "texture",
			style = {
				color = Color.white(255, true)
			}
		}
	}, "title_divider_bottom"),
	logo = UIWidget.create_definition({
		{
			value = "content/ui/vector_textures/symbols/aquila",
			pass_type = "slug_icon",
			style = {
				color = {
					120,
					0,
					0,
					0
				}
			}
		}
	}, "logo"),
	overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					20
				},
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	hint_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "n/a",
			style = {
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = hint_text_font_color,
				font_type = hint_text_font_settings.font_type,
				font_size = hint_text_font_settings.font_size
			}
		}
	}, "hint_text"),
	hint_input_description = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "n/a",
			style = {
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = input_text_font_color,
				font_type = input_text_font_settings.font_type,
				font_size = input_text_font_settings.font_size
			}
		}
	}, "hint_input_description"),
	hint_input_icon = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/system/input_mouse_left",
			pass_type = "texture",
			style = {
				color = input_text_font_color
			}
		}
	}, "hint_input_icon")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
