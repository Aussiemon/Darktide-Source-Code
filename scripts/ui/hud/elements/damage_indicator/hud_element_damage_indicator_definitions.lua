local HudElementDamageIndicatorSettings = require("scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local size = HudElementDamageIndicatorSettings.size
local center_distance = HudElementDamageIndicatorSettings.center_distance
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	indicator = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		size = size,
		position = {
			0,
			0,
			1
		}
	}
}
local widget_definitions = {}
local indicator = UIWidget.create_definition({
	{
		value = "content/ui/materials/hud/damage_indicators/hit_indicator_bg",
		style_id = "background",
		pass_type = "rotated_texture",
		style = {
			angle = 0,
			pivot = {
				size[1] * 0.5,
				center_distance
			},
			color = UIHudSettings.color_tint_alert_3
		}
	},
	{
		value = "content/ui/materials/hud/damage_indicators/hit_indicator_fg",
		style_id = "front",
		pass_type = "rotated_texture",
		style = {
			angle = 0,
			pivot = {
				size[1] * 0.5,
				center_distance
			},
			color = UIHudSettings.color_tint_alert_1,
			offset = {
				0,
				0,
				1
			}
		}
	}
}, "indicator")

return {
	indicator_definition = indicator,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
