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
local legend_inputs = {
	{
		input_action = "skip_cinematic_hold",
		display_name = "loc_cutscene_skip_hold_no_input",
		alignment = "left_alignment",
		use_mouse_hold = true,
		on_pressed_callback = "on_skip_pressed",
		key = "hold_skip"
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	legend_inputs = legend_inputs
}
