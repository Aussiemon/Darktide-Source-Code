-- chunkname: @scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel_settings.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local top_panel_size = UIWorkspaceSettings.top_panel.size
local view_element_menu_panel_settings = {
	button_text_margin = 30,
	button_max_size = {
		300,
		top_panel_size[2]
	},
	grid_spacing = {
		5,
		top_panel_size[2]
	}
}

return settings("ViewElementMenuPanelSettings", view_element_menu_panel_settings)
