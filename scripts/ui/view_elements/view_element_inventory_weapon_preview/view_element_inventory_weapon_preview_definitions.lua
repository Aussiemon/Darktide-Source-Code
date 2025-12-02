-- chunkname: @scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
}
local widget_definitions = {}

return {
	background_widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					0,
				},
				color = Color.black(30, true),
			},
		},
	}, "screen"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
