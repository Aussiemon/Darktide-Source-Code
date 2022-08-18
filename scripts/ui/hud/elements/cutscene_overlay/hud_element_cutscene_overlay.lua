local Definitions = require("scripts/ui/hud/elements/cutscene_overlay/hud_element_cutscene_overlay_definitions")
local HudElementCutsceneOverlaySettings = require("scripts/ui/hud/elements/cutscene_overlay/hud_element_cutscene_overlay_settings")
local HudElementCutsceneOverlay = class("HudElementCutsceneOverlay", "HudElementBase")

HudElementCutsceneOverlay.init = function (self, parent, draw_layer, start_scale)
	HudElementCutsceneOverlay.super.init(self, parent, draw_layer, start_scale, Definitions)
end

HudElementCutsceneOverlay._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local aspect_ratio = HudElementCutsceneOverlaySettings.aspect_ratio
	local w = RESOLUTION_LOOKUP.width
	local h = RESOLUTION_LOOKUP.height
	local inverse_scale = ui_renderer.inverse_scale
	local cutscene_height = w / aspect_ratio
	local letterbox_height = (h - cutscene_height) * 0.5 * inverse_scale
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.top.style.rect.size[2] = letterbox_height
	widgets_by_name.bottom.style.rect.size[2] = letterbox_height

	HudElementCutsceneOverlay.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

return HudElementCutsceneOverlay
