-- chunkname: @scripts/ui/view_elements/view_element_input_legend/view_element_input_legend_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ViewElementInputLegendSettings = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend_settings")
local button_size = ViewElementInputLegendSettings.button_size
local panel_size = UIWorkspaceSettings.top_panel.size
local scenegraph_definition = {
	bottom_panel = UIWorkspaceSettings.bottom_panel,
	entry_pivot = {
		horizontal_alignment = "left",
		parent = "bottom_panel",
		vertical_alignment = "center",
		size = {
			0,
			button_size[2],
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local widget_definitions = {
	bottom_panel = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					0,
				},
				color = {
					100,
					0,
					0,
					0,
				},
			},
		},
	}, "bottom_panel"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
