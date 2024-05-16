-- chunkname: @scripts/ui/hud/elements/boss_health/hud_element_boss_health_definitions.lua

local HudElementBossHealthSettings = require("scripts/ui/hud/elements/boss_health/hud_element_boss_health_settings")
local HudElementBossToughnessSettings = require("scripts/ui/hud/elements/boss_health/hud_element_boss_toughness_settings")
local HudElementBossNameSettings = require("scripts/ui/hud/elements/boss_health/hud_element_boss_name_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local small_bar_spacing = 30
local health_bar_size = HudElementBossHealthSettings.size
local health_bar_size_small = HudElementBossHealthSettings.size_small
local _, health_bar_size_y = health_bar_size[1], health_bar_size[2]
local health_bar_position = {
	0,
	HudElementBossHealthSettings.edge_offset,
	0,
}
local toughness_bar_size = HudElementBossToughnessSettings.size
local toughness_bar_size_small = HudElementBossToughnessSettings.size_small
local toughness_bar_position = {
	0,
	-13 - (health_bar_size_y + 6),
	0,
}
local name_text_size = HudElementBossNameSettings.size
local name_text_position = {
	0,
	health_bar_size_y + 10,
	0,
}
local name_text_style = table.clone(HudElementBossNameSettings.style)

name_text_style.offset = {
	0,
	15,
	2,
}

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			748,
			130,
		},
		position = health_bar_position,
	},
	health_bar = {
		horizontal_alignment = "center",
		parent = "background",
		vertical_alignment = "center",
		size = health_bar_size,
		position = {
			0,
			0,
			1,
		},
	},
	toughness_bar = {
		horizontal_alignment = "center",
		parent = "health_bar",
		vertical_alignment = "top",
		size = toughness_bar_size,
		position = toughness_bar_position,
	},
}
local widget_definitions = {}
local single_target_widget_definitions = {
	health = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "bar",
			value = "content/ui/materials/hud/backgrounds/boss_health_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					-13,
					4,
				},
				size = health_bar_size,
				color = {
					255,
					255,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "ghost",
			value = "content/ui/materials/hud/backgrounds/boss_health_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					-13,
					3,
				},
				size = health_bar_size,
				color = {
					25,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "max",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					0,
					-13,
					2,
				},
				size = health_bar_size,
				color = UIHudSettings.color_tint_8,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					-13,
					1,
				},
				size = {
					health_bar_size[1] + 4,
					health_bar_size[2] + 4,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "<N/A>",
			value_id = "text",
			style = name_text_style,
		},
	}, "health_bar"),
	toughness = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "bar",
			value = "content/ui/materials/hud/backgrounds/boss_toughness_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					4,
				},
				size = toughness_bar_size,
				color = UIHudSettings.color_tint_secondary_1,
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "ghost",
			value = "content/ui/materials/hud/backgrounds/boss_toughness_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					3,
				},
				size = toughness_bar_size,
				color = {
					25,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "max",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				size = toughness_bar_size,
				color = UIHudSettings.color_tint_3,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					1,
				},
				size = {
					toughness_bar_size[1] + 4,
					toughness_bar_size[2] + 4,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "toughness_bar"),
}
local left_double_target_widget_definitions = {
	health = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "bar",
			value = "content/ui/materials/hud/backgrounds/boss_health_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					-13,
					4,
				},
				size = health_bar_size_small,
				color = {
					255,
					255,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "ghost",
			value = "content/ui/materials/hud/backgrounds/boss_health_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					-13,
					3,
				},
				size = health_bar_size_small,
				color = {
					25,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "max",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					-13,
					2,
				},
				size = health_bar_size_small,
				color = UIHudSettings.color_tint_8,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					-2,
					-13,
					1,
				},
				size = {
					health_bar_size_small[1] + 4,
					health_bar_size_small[2] + 4,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "<N|A>",
			value_id = "text",
			style = table.merge_recursive(table.clone(name_text_style), {
				offset = {
					-(health_bar_size_small[1] + small_bar_spacing) * 0.5,
					15,
					3,
				},
			}),
		},
	}, "health_bar"),
	toughness = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "bar",
			value = "content/ui/materials/hud/backgrounds/boss_toughness_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					4,
				},
				size = toughness_bar_size_small,
				color = UIHudSettings.color_tint_secondary_1,
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "ghost",
			value = "content/ui/materials/hud/backgrounds/boss_toughness_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					3,
				},
				size = toughness_bar_size_small,
				color = {
					25,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "max",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				size = toughness_bar_size_small,
				color = UIHudSettings.color_tint_3,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					-2,
					0,
					1,
				},
				size = {
					toughness_bar_size_small[1] + 4,
					toughness_bar_size_small[2] + 4,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "toughness_bar"),
}
local right_double_target_widget_definitions = {
	health = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "bar",
			value = "content/ui/materials/hud/backgrounds/boss_health_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					health_bar_size_small[1] + small_bar_spacing,
					-13,
					4,
				},
				size = health_bar_size_small,
				color = {
					255,
					255,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "ghost",
			value = "content/ui/materials/hud/backgrounds/boss_health_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					health_bar_size_small[1] + small_bar_spacing,
					-13,
					3,
				},
				size = health_bar_size_small,
				color = {
					25,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "max",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					health_bar_size_small[1] + small_bar_spacing,
					-13,
					2,
				},
				size = health_bar_size_small,
				color = UIHudSettings.color_tint_8,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					(health_bar_size_small[1] + small_bar_spacing) * 0.5,
					-13,
					1,
				},
				size = {
					health_bar_size_small[1] + 4,
					health_bar_size_small[2] + 4,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "<N|A>",
			value_id = "text",
			style = table.merge_recursive(table.clone(name_text_style), {
				offset = {
					(health_bar_size_small[1] + small_bar_spacing) * 0.5,
					15,
					3,
				},
			}),
		},
	}, "health_bar"),
	toughness = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			style_id = "bar",
			value = "content/ui/materials/hud/backgrounds/boss_toughness_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					toughness_bar_size_small[1] + small_bar_spacing,
					0,
					3,
				},
				size = toughness_bar_size_small,
				color = UIHudSettings.color_tint_secondary_1,
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "ghost",
			value = "content/ui/materials/hud/backgrounds/boss_toughness_fill",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					toughness_bar_size_small[1] + small_bar_spacing,
					0,
					2,
				},
				size = toughness_bar_size_small,
				color = {
					25,
					255,
					255,
					255,
				},
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "max",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					toughness_bar_size_small[1] + small_bar_spacing,
					0,
					1,
				},
				size = toughness_bar_size_small,
				color = UIHudSettings.color_tint_3,
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					toughness_bar_size_small[1] + small_bar_spacing - 2,
					0,
					1,
				},
				size = {
					toughness_bar_size_small[1] + 4,
					toughness_bar_size_small[2] + 4,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "toughness_bar"),
}

return {
	single_target_widget_definitions = single_target_widget_definitions,
	left_double_target_widget_definitions = left_double_target_widget_definitions,
	right_double_target_widget_definitions = right_double_target_widget_definitions,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
