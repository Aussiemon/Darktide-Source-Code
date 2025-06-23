-- chunkname: @scripts/ui/hud/elements/cutscene_fading/hud_element_cutscene_fading_definitions.lua

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
			0
		}
	}
}
local widget_definitions = {
	fade = UIWidget.create_definition({
		{
			style_id = "rect",
			pass_type = "rect",
			style = {
				size = {},
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
