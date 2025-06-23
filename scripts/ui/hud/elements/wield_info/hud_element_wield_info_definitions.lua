-- chunkname: @scripts/ui/hud/elements/wield_info/hud_element_wield_info_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local background_size = {
	800,
	120
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bounding_box = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = background_size,
		position = {
			0,
			-140,
			0
		}
	},
	input_pivot = {
		vertical_alignment = "bottom",
		parent = "bounding_box",
		horizontal_alignment = "center",
		size = {
			background_size[1],
			40
		},
		position = {
			0,
			0,
			1
		}
	}
}
local description_style = table.clone(UIFontSettings.hud_body)

description_style.text_horizontal_alignment = "center"
description_style.text_vertical_alignment = "top"

local input_style = table.clone(UIFontSettings.hud_body)

input_style.text_horizontal_alignment = "center"
input_style.text_vertical_alignment = "center"
input_style.offset = {
	0,
	0,
	2
}
input_style.text_color = Color.ui_hud_green_super_light(255, true)

local input_info_definition = UIWidget.create_definition({
	{
		style_id = "icon",
		pass_type = "texture",
		value_id = "icon",
		style = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-40,
				1
			},
			size = {
				40,
				40
			}
		},
		visibility_function = function (content, style)
			return content.icon ~= nil
		end
	},
	{
		value_id = "text",
		pass_type = "text",
		style = input_style
	}
}, "input_pivot")
local widget_definitions = {}

return {
	input_info_definition = input_info_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
