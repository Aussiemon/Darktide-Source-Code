-- chunkname: @scripts/ui/hud/elements/objective_progress_bar/hud_element_objective_progress_bar_definitions.lua

local HudElementObjectiveProgressBarSettings = require("scripts/ui/hud/elements/objective_progress_bar/hud_element_objective_progress_bar_settings")
local HudElementObjectiveTextSettings = require("scripts/ui/hud/elements/objective_progress_bar/hud_element_objective_text_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local health_bar_size = HudElementObjectiveProgressBarSettings.size
local health_bar_position = {
	0,
	HudElementObjectiveProgressBarSettings.edge_offset,
	0
}
local name_text_style = table.clone(HudElementObjectiveTextSettings.style)

name_text_style.offset = {
	0,
	15,
	2
}

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			748,
			130
		},
		position = health_bar_position
	},
	health_bar = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = health_bar_size,
		position = {
			0,
			0,
			1
		}
	}
}
local widget_definitions = {}
local single_target_widget_definitions = {
	health = UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/backgrounds/boss_health_fill",
			style_id = "bar",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					-13,
					4
				},
				size = health_bar_size,
				color = UIHudSettings.color_tint_main_1
			}
		},
		{
			value = "content/ui/materials/hud/backgrounds/boss_health_fill",
			style_id = "ghost",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					0,
					-13,
					3
				},
				size = health_bar_size,
				color = {
					25,
					255,
					255,
					255
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "max",
			pass_type = "texture_uv",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					0,
					-13,
					2
				},
				size = health_bar_size,
				color = UIHudSettings.color_tint_8
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					-13,
					1
				},
				size = {
					health_bar_size[1] + 4,
					health_bar_size[2] + 4
				},
				color = {
					255,
					0,
					0,
					0
				}
			}
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<N/A>",
			style = name_text_style
		}
	}, "health_bar")
}

return {
	single_target_widget_definitions = single_target_widget_definitions,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
