-- chunkname: @scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_definitions.lua

local HudElementMissionObjectiveFeedSettings = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local header_size = HudElementMissionObjectiveFeedSettings.header_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	area = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			header_size[1],
			200
		},
		position = {
			-50,
			100,
			1
		}
	},
	background = {
		vertical_alignment = "top",
		parent = "area",
		horizontal_alignment = "right",
		size = {
			header_size[1],
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "right",
		size = {
			header_size[1],
			50
		},
		position = {
			10,
			4,
			1
		}
	}
}

local function color_copy(target, source, alpha)
	target[1] = alpha or source[1]
	target[2] = source[2]
	target[3] = source[3]
	target[4] = source[4]

	return target
end

local function create_mission_objective(scenegraph_id)
	local header_font_settings = UIFontSettings.hud_body
	local drop_shadow = false
	local header_font_color = UIHudSettings.color_tint_main_1
	local icon_size = {
		32,
		32
	}
	local icon_offset = 10
	local side_offset = 10
	local bar_offset = {
		icon_size[1] + side_offset + icon_offset,
		1,
		0
	}
	local bar_size = {
		header_size[1] - (bar_offset[1] + icon_offset + side_offset * 2),
		10
	}

	return UIWidget.create_definition({
		{
			style_id = "bar_background",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "bottom",
				offset = {
					bar_offset[1],
					bar_offset[2],
					6
				},
				size = bar_size,
				color = {
					150,
					0,
					0,
					0
				}
			},
			visibility_function = function (content)
				return content.show_bar
			end
		},
		{
			style_id = "bar",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "bottom",
				offset = {
					bar_offset[1],
					bar_offset[2],
					7
				},
				size = bar_size,
				default_length = bar_size[1],
				color = {
					230,
					255,
					151,
					29
				}
			},
			visibility_function = function (content)
				return content.show_bar
			end
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/objectives/bonus",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = icon_size,
				offset = {
					icon_offset,
					0,
					6
				},
				color = UIHudSettings.color_tint_main_1
			}
		},
		{
			style_id = "header_text",
			pass_type = "text",
			value_id = "header_text",
			value = "<header_text>",
			style = {
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "top",
				offset = {
					bar_offset[1],
					0,
					6
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					header_size[1] - (side_offset * 2 + icon_size[1] * 2)
				}
			}
		},
		{
			style_id = "distance_text",
			pass_type = "text",
			value_id = "distance_text",
			value = "",
			style = {
				text_vertical_alignment = "center",
				text_horizontal_alignment = "right",
				vertical_alignment = "top",
				offset = {
					bar_offset[1],
					0,
					6
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				drop_shadow = drop_shadow,
				size = {
					bar_size[1]
				}
			}
		}
	}, scenegraph_id, nil, header_size)
end

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/terminal_background_weapon",
			style_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				color = Color.terminal_background_gradient(255, true)
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "ground_emitter",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				size = {
					4
				},
				offset = {
					0,
					0,
					5
				},
				color = Color.terminal_corner_hover(nil, true)
			}
		}
	}, "background")
}
local animations = {}

return {
	animations = animations,
	objective_definition = create_mission_objective("pivot"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
