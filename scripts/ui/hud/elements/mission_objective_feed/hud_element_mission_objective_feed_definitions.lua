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
		30,
		30
	}
	local icon_offset = 10
	local side_offset = 10
	local bar_offset = {
		icon_size[1] + side_offset + icon_offset,
		header_size[2] + 1,
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
			visibility_function = " content.show_bar ",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "top",
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
			}
		},
		{
			style_id = "bar",
			pass_type = "texture",
			visibility_function = " content.show_bar ",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				vertical_alignment = "top",
				offset = {
					bar_offset[1],
					bar_offset[2],
					7
				},
				size = bar_size,
				default_size = bar_size,
				color = {
					230,
					255,
					151,
					29
				}
			}
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
					-4,
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
					header_size[1] - (side_offset * 2 + icon_size[1] * 2),
					header_size[2]
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
					bar_size[1],
					header_size[2]
				}
			}
		}
	}, scenegraph_id)
end

local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "background",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				color = {
					100,
					0,
					0,
					0
				}
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
				color = UIHudSettings.color_tint_main_1
			}
		},
		{
			value = "content/ui/materials/hud/backgrounds/fade_horizontal",
			style_id = "background_emitter_glow",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				size = {
					150
				},
				offset = {
					0,
					0,
					4
				},
				color = color_copy({}, UIHudSettings.color_tint_main_3, 150)
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "background_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				scale_to_material = true,
				horizontal_alignment = "right",
				color = {
					100,
					0,
					0,
					0
				},
				size_addition = {
					20,
					20
				},
				offset = {
					10,
					-10,
					0
				}
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
