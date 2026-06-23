-- chunkname: @scripts/ui/hud/elements/minion_shield_health/hud_element_minion_shield_health_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	panel = {
		horizontal_alignment = "center",
		parent = "pivot",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
}
local widget_definitions = {
	minion_shield_health = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "icon_01",
			value = "content/ui/materials/hud/icons/minion_shield_health/stamina_full",
			value_id = "icon_01",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				visible = false,
				color = Color.dark_gray(255, true),
				offset = {
					25,
					30,
					2,
				},
				size = {
					40,
					40,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_01_sub_icon_01",
			value = "content/ui/materials/hud/icons/minion_shield_health/stamina_empty_right",
			value_id = "icon_01_sub_icon_01",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				visible = false,
				color = Color.crimson(255, true),
				offset = {
					25,
					30,
					3,
				},
				size = {
					40,
					40,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_01_sub_icon_02",
			value = "content/ui/materials/hud/icons/minion_shield_health/stamina_empty_left",
			value_id = "icon_01_sub_icon_02",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				visible = false,
				color = Color.crimson(255, true),
				offset = {
					25,
					30,
					3,
				},
				size = {
					40,
					40,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_03",
			value = "content/ui/materials/hud/icons/minion_shield_health/stamina_full",
			value_id = "icon_03",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				visible = false,
				color = Color.dark_gray(255, true),
				offset = {
					-25,
					30,
					2,
				},
				size = {
					40,
					40,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_03_sub_icon_01",
			value = "content/ui/materials/hud/icons/minion_shield_health/stamina_empty_right",
			value_id = "icon_03_sub_icon_01",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				visible = false,
				color = Color.crimson(255, true),
				offset = {
					-25,
					30,
					3,
				},
				size = {
					40,
					40,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "icon_03_sub_icon_02",
			value = "content/ui/materials/hud/icons/minion_shield_health/stamina_empty_left",
			value_id = "icon_03_sub_icon_02",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				visible = false,
				color = Color.crimson(255, true),
				offset = {
					-25,
					30,
					3,
				},
				size = {
					40,
					40,
				},
			},
		},
	}, "panel"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
