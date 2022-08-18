local HudElementPlayerHealthSettings = require("scripts/ui/hud/elements/player_health/hud_element_player_health_settings")
local HudElementPlayerToughnessSettings = require("scripts/ui/hud/elements/player_health/hud_element_player_toughness_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local bar_size = HudElementPlayerHealthSettings.size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bar = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = bar_size,
		position = {
			0,
			HudElementPlayerHealthSettings.edge_offset,
			0
		}
	},
	toughness_bar = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = bar_size,
		position = {
			0,
			HudElementPlayerToughnessSettings.edge_offset,
			0
		}
	}
}
local widget_definitions = {
	health = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_fill",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					3
				},
				size = bar_size,
				color = UIHudSettings.color_tint_1
			}
		}
	}, "bar"),
	health_ghost = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_fill",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					2
				},
				size = bar_size,
				color = UIHudSettings.color_tint_5
			}
		}
	}, "bar"),
	health_max = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_fill",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					1
				},
				size = bar_size,
				color = UIHudSettings.color_tint_3
			}
		}
	}, "bar"),
	frame = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_line",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					4
				},
				size = {
					bar_size[1],
					bar_size[2]
				},
				color = UIHudSettings.color_tint_5
			}
		}
	}, "bar"),
	death_pulse = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_pulse",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					5
				},
				size = {
					bar_size[1],
					bar_size[2] + 10
				},
				color = {
					255,
					255,
					0,
					0
				}
			}
		}
	}, "bar"),
	frame_shadow = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_shadow",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				},
				size = {
					bar_size[1] + 10,
					bar_size[2] + 10
				},
				color = UIHudSettings.color_tint_0
			}
		}
	}, "bar"),
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_fill",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = bar_size,
				color = UIHudSettings.color_tint_0
			}
		}
	}, "bar"),
	toughness = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_fill",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					3
				},
				size = bar_size,
				color = UIHudSettings.color_tint_6
			}
		}
	}, "toughness_bar"),
	toughness_ghost = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_fill",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					2
				},
				size = bar_size,
				color = UIHudSettings.color_tint_6
			}
		}
	}, "toughness_bar"),
	toughness_max = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_fill",
			style_id = "texture",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					1
				},
				size = bar_size,
				color = UIHudSettings.color_tint_3
			}
		}
	}, "toughness_bar"),
	toughness_frame = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_line",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					4
				},
				size = {
					bar_size[1],
					bar_size[2]
				},
				color = UIHudSettings.color_tint_5
			}
		}
	}, "toughness_bar"),
	toughness_death_pulse = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_pulse",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					5
				},
				size = {
					bar_size[1],
					bar_size[2] + 10
				},
				color = {
					255,
					255,
					0,
					0
				}
			}
		}
	}, "toughness_bar"),
	toughness_frame_shadow = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_shadow",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				},
				size = {
					bar_size[1] + 10,
					bar_size[2] + 10
				},
				color = UIHudSettings.color_tint_0
			}
		}
	}, "toughness_bar"),
	toughness_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/hp_bar_fill",
			style_id = "texture",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = bar_size,
				color = UIHudSettings.color_tint_0
			}
		}
	}, "toughness_bar")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
