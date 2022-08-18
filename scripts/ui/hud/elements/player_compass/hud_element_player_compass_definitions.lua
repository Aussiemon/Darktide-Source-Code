local HudElementPlayerCompassSettings = require("scripts/ui/hud/elements/player_compass/hud_element_player_compass_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local background_size = {
	1000,
	25
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bounding_box = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			background_size[1] + 70,
			background_size[2] + 20
		},
		position = {
			0,
			HudElementPlayerCompassSettings.edge_offset,
			0
		}
	},
	background = {
		vertical_alignment = "top",
		parent = "bounding_box",
		horizontal_alignment = "center",
		size = background_size,
		position = {
			0,
			5,
			1
		}
	},
	area = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			background_size[1] - 50,
			background_size[2]
		},
		position = {
			0,
			0,
			0
		}
	},
	background_frame = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			716,
			716
		},
		position = {
			0,
			0,
			1
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	}
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/faded_line_01",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				hdr = true,
				color = Color.ui_hud_green_light(255, true),
				size = {
					nil,
					2
				},
				size_addition = {
					100,
					0
				},
				offset = {
					0,
					-3,
					0
				}
			}
		}
	}, "background")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
