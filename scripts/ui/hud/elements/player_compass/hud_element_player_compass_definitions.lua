-- chunkname: @scripts/ui/hud/elements/player_compass/hud_element_player_compass_definitions.lua

local HudElementPlayerCompassSettings = require("scripts/ui/hud/elements/player_compass/hud_element_player_compass_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local background_size = {
	1000,
	25,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bounding_box = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			background_size[1] + 70,
			background_size[2] + 20,
		},
		position = {
			0,
			HudElementPlayerCompassSettings.edge_offset,
			0,
		},
	},
	background = {
		horizontal_alignment = "center",
		parent = "bounding_box",
		vertical_alignment = "top",
		size = background_size,
		position = {
			0,
			5,
			1,
		},
	},
	area = {
		horizontal_alignment = "center",
		parent = "background",
		vertical_alignment = "center",
		size = {
			background_size[1] - 50,
			background_size[2],
		},
		position = {
			0,
			0,
			0,
		},
	},
	background_frame = {
		horizontal_alignment = "center",
		parent = "background",
		vertical_alignment = "center",
		size = {
			716,
			716,
		},
		position = {
			0,
			0,
			1,
		},
	},
	pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	default_icon = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/faded_line_01",
			style = {
				horizontal_alignment = "center",
				color = Color.ui_hud_green_light(255, true),
				size = {
					nil,
					2,
				},
				size_addition = {
					100,
					0,
				},
				offset = {
					0,
					-3,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/faded_line_01",
			style = {
				horizontal_alignment = "center",
				color = Color.ui_hud_green_dark(255, true),
				size = {
					nil,
					2,
				},
				size_addition = {
					100,
					0,
				},
				offset = {
					0,
					-2,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/masks/drop_shadow_center_fade",
			style = {
				horizontal_alignment = "center",
				color = Color.ui_hud_green_dark(255, true),
				size = {
					nil,
					22,
				},
				size_addition = {
					0,
					0,
				},
				offset = {
					0,
					-2,
					-1,
				},
			},
		},
	}, "background"),
}
local header_font_setting_name = "hud_body"
local header_font_settings = UIFontSettings[header_font_setting_name]
local header_font_color = Color.ui_hud_green_super_light(255, true)
local default_widget_icon_definition = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/hud/interactions/icons/location",
		value_id = "icon",
		style = {
			offset = {
				0,
				0,
				1,
			},
			color = Color.ui_hud_green_light(255, true),
		},
		visibility_function = function (content, style)
			return content.icon ~= nil
		end,
	},
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = {
			horizontal_alignment = "center",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			vertical_alignment = "center",
			offset = {
				0,
				20,
				2,
			},
			font_type = header_font_settings.font_type,
			font_size = header_font_settings.font_size,
			text_color = header_font_color,
			default_text_color = header_font_color,
			size = {
				200,
				20,
			},
		},
		visibility_function = function (content, style)
			return content.text ~= nil and content.text ~= ""
		end,
	},
}, "default_icon")

return {
	default_widget_icon_definition = default_widget_icon_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
