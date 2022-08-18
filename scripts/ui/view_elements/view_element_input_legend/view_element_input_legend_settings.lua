local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local view_element_input_legend_settings = {
	button_edge_margin = 170,
	button_text_margin = 20,
	button_spacing = 10,
	button_size = {
		300,
		50
	}
}

return settings("ViewElementInputLegendSettings", view_element_input_legend_settings)
