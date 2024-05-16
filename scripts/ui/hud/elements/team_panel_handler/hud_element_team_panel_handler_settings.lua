-- chunkname: @scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler_settings.lua

local hud_element_team_panel_handler_settings = {
	max_panels = 4,
	panel_size = {
		380,
		66,
	},
	panel_offset = {
		0,
		-35,
		0,
	},
	panel_spacing = {
		0,
		16,
	},
}

return settings("HudElementTeamPanelHandlerSettings", hud_element_team_panel_handler_settings)
