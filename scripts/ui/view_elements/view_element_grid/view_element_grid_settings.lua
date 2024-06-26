﻿-- chunkname: @scripts/ui/view_elements/view_element_grid/view_element_grid_settings.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local view_element_grid_settings = {
	button_spacing = 50,
	button_text_margin = 20,
	button_size = {
		300,
		50,
	},
}

return settings("ViewElementGrid", view_element_grid_settings)
