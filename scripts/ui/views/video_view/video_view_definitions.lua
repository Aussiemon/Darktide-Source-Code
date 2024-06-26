-- chunkname: @scripts/ui/views/video_view/video_view_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	video_canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		scale = "aspect_ratio",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local widget_definitions = {
	video = UIWidget.create_definition({
		{
			pass_type = "video",
			value_id = "video_path",
		},
	}, "video_canvas"),
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
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

if IS_PLAYSTATION then
	widget_definitions.playstation_dummy_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "placeholder_name",
			value_id = "text",
			style = {
				font_size = 48,
				font_type = "machine_medium",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_color = {
					255,
					255,
					0,
					0,
				},
				offset = {
					0,
					0,
					10,
				},
			},
		},
	}, "screen")
end

local legend_inputs = {
	{
		alignment = "left_alignment",
		display_name = "loc_cutscene_skip_no_input",
		input_action = "skip_cinematic_hold",
		key = "hold_skip",
		on_pressed_callback = "on_skip_pressed",
		use_mouse_hold = true,
	},
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	legend_inputs = legend_inputs,
}
