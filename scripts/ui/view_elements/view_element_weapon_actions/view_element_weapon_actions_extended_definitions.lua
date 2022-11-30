local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
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
	grid_background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size_addition = {
					-4,
					0
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/dropshadow_heavy",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					16,
					20
				},
				color = {
					100,
					0,
					0,
					0
				}
			}
		}
	}, "grid_background")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
