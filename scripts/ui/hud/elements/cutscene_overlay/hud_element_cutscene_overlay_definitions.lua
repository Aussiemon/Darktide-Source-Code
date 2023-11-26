-- chunkname: @scripts/ui/hud/elements/cutscene_overlay/hud_element_cutscene_overlay_definitions.lua

local HudElementDamageIndicatorSettings = require("scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			800
		}
	}
}
local widget_definitions = {
	top = UIWidget.create_definition({
		{
			style_id = "rect",
			pass_type = "rect",
			style = {
				size = {
					nil,
					100
				},
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "screen"),
	bottom = UIWidget.create_definition({
		{
			style_id = "rect",
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					100
				},
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "screen")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
