-- chunkname: @scripts/ui/views/title_view/title_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	background_image = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			1,
		},
	},
	title_text = {
		horizontal_alignment = "center",
		parent = "background_image",
		vertical_alignment = "bottom",
		size = {
			1200,
			40,
		},
		position = {
			0,
			-55,
			4,
		},
	},
	logo = {
		horizontal_alignment = "center",
		parent = "background_image",
		vertical_alignment = "bottom",
		size = {
			1920,
			470,
		},
		position = {
			0,
			0,
			2,
		},
	},
}
local title_text_font_style = table.clone(UIFontSettings.body)

title_text_font_style.text_horizontal_alignment = "center"
title_text_font_style.text_color = {
	255,
	255,
	255,
	255,
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
					0,
				},
			},
		},
	}, "screen"),
	background_image = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/title_screen_background",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "background_image"),
	logo = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/symbols/logo_bishop",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "logo"),
	title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value_id = "text",
			style = title_text_font_style,
			change_function = function (content, style)
				local progress = content.ready_to_continue and 1 or 0.5 + math.sin(Application.time_since_launch() * 3) * 0.5
				local text_color = style.text_color

				text_color[2] = 180 + 75 * progress
				text_color[3] = 180 + 75 * progress
				text_color[4] = 180 + 75 * progress
			end,
		},
	}, "title_text"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
