-- chunkname: @scripts/ui/view_elements/view_element_accolade/view_element_accolade_settings.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local view_element_accolade_settings = {
	canvas_size = {
		500,
		500,
	},
}

return settings("ViewElementAccoladeSettings", view_element_accolade_settings)
