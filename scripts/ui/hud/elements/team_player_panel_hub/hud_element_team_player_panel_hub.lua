local definition_path = "scripts/ui/hud/elements/team_player_panel_hub/hud_element_team_player_panel_hub_definitions"
local HudElementTeamPlayerPanelHubSettings = require("scripts/ui/hud/elements/team_player_panel_hub/hud_element_team_player_panel_hub_settings")
local HudElementTeamPlayerPanelHub = class("HudElementTeamPlayerPanelHub", "HudElementPlayerPanelBase")

HudElementTeamPlayerPanelHub.init = function (self, parent, draw_layer, start_scale, data)
	HudElementTeamPlayerPanelHub.super.init(self, parent, draw_layer, start_scale, data, definition_path, HudElementTeamPlayerPanelHubSettings)
end

HudElementTeamPlayerPanelHub.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementTeamPlayerPanelHub.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementTeamPlayerPanelHub.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	Profiler.start("HudElementTeamPlayerPanelHub:draw")
	HudElementTeamPlayerPanelHub.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
	Profiler.stop("HudElementTeamPlayerPanelHub:draw")
end

return HudElementTeamPlayerPanelHub
