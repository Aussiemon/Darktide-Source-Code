-- chunkname: @scripts/ui/hud/elements/personal_player_panel/hud_element_personal_player_panel.lua

local definition_path = "scripts/ui/hud/elements/personal_player_panel/hud_element_personal_player_panel_definitions"
local HudElementPersonalPlayerPanelSettings = require("scripts/ui/hud/elements/personal_player_panel/hud_element_personal_player_panel_settings")
local HudElementPersonalPlayerPanel = class("HudElementPersonalPlayerPanel", "HudElementPlayerPanelBase")

HudElementPersonalPlayerPanel.init = function (self, parent, draw_layer, start_scale, data)
	HudElementPersonalPlayerPanel.super.init(self, parent, draw_layer, start_scale, data, definition_path, HudElementPersonalPlayerPanelSettings)
end

HudElementPersonalPlayerPanel.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPersonalPlayerPanel.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementPersonalPlayerPanel.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPersonalPlayerPanel.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

return HudElementPersonalPlayerPanel
