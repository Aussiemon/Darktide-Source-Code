﻿-- chunkname: @scripts/ui/views/result_view/result_view_definitions.lua

local DefaultPassTemplates = require("scripts/ui/pass_templates/default_pass_templates")
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
			1,
		},
	},
	title_background = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			470,
			64,
		},
		position = {
			0,
			-200,
			2,
		},
	},
	title_divider_top = {
		horizontal_alignment = "center",
		parent = "title_background",
		vertical_alignment = "top",
		size = {
			470,
			28,
		},
		position = {
			0,
			-16,
			1,
		},
	},
	title_divider_bottom = {
		horizontal_alignment = "center",
		parent = "title_background",
		vertical_alignment = "bottom",
		size = {
			470,
			32,
		},
		position = {
			0,
			19,
			1,
		},
	},
	title_text = {
		horizontal_alignment = "center",
		parent = "title_background",
		vertical_alignment = "center",
		size = {
			1800,
			40,
		},
		position = {
			0,
			0,
			1,
		},
	},
	sub_title_background = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			800,
			64,
		},
		position = {
			0,
			200,
			2,
		},
	},
	sub_title_text = {
		horizontal_alignment = "center",
		parent = "sub_title_background",
		vertical_alignment = "center",
		size = {
			1800,
			40,
		},
		position = {
			0,
			0,
			1,
		},
	},
	icon = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			612,
			241,
		},
		position = {
			0,
			0,
			1,
		},
	},
	background_icon = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			2500,
			2500,
		},
		position = {
			0,
			0,
			0,
		},
	},
}
local title_text_font_setting_name = "header_1"
local title_text_font_settings = UIFontSettings[title_text_font_setting_name]
local title_text_font_color = title_text_font_settings.text_color
local text_style = table.clone(title_text_font_settings)

text_style.text_color = {
	255,
	203,
	197,
	175,
}

local widget_definitions = {
	title_divider_top = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_03",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "title_divider_top"),
	title_divider_bottom = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_center_02",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "title_divider_bottom"),
	title_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style = {
				color = {
					100,
					0,
					0,
					0,
				},
			},
		},
	}, "title_background"),
	sub_title_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			style = {
				color = {
					100,
					0,
					0,
					0,
				},
			},
		},
	}, "sub_title_background"),
	icon = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/symbols/aquila_rusty",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "icon"),
	background_icon = UIWidget.create_definition({
		{
			pass_type = "slug_icon",
			value = "content/ui/vector_textures/symbols/aquila",
			style = {
				color = {
					50,
					0,
					0,
					0,
				},
			},
		},
	}, "background_icon"),
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
					0,
				},
			},
		},
	}, "screen"),
	panel_bottom = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					130,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
	panel_top = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				size = {
					nil,
					130,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
	title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "VICTORY",
			value_id = "text",
			style = text_style,
		},
	}, "title_text"),
	sub_title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "00:00",
			value_id = "text",
			style = text_style,
		},
	}, "sub_title_text"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
