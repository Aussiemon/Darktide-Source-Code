local HudElementWorldMarkersSettings = require("scripts/ui/hud/elements/world_markers/hud_element_world_markers_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "left",
		parent = "screen",
		horizontal_alignment = "top",
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
local widget_definitions = {}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
