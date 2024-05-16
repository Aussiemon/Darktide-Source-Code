-- chunkname: @scripts/ui/views/first_run_settings_view/first_run_settings_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local title_text_style = table.clone(UIFontSettings.header_2)

title_text_style.text_horizontal_alignment = "center"
title_text_style.text_vertical_alignment = "top"

local scenegraph_definitions = {
	screen = UIWorkspaceSettings.screen,
	title_text = {
		horizontal_alignment = "center",
		parent = "screen",
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
	page_number = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			500,
			100,
		},
		position = {
			0,
			420,
			1,
		},
	},
	next_button = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			400,
			50,
		},
		position = {
			0,
			470,
			1,
		},
	},
	setting_base = {
		horizontal_alignment = "center",
		parent = "screen",
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
		horizontal_alignment = "left",
		parent = "setting_base",
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
	grid_content_pivot = {
		horizontal_alignment = "left",
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
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
	title_settings = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "Gamma Settings",
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
	next_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "next_button", {
		original_text = "Confirm",
	}),
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
