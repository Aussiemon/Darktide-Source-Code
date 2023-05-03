local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	canvas = {
		vertical_alignment = "left",
		horizontal_alignment = "top",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	video_player_1 = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	}
}
local widget_definitions = {
	display = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				scenegraph_id = "canvas",
				hdr = false,
				color = Color.blue(100, true),
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/loading/hologram_01",
			pass_type = "texture",
			style = {
				hdr = false,
				color = Color.ui_orange_medium(255, true),
				offset = {
					0,
					0,
					50
				}
			}
		}
	}, "canvas")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
