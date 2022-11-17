local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			50
		}
	}
}
local widget_definitions = {}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
