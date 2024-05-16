-- chunkname: @scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator_definitions.lua

local HudElementDamageIndicatorSettings = require("scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local size = HudElementDamageIndicatorSettings.size
local center_distance = HudElementDamageIndicatorSettings.center_distance
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
	indicator = {
		horizontal_alignment = "center",
		parent = "pivot",
		vertical_alignment = "center",
		size = size,
		position = {
			0,
			0,
			1,
		},
	},
}
local widget_definitions = {}
local indicator = UIWidget.create_definition({
	{
		pass_type = "rotated_texture",
		style_id = "background",
		value = "content/ui/materials/hud/damage_indicators/hit_indicator_bg",
		style = {
			angle = 0,
			pivot = {
				size[1] * 0.5,
				center_distance,
			},
			color = UIHudSettings.color_tint_alert_3,
		},
	},
	{
		pass_type = "rotated_texture",
		style_id = "front",
		value = "content/ui/materials/hud/damage_indicators/hit_indicator_fg",
		style = {
			angle = 0,
			pivot = {
				size[1] * 0.5,
				center_distance,
			},
			color = UIHudSettings.color_tint_alert_1,
			offset = {
				0,
				0,
				1,
			},
		},
	},
}, "indicator")

return {
	indicator_definition = indicator,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
