local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	top_panel = UIWorkspaceSettings.top_panel,
	grid_content_pivot = {
		vertical_alignment = "top",
		parent = "top_panel",
		horizontal_alignment = "center",
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
	top_panel = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					100,
					0,
					0,
					0
				}
			}
		}
	}, "top_panel"),
	top_panel_edge = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					2
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "top_panel"),
	headline_effect = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/headline_terminal",
			pass_type = "texture",
			style = {
				color = Color.ui_terminal(70, true),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "top_panel")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
