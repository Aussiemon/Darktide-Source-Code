-- chunkname: @scripts/ui/view_elements/view_element_video/view_element_video_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen
}
local widget_definitions = {}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
