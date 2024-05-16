-- chunkname: @scripts/ui/view_elements/view_element_uniform_grid/view_element_uniform_grid_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	grid_area = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local widget_definitions = {}
local grid_cell_scenegraph_blueprint = {
	horizontal_alignment = "left",
	parent = "grid_area",
	vertical_alignment = "top",
	size = {
		0,
		0,
	},
	position = {
		0,
		0,
		1,
	},
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	grid_cell_scenegraph_blueprint = grid_cell_scenegraph_blueprint,
}
