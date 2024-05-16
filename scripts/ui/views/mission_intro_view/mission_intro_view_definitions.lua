-- chunkname: @scripts/ui/views/mission_intro_view/mission_intro_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	canvas = {
		horizontal_alignment = "top",
		vertical_alignment = "left",
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
	video_player_1 = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
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
	display = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				hdr = false,
				scenegraph_id = "canvas",
				color = Color.blue(100, true),
				offset = {
					0,
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/loading/hologram_01",
			style = {
				hdr = false,
				color = Color.ui_orange_medium(255, true),
				offset = {
					0,
					0,
					50,
				},
			},
		},
	}, "canvas"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
