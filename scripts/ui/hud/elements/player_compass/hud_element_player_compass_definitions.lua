-- chunkname: @scripts/ui/hud/elements/player_compass/hud_element_player_compass_definitions.lua

local HudElementPlayerCompassSettings = require("scripts/ui/hud/elements/player_compass/hud_element_player_compass_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local background_size = {
	960,
	50,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bounding_box = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			background_size[1],
			background_size[2],
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
		size = {
			background_size[1] - 50,
			background_size[2],
		},
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
			760,
			40,
		},
		position = {
			0,
			5,
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
			style_id = "compass_aquila",
			value = "content/ui/materials/compass/ui_compass_aquila",
			style = {
				horizontal_alignment = "center",
				offset = {
					0,
					-7,
					1,
				},
				size = {
					96,
					68,
				},
				material_values = {
					state = 1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "compass_background",
			value = "content/ui/materials/compass/ui_compass_background",
			style = {
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				material_values = {
					state = 1,
				},
			},
		},
	}, "background"),
	navigation_lines = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "lines",
			value = "content/ui/materials/compass/ui_compass_navigation",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size = {
					756,
					26,
				},
				offset = {
					0,
					0,
					1,
				},
				material_values = {
					uv_offset = 0,
				},
			},
		},
	}, "area"),
}
local header_font_setting_name = "hud_body"
local header_font_settings = UIFontSettings[header_font_setting_name]
local header_font_color = Color.ui_hud_green_super_light(255, true)
local header_font_color = {
	255,
	114,
	247,
	119,
}
local default_widget_icon_definition = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/backgrounds/scanner/scanner_decode_symbol_frame",
		value_id = "frame",
		style = {
			hdr = true,
			color = {
				255,
				255,
				255,
				255,
			},
			size = {
				50,
				50,
			},
		},
	},
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
		pass_type = "texture",
		style_id = "title_icon",
		value = "content/ui/materials/hud/interactions/icons/location",
		value_id = "title_icon",
		style = {
			offset = {
				0,
				0,
				1,
			},
			color = Color.ui_hud_green_light(255, true),
		},
		visibility_function = function (content, style)
			return content.title_icon ~= nil
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
