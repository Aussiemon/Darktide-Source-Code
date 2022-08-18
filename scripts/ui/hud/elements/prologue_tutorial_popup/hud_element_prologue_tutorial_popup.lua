local Definitions = require("scripts/ui/hud/elements/prologue_tutorial_popup/hud_element_prologue_tutorial_popup_definitions")
local HudElementPrologueTutorialPopupSettings = require("scripts/ui/hud/elements/prologue_tutorial_popup/hud_element_prologue_tutorial_popup_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local HudElementPrologueTutorialPopup = class("HudElementPrologueTutorialPopup", "HudElementBase")

HudElementPrologueTutorialPopup.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementPrologueTutorialPopup.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._active = false
	self._player = parent:player()
	self._popup_queue = {}

	self:_register_events()
end

HudElementPrologueTutorialPopup.destroy = function (self)
	self:_unregister_events()
	HudElementPrologueTutorialPopup.super.destroy(self)
end

HudElementPrologueTutorialPopup.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPrologueTutorialPopup.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._popup_animation_id and not self:_is_animation_active(self._popup_animation_id) then
		self._popup_animation_id = nil

		if #self._popup_queue > 0 then
			if self._active then
				self:_hide_message()
			else
				local area_data = table.remove(self._popup_queue, #self._popup_queue)
				local title_text = area_data.title_text
				local description_text = area_data.description_text

				self:_present_new_message(title_text, description_text)
			end
		end
	end
end

HudElementPrologueTutorialPopup.event_player_display_prologue_tutorial_message = function (self, player, title_text, description_text)
	if not self._player or self._player ~= player then
		return
	end

	if self._popup_animation_id or self._active then
		if self._popup_animation_id == nil then
			self:_hide_message()
		end

		table.insert(self._popup_queue, 1, {
			title_text = title_text,
			description_text = description_text
		})
	else
		self:_present_new_message(title_text, description_text)
	end
end

HudElementPrologueTutorialPopup.event_player_hide_prologue_tutorial_message = function (self, player)
	if not self._player or self._player ~= player then
		return
	end

	if self._active and self._popup_animation_id == nil then
		self:_hide_message()
	end
end

HudElementPrologueTutorialPopup._present_new_message = function (self, title_text, description_text)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.popup
	local content = widget.content

	self:_play_sound(UISoundEvents.prologue_tutorial_message_enter)

	self._active = true
end

HudElementPrologueTutorialPopup._hide_message = function (self)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.popup

	self:_play_sound(UISoundEvents.prologue_tutorial_message_exit)

	self._popup_animation_id = self:_start_animation("popup_exit", widget)
	self._active = false
end

HudElementPrologueTutorialPopup._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._popup_animation_id and not self._active then
		return
	end

	HudElementPrologueTutorialPopup.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

HudElementPrologueTutorialPopup._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPrologueTutorialPopupSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementPrologueTutorialPopup._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPrologueTutorialPopupSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

return HudElementPrologueTutorialPopup
