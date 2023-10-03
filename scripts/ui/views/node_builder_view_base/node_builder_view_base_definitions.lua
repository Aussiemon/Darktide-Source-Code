local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	layout_background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			256,
			256
		},
		position = {
			0,
			0,
			1
		}
	},
	node_pivot = {
		vertical_alignment = "top",
		parent = "layout_background",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			2
		}
	}
}
local overlay_scenegraph_definition = {
	screen = UIWorkspaceSettings.screen
}
local widget_definitions = {
	input_surface = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					10
				}
			}
		}
	}, "screen"),
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "screen", nil, nil)
}
local layout_widget_definitions = {
	layout_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/talent_builder/background_tile_01",
			pass_type = "texture",
			style = {
				color = {
					255,
					120,
					120,
					120
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "layout_background", nil, nil)
}

return {
	widget_definitions = widget_definitions,
	layout_widget_definitions = layout_widget_definitions,
	scenegraph_definition = scenegraph_definition,
	overlay_scenegraph_definition = overlay_scenegraph_definition
}
