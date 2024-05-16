-- chunkname: @scripts/ui/views/custom_settings_view/custom_settings_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local title_text_style = table.clone(UIFontSettings.header_2)

title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "top"

local scenegraph_definitions = {
	screen = UIWorkspaceSettings.screen,
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
			1,
		},
	},
	area = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			1500,
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
		parent = "area",
		vertical_alignment = "center",
		size = {
			600,
			100,
		},
		position = {
			0,
			-470,
			1,
		},
	},
	next_button = {
		horizontal_alignment = "center",
		parent = "area",
		vertical_alignment = "center",
		size = ButtonPassTemplates.terminal_button.size,
		position = {
			0,
			470,
			1,
		},
	},
	page_number = {
		horizontal_alignment = "center",
		parent = "next_button",
		vertical_alignment = "center",
		size = {
			500,
			100,
		},
		position = {
			0,
			-30,
			1,
		},
	},
	setting_base = {
		horizontal_alignment = "center",
		parent = "area",
		vertical_alignment = "center",
		size = {
			1720,
			880,
		},
		position = {
			0,
			0,
			1,
		},
	},
	grid_start = {
		horizontal_alignment = "center",
		parent = "setting_base",
		vertical_alignment = "center",
		size = {
			1720,
			880,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_content_pivot = {
		horizontal_alignment = "center",
		parent = "grid_start",
		vertical_alignment = "center",
		size = {
			1720,
			880,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_content_mask = {
		horizontal_alignment = "center",
		parent = "grid_start",
		vertical_alignment = "center",
		size = {
			1720,
			880,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_content_scrollbar = {
		horizontal_alignment = "center",
		parent = "grid_start",
		vertical_alignment = "center",
		size = {
			1720,
			880,
		},
		position = {
			0,
			0,
			2,
		},
	},
	grid_content_interaction = {
		horizontal_alignment = "center",
		parent = "grid_start",
		vertical_alignment = "top",
		size = {
			1720,
			880,
		},
		position = {
			0,
			0,
			2,
		},
	},
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(255, true),
			},
			offset = {
				0,
				0,
				0,
			},
		},
		{
			pass_type = "rect",
			style = {
				color = Color.black(127.5, true),
			},
			offset = {
				0,
				0,
				3,
			},
		},
		{
			pass_type = "slug_icon",
			value = "content/ui/vector_textures/symbols/cog_skull_01",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				color = {
					40,
					0,
					0,
					0,
				},
				size = {
					1250,
					1250,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignemt = "center",
				scale_to_material = true,
				vertical_alignemnt = "center",
				size_addition = {
					40,
					40,
				},
				offset = {
					-20,
					-20,
					1,
				},
				color = Color.terminal_grid_background_gradient(255, true),
			},
		},
	}, "screen"),
	gamma_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(255, true),
			},
			offset = {
				0,
				0,
				0,
			},
		},
	}, "screen", {
		visible = false,
	}),
	title_settings = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = title_text_style,
		},
	}, "title_text"),
	page_number = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = title_text_style,
		},
	}, "page_number"),
	next_button = UIWidget.create_definition(ButtonPassTemplates.terminal_button, "next_button", {
		gamepad_action = "next",
		original_text = "",
	}),
	grid_content_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur_viewport_2",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
			},
		},
	}, "grid_content_mask"),
	grid_content_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "grid_content_scrollbar", {
		scroll_speed = 10,
	}),
	options_grid_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "grid_content_interaction"),
	settings_overlay = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					20,
				},
				color = {
					160,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
}
local accessibility_widget_definitions = {
	title_settings = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "Gamma Settings",
			value_id = "text",
			style = title_text_style,
		},
	}, "title_text"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definitions,
	accessibility_widget_definitions = accessibility_widget_definitions,
}
