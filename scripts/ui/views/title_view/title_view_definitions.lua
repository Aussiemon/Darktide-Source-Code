-- chunkname: @scripts/ui/views/title_view/title_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	background_image = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	title_text = {
		vertical_alignment = "bottom",
		parent = "background_image",
		horizontal_alignment = "center",
		size = {
			1200,
			40
		},
		position = {
			0,
			-55,
			4
		}
	},
	logo = {
		vertical_alignment = "bottom",
		parent = "background_image",
		horizontal_alignment = "center",
		size = {
			1920,
			470
		},
		position = {
			0,
			0,
			2
		}
	}
}
local title_text_font_style = table.clone(UIFontSettings.body)

title_text_font_style.text_horizontal_alignment = "center"
title_text_font_style.text_color = {
	255,
	255,
	255,
	255
}
title_text_font_style.font_size = 24

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	background_image = UIWidget.create_definition({
		{
			value = "content/ui/materials/title_screen_background",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "background_image"),
	logo = UIWidget.create_definition({
		{
			value = "content/ui/materials/symbols/logo_bishop",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "logo"),
	title_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = title_text_font_style,
			change_function = function (content, style)
				local progress = content.ready_to_continue and 1 or 0.5 + math.sin(Application.time_since_launch() * 3) * 0.5
				local text_color = style.text_color

				text_color[2] = 180 + 75 * progress
				text_color[3] = 180 + 75 * progress
				text_color[4] = 180 + 75 * progress
			end
		}
	}, "title_text")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
