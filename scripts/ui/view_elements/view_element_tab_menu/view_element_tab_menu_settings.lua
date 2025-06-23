﻿-- chunkname: @scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu_settings.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local view_element_tab_menu_settings = {
	wrapped_selection = false,
	button_text_margin = 30,
	button_spacing = 50,
	button_size = {
		300,
		50
	}
}

return settings("ViewElementTabMenuSettings", view_element_tab_menu_settings)
