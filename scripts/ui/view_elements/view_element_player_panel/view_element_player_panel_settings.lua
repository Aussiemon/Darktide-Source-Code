-- chunkname: @scripts/ui/view_elements/view_element_player_panel/view_element_player_panel_settings.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local view_element_player_panel_settings = {
	button_text_margin = 20,
	button_spacing = 50,
	button_size = {
		300,
		50
	}
}

return settings("ViewElementPlayerPanelSettings", view_element_player_panel_settings)
