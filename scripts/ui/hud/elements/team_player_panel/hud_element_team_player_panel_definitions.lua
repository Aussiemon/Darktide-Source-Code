local HudElementTeamPanelHandlerSettings = require("scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler_settings")
local HudElementTeamPlayerPanelSettings = require("scripts/ui/hud/elements/team_player_panel/hud_element_team_player_panel_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local panel_size = HudElementTeamPanelHandlerSettings.panel_size
local panel_offset = HudElementTeamPanelHandlerSettings.panel_offset
local bar_size = HudElementTeamPlayerPanelSettings.size
local icon_size = HudElementTeamPlayerPanelSettings.icon_size
local icon_bar_spacing = HudElementTeamPlayerPanelSettings.icon_bar_spacing
local throwable_size = HudElementTeamPlayerPanelSettings.throwable_size
local ammo_size = HudElementTeamPlayerPanelSettings.ammo_size
local toughness_bar_size = {
	bar_size[1],
	5
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = panel_size,
		position = panel_offset
	},
	panel_background = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "left",
		size = panel_size,
		position = {
			0,
			0,
			0
		}
	},
	player_icon = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "left",
		size = icon_size,
		position = {
			33,
			0,
			2
		}
	},
	bar = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "left",
		size = bar_size,
		position = {
			112,
			53,
			2
		}
	},
	toughness_bar = {
		vertical_alignment = "center",
		parent = "bar",
		horizontal_alignment = "left",
		size = toughness_bar_size,
		position = {
			0,
			-10,
			2
		}
	},
	respawn_timer = {
		vertical_alignment = "center",
		parent = "player_icon",
		horizontal_alignment = "left",
		size = bar_size,
		position = {
			icon_size[1] + icon_bar_spacing[1] * 2 + bar_size[1],
			icon_bar_spacing[2],
			3
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

local hud_body_font_setting_name = "hud_body"
local hud_body_font_settings = UIFontSettings[hud_body_font_setting_name]
local hud_body_font_color = UIHudSettings.color_tint_main_1
local rich_presence_font_settings = table.clone(UIFontSettings.hud_body)
local rich_presence_font_color = UIHudSettings.color_tint_main_2
local widget_definitions = {
	player_name = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<player_name>",
			style = {
				font_size = 16,
				default_font_size = 16,
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "left",
				offset = {
					0,
					-bar_size[2] - 24,
					4
				},
				default_offset = {
					0,
					-bar_size[2] - 24,
					2
				},
				size = {
					panel_size[1],
					bar_size[2]
				},
				font_type = hud_body_font_settings.font_type,
				text_color = hud_body_font_color,
				default_text_color = hud_body_font_color,
				dead_text_color = {
					200,
					80,
					80,
					80
				}
			}
		}
	}, "toughness_bar"),
	rich_presence = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<rich_presence>",
			style = {
				default_font_size = 22,
				font_size = 22,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				offset = {
					0,
					-10,
					4
				},
				size = {
					bar_size[1] * 1.5,
					bar_size[2]
				},
				font_type = rich_presence_font_settings.font_type,
				text_color = rich_presence_font_color,
				default_text_color = rich_presence_font_color,
				dead_text_color = {
					200,
					80,
					80,
					80
				}
			}
		}
	}, "toughness_bar"),
	respawn_timer = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<0.0>",
			style = {
				default_font_size = 22,
				font_size = 22,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					-10,
					4
				},
				size = {
					bar_size[1] * 1.5,
					bar_size[2]
				},
				font_type = hud_body_font_settings.font_type,
				text_color = UIHudSettings.color_tint_main_2,
				default_text_color = UIHudSettings.color_tint_main_2
			}
		}
	}, "toughness_bar"),
	throwable = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/icons/party_throwable",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = throwable_size,
				offset = {
					0,
					-22,
					3
				},
				color = UIHudSettings.color_tint_main_1
			}
		}
	}, "toughness_bar"),
	ammo_status = UIWidget.create_definition({
		{
			value_id = "ammo",
			style_id = "ammo",
			pass_type = "texture",
			value = "content/ui/materials/hud/icons/party_ammo",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = ammo_size,
				offset = {
					18,
					-22,
					3
				},
				color = UIHudSettings.color_tint_main_1
			}
		}
	}, "toughness_bar"),
	pocketable = UIWidget.create_definition({
		{
			value_id = "texture",
			pass_type = "texture",
			style_id = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = {
					16,
					16
				},
				offset = {
					38,
					-22,
					3
				},
				color = UIHudSettings.color_tint_main_1
			},
			visibility_function = function (content)
				return content.texture ~= nil
			end
		}
	}, "toughness_bar"),
	pocketable_small = UIWidget.create_definition({
		{
			value_id = "texture",
			pass_type = "texture",
			style_id = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				size = {
					16,
					16
				},
				default_offset = {
					58,
					-22,
					3
				},
				offset = {
					58,
					-22,
					3
				},
				color = UIHudSettings.color_tint_main_1
			},
			visibility_function = function (content)
				return content.texture ~= nil
			end
		}
	}, "toughness_bar"),
	voice_indicator = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/icons/speaker",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					32,
					32
				},
				offset = {
					-8,
					0,
					8
				},
				color = UIHudSettings.color_tint_main_1
			}
		}
	}, "panel_background"),
	coherency_indicator = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/icons/party_cohesion",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				size = {
					24,
					24
				},
				offset = {
					34,
					0,
					8
				},
				color = UIHudSettings.color_tint_main_1
			}
		}
	}, "bar"),
	panel_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/terminal_background_team_panels",
			style_id = "background",
			pass_type = "texture",
			style = {
				horizontal_alignment = "left",
				color = Color.terminal_background_gradient(178.5, true),
				offset = {
					100,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "hit_indicator",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = color_copy({}, UIHudSettings.color_tint_6, 0),
				size_addition = {
					20,
					20
				},
				default_size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			value = "content/ui/materials/frames/inner_shadow_medium",
			style_id = "hit_indicator_armor_break",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = color_copy({}, UIHudSettings.color_tint_6, 0),
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "panel_background"),
	toughness = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					4
				},
				size = toughness_bar_size,
				color = UIHudSettings.color_tint_6
			}
		}
	}, "toughness_bar"),
	toughness_ghost = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					3
				},
				size = toughness_bar_size,
				color = {
					255,
					90,
					90,
					90
				}
			}
		}
	}, "toughness_bar"),
	toughness_bar_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					1
				},
				size = toughness_bar_size,
				color = UIHudSettings.color_tint_0
			}
		}
	}, "toughness_bar"),
	player_icon = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_portrait_frame_base",
			style = {
				material_values = {
					use_placeholder_texture = 1,
					rows = 1,
					columns = 1,
					grid_index = 1
				}
			}
		}
	}, "player_icon"),
	status_icon = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				color = UIHudSettings.color_tint_main_1,
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "player_icon")
}
local health_bar_segment_definition = UIWidget.create_definition({
	{
		value = "content/ui/materials/backgrounds/default_square",
		style_id = "background",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			offset = {
				0,
				0,
				2
			},
			size = bar_size,
			color = UIHudSettings.color_tint_0
		}
	},
	{
		value = "content/ui/materials/backgrounds/default_square",
		style_id = "health",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			offset = {
				0,
				0,
				4
			},
			size = bar_size,
			color = UIHudSettings.color_tint_main_1
		}
	},
	{
		value = "content/ui/materials/backgrounds/default_square",
		style_id = "ghost",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			offset = {
				0,
				0,
				3
			},
			size = bar_size,
			color = {
				255,
				90,
				90,
				90
			}
		}
	},
	{
		value = "content/ui/materials/hud/backgrounds/player_health_fill",
		style_id = "corruption",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			offset = {
				0,
				0,
				5
			},
			size = bar_size,
			color = UIHudSettings.color_tint_8
		}
	}
}, "bar", nil, bar_size)

return {
	health_bar_segment_definition = health_bar_segment_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
