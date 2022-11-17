local HudElementTeamPanelHandlerSettings = require("scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler_settings")
local HudElementPersonalPlayerPanelSettings = require("scripts/ui/hud/elements/personal_player_panel/hud_element_personal_player_panel_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local panel_size = HudElementPersonalPlayerPanelSettings.size
local panel_offset = HudElementTeamPanelHandlerSettings.panel_offset
local bar_size = HudElementPersonalPlayerPanelSettings.bar_size
local icon_size = HudElementPersonalPlayerPanelSettings.icon_size
local icon_bar_spacing = HudElementPersonalPlayerPanelSettings.icon_bar_spacing
local toughness_bar_size = {
	bar_size[1],
	8
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
		vertical_alignment = "center",
		parent = "panel_background",
		horizontal_alignment = "left",
		size = bar_size,
		position = {
			128,
			18,
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
			-20,
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
local hud_body_font_setting_name = "hud_body"
local hud_body_font_settings = UIFontSettings[hud_body_font_setting_name]
local hud_body_font_color = UIHudSettings.color_tint_main_2

local function color_copy(target, source, alpha)
	target[1] = alpha or source[1]
	target[2] = source[2]
	target[3] = source[3]
	target[4] = source[4]

	return target
end

local value_text_style = {
	horizontal_alignment = "left",
	font_size = 18,
	text_vertical_alignment = "center",
	text_horizontal_alignment = "right",
	vertical_alignment = "center",
	drop_shadow = true,
	font_type = "machine_medium",
	text_color = UIHudSettings.color_tint_main_2,
	offset = {
		0,
		0,
		2
	}
}
local widget_definitions = {
	player_name = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<player_name>",
			style = {
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "left",
				drop_shadow = true,
				offset = {
					0,
					-(bar_size[2] + 5),
					2
				},
				size = {
					bar_size[1] * 1.5,
					bar_size[2]
				},
				font_type = hud_body_font_settings.font_type,
				font_size = hud_body_font_settings.font_size,
				default_font_size = hud_body_font_settings.font_size,
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
	respawn_timer = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<0.0>",
			style = {
				text_vertical_alignment = "center",
				text_horizontal_alignment = "left",
				drop_shadow = true,
				offset = {
					0,
					0,
					2
				},
				size = {
					bar_size[1] * 1.5,
					bar_size[2]
				},
				font_type = hud_body_font_settings.font_type,
				font_size = hud_body_font_settings.font_size,
				default_font_size = hud_body_font_settings.font_size,
				text_color = UIHudSettings.color_tint_main_1,
				default_text_color = UIHudSettings.color_tint_main_1
			}
		}
	}, "bar"),
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
	voice_indicator = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/icons/speaker",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					16,
					16
				},
				offset = {
					6,
					0,
					6
				},
				color = UIHudSettings.color_tint_main_1
			}
		}
	}, "panel_background"),
	panel_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/terminal_background_team_panels",
			style_id = "background",
			pass_type = "texture",
			style = {
				horizontal_alignment = "left",
				color = Color.terminal_background_gradient(178.5, true),
				offset = {
					110,
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
	health_text = UIWidget.create_definition({
		{
			value_id = "text_3",
			style_id = "text_3",
			pass_type = "text",
			value = "0",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 3,
				text_color = UIHudSettings.color_tint_main_1,
				default_color = UIHudSettings.color_tint_main_1,
				dimmed_color = UIHudSettings.color_tint_main_3,
				offset = {
					40
				}
			})
		},
		{
			value_id = "text_2",
			style_id = "text_2",
			pass_type = "text",
			value = "0",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 2,
				text_color = UIHudSettings.color_tint_main_1,
				default_color = UIHudSettings.color_tint_main_1,
				dimmed_color = UIHudSettings.color_tint_main_3,
				offset = {
					28
				}
			})
		},
		{
			value_id = "text_1",
			style_id = "text_1",
			pass_type = "text",
			value = "0",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 1,
				text_color = UIHudSettings.color_tint_main_1,
				default_color = UIHudSettings.color_tint_main_1,
				dimmed_color = UIHudSettings.color_tint_main_3,
				offset = {
					16
				}
			})
		}
	}, "bar"),
	toughness_text = UIWidget.create_definition({
		{
			value_id = "text_3",
			style_id = "text_3",
			pass_type = "text",
			value = "0",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 3,
				text_color = UIHudSettings.color_tint_6,
				default_color = UIHudSettings.color_tint_6,
				dimmed_color = UIHudSettings.color_tint_7,
				offset = {
					40
				}
			})
		},
		{
			value_id = "text_2",
			style_id = "text_2",
			pass_type = "text",
			value = "0",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 2,
				text_color = UIHudSettings.color_tint_6,
				default_color = UIHudSettings.color_tint_6,
				dimmed_color = UIHudSettings.color_tint_7,
				offset = {
					28
				}
			})
		},
		{
			value_id = "text_1",
			style_id = "text_1",
			pass_type = "text",
			value = "0",
			style = table.merge_recursive(table.clone(value_text_style), {
				index = 1,
				text_color = UIHudSettings.color_tint_6,
				default_color = UIHudSettings.color_tint_6,
				dimmed_color = UIHudSettings.color_tint_7,
				offset = {
					16
				}
			})
		}
	}, "toughness_bar"),
	player_icon = UIWidget.create_definition({
		{
			value = "content/ui/materials/base/ui_portrait_frame_base",
			style_id = "texture",
			pass_type = "texture",
			style = {
				material_values = {
					use_placeholder_texture = 1,
					rows = 1,
					columns = 1,
					grid_index = 1
				},
				color = UIHudSettings.color_tint_main_1
			}
		}
	}, "player_icon"),
	status_icon = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/icons/player_states/dead",
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
