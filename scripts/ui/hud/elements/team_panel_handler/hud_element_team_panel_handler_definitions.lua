local HudElementTeamPanelHandlerSettings = require("scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler_settings")
local HudElementTeamPlayerPanelSettings = require("scripts/ui/hud/elements/team_player_panel/hud_element_team_player_panel_settings")
local HudElementPersonalPlayerPanelSettings = require("scripts/ui/hud/elements/personal_player_panel/hud_element_personal_player_panel_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local max_panels = HudElementTeamPanelHandlerSettings.max_panels
local panel_size = HudElementTeamPanelHandlerSettings.panel_size
local panel_offset = HudElementTeamPanelHandlerSettings.panel_offset
local panel_spacing = HudElementTeamPanelHandlerSettings.panel_spacing
local start_offset = {
	17,
	-50,
	0
}
local personal_player_panel_size = HudElementPersonalPlayerPanelSettings.size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	local_player = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		position = start_offset,
		size = personal_player_panel_size
	}
}
local widget_definitions = {}
local position_x = start_offset[1] + panel_offset[1]
local position_y = start_offset[2] + panel_offset[2] - personal_player_panel_size[2]

for i = 1, max_panels - 1 do
	local scenegraph_id = "player_" .. i
	local position = {
		position_x,
		position_y,
		panel_offset[3]
	}
	scenegraph_definition[scenegraph_id] = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = panel_size,
		position = position
	}
	position_x = position_x + panel_spacing[1]
	position_y = position_y - (panel_size[2] + panel_spacing[2])
end

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
