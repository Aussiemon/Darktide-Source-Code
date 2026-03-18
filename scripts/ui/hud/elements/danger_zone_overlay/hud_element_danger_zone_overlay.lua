-- chunkname: @scripts/ui/hud/elements/danger_zone_overlay/hud_element_danger_zone_overlay.lua

local Definitions = require("scripts/ui/hud/elements/danger_zone_overlay/hud_element_danger_zone_overlay_definitions")
local HudElementDangerZoneOverlay = class("HudElementDangerZoneOverlay", "HudElementBase")

HudElementDangerZoneOverlay.init = function (self, parent, draw_layer, start_scale)
	HudElementDangerZoneOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)
end

HudElementDangerZoneOverlay._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local letterbox_height = 100

	HudElementDangerZoneOverlay.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

return HudElementDangerZoneOverlay
