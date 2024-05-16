-- chunkname: @scripts/ui/views/loading_view/loading_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	loading_image = {
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
	hint_text = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			1800,
			40,
		},
		position = {
			0,
			-270,
			4,
		},
	},
	title_divider_bottom = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			306,
			48,
		},
		position = {
			0,
			-210,
			3,
		},
	},
	hint_input_description = {
		horizontal_alignment = "center",
		parent = "title_divider_bottom",
		vertical_alignment = "center",
		size = {
			1000,
			32,
		},
		position = {
			0,
			50,
			5,
		},
	},
	hint_input_icon = {
		horizontal_alignment = "center",
		parent = "hint_input_description",
		vertical_alignment = "center",
		size = {
			24,
			32,
		},
		position = {
			0,
			0,
			6,
		},
	},
}
local hint_text_font_setting_name = "header_2"
local hint_text_font_settings = UIFontSettings[hint_text_font_setting_name]
local hint_text_font_color = hint_text_font_settings.text_color
local input_text_font_setting_name = "body"
local input_text_font_settings = UIFontSettings[input_text_font_setting_name]
local input_text_font_color = input_text_font_settings.text_color
local widget_definitions = {
	screen = UIWidget.create_definition({
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
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/loading/loading_screen_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
			},
		},
	}, "loading_image"),
	title_divider_bottom = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_rendered_center_02",
			style = {
				color = Color.white(255, true),
			},
		},
	}, "title_divider_bottom"),
	overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					20,
				},
				color = {
					255,
					0,
					0,
					1,
				},
			},
		},
	}, "screen"),
	hint_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "n/a",
			value_id = "text",
			style = {
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = hint_text_font_color,
				font_type = hint_text_font_settings.font_type,
				font_size = hint_text_font_settings.font_size,
			},
		},
	}, "hint_text"),
	hint_input_description = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "n/a",
			value_id = "text",
			style = {
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = input_text_font_color,
				font_type = input_text_font_settings.font_type,
				font_size = input_text_font_settings.font_size,
			},
		},
	}, "hint_input_description"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
