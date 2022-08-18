local Definitions = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_definitions")
local HudElementTacticalOverlaySettings = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_settings")
local HudElementTacticalOverlay = class("HudElementTacticalOverlay", "HudElementBase")

HudElementTacticalOverlay.init = function (self, parent, draw_layer, start_scale)
	HudElementTacticalOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)
end

HudElementTacticalOverlay.destroy = function (self)
	HudElementTacticalOverlay.super.destroy(self)
end

HudElementTacticalOverlay.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementTacticalOverlay.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local service_type = "Ingame"
	input_service = Managers.input:get_input_service(service_type)
	local active = false

	if input_service:get("tactical_overlay_hold") then
		active = true
	end

	if active and not self._active then
		Managers.event:trigger("event_set_tactical_overlay_state", true)
	elseif self._active and not active then
		Managers.event:trigger("event_set_tactical_overlay_state", false)
	end

	self._active = active

	self:_update_visibility(dt)
end

HudElementTacticalOverlay._update_visibility = function (self, dt)
	local draw = self._active
	local alpha_speed = 4
	local alpha_multiplier = self._alpha_multiplier or 0

	if draw then
		alpha_multiplier = math.min(alpha_multiplier + dt * alpha_speed, 1)
	else
		alpha_multiplier = math.max(alpha_multiplier - dt * alpha_speed, 0)
	end

	self._alpha_multiplier = alpha_multiplier
end

HudElementTacticalOverlay._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._alpha_multiplier ~= 0 then
		local alpha_multiplier = render_settings.alpha_multiplier
		render_settings.alpha_multiplier = self._alpha_multiplier

		HudElementTacticalOverlay.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

		render_settings.alpha_multiplier = alpha_multiplier
	end
end

return HudElementTacticalOverlay
