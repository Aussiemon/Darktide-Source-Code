-- chunkname: @scripts/ui/views/blank_view/blank_view_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
}
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			pass_type = "rect",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				color = {
					255,
					0,
					0,
					0,
				},
			},
		},
	}, "screen", nil, nil),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
