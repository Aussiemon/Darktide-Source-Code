-- chunkname: @scripts/ui/hud/elements/player_compass/hud_element_player_compass_definitions.lua

local HudElementPlayerCompassSettings = require("scripts/ui/hud/elements/player_compass/hud_element_player_compass_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local background_size = {
	1000,
	25,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bounding_box = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			background_size[1] + 70,
			background_size[2] + 20,
		},
		position = {
			0,
			HudElementPlayerCompassSettings.edge_offset,
			0,
		},
	},
	background = {
		horizontal_alignment = "center",
		parent = "bounding_box",
		vertical_alignment = "top",
		size = background_size,
		position = {
			0,
			5,
			1,
		},
	},
	area = {
		horizontal_alignment = "center",
		parent = "background",
		vertical_alignment = "center",
		size = {
			background_size[1] - 50,
			background_size[2],
		},
		position = {
			0,
			0,
			0,
		},
	},
	background_frame = {
		horizontal_alignment = "center",
		parent = "background",
		vertical_alignment = "center",
		size = {
			716,
			716,
		},
		position = {
			0,
			0,
			1,
		},
	},
	pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/faded_line_01",
			style = {
				hdr = true,
				horizontal_alignment = "center",
				color = Color.ui_hud_green_super_light(255, true),
				size = {
					nil,
					2,
				},
				size_addition = {
					100,
					0,
				},
				offset = {
					0,
					-3,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/faded_line_01",
			style = {
				hdr = true,
				horizontal_alignment = "center",
				color = Color.ui_hud_green_medium(255, true),
				size = {
					nil,
					2,
				},
				size_addition = {
					100,
					0,
				},
				offset = {
					0,
					-2,
					0,
				},
			},
		},
	}, "background"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
