-- chunkname: @scripts/ui/hud/elements/cutscene_overlay/hud_element_cutscene_overlay_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
}
local widget_definitions = {
	top = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "rect",
			style = {
				size = {
					nil,
					100,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
	bottom = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "rect",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					100,
				},
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "screen"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
