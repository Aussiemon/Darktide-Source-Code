-- chunkname: @scripts/ui/hud/elements/spectator/hud_element_spectator_text.lua

local Definitions = require("scripts/ui/hud/elements/spectator/hud_element_spectator_text_definitions")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local InputUtils = require("scripts/managers/input/input_utils")
local HudElementSpectatorText = class("HudElementSpectatorText", "HudElementBase")

HudElementSpectatorText.init = function (self, parent, draw_layer, start_scale)
	HudElementSpectatorText.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._update_spectator_text = true

	self:_register_event("event_on_active_input_changed", "event_on_input_changed")
	self:_register_event("event_on_input_settings_changed", "event_on_input_changed")
end

local service_type = "Ingame"
local alias_name = "spectate_next"

HudElementSpectatorText._get_cycle_input_text = function (self)
	local color_tint_text = true
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_name, color_tint_text)

	return input_text
end

HudElementSpectatorText.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._initialized_title_background then
		local rescued_text_widget = self._widgets_by_name.rescued_text
		local rescued_text_widget_text_style = rescued_text_widget.style.text
		local rescued_text = rescued_text_widget.content.text
		local text_width, text_height = UIRenderer.text_size(ui_renderer, rescued_text, rescued_text_widget_text_style.font_type, rescued_text_widget_text_style.font_size)

		rescued_text_widget.style.background.size[1] = text_width + 60
		rescued_text_widget.style.background_overlay.size[1] = text_width + 60
		rescued_text_widget.style.background_frame.size[1] = text_width + 60
		self._initialized_title_background = true
	end

	if self._update_spectator_text then
		local player = self._parent:player()
		local name = player:name()
		local formated_name = " " .. name

		self._widgets_by_name.spectating_text.content.text = Localize("loc_spectator_mode_spectating_player", true, {
			player_name = formated_name
		})

		local input_text = self:_get_cycle_input_text()

		self._widgets_by_name.cycle_text.content.text = Localize("loc_spectator_mode_input_cycle_player", true, {
			input = input_text
		})
		self._update_spectator_text = nil
	end

	HudElementSpectatorText.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementSpectatorText.event_on_input_changed = function (self)
	self._update_spectator_text = true
end

return HudElementSpectatorText
