local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	video_canvas = {
		vertical_alignment = "center",
		parent = "screen",
		scale = "aspect_ratio",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			1
		}
	}
}
local widget_definitions = {
	video = UIWidget.create_definition({
		{
			pass_type = "video",
			value_id = "video_path"
		}
	}, "video_canvas"),
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
	}, "screen")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
