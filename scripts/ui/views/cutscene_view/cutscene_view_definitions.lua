﻿-- chunkname: @scripts/ui/views/cutscene_view/cutscene_view_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
}
local widget_definitions = {
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
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
