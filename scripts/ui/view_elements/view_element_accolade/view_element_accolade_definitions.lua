-- chunkname: @scripts/ui/view_elements/view_element_accolade/view_element_accolade_definitions.lua

local ViewElementAccoladeSettings = require("scripts/ui/view_elements/view_element_accolade/view_element_accolade_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local canvas_size = ViewElementAccoladeSettings.canvas_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	canvas = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		size = canvas_size,
		position = {
			-150,
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
