local Definitions = require("scripts/ui/hud/elements/prologue_tutorial_sequence_transition_end/hud_element_prologue_tutorial_sequence_transition_end_definitions")
local Settings = require("scripts/ui/hud/elements/prologue_tutorial_sequence_transition_end/hud_element_prologue_tutorial_sequence_transition_end_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Text = require("scripts/utilities/ui/text")
local HudElementPrologueTutorialSequenceTransitionEnd = class("HudElementPrologueTutorialSequenceTransitionEnd", "HudElementBase")

HudElementPrologueTutorialSequenceTransitionEnd.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementPrologueTutorialSequenceTransitionEnd.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._active = false

	self:_register_events()
end

HudElementPrologueTutorialSequenceTransitionEnd.show_transition_popup = function (self)
	self._active = true
	local widget = self._widgets_by_name.text
	local content = widget.content
	content.transition_text = Text.localize_to_upper(Settings.transition_text)

	self:_start_animation("fade_in", self._widgets_by_name)
end

HudElementPrologueTutorialSequenceTransitionEnd.hide_transition_popup = function (self)
	self._fade_out_anim_id = self:_start_animation("fade_out", self._widgets_by_name)
end

HudElementPrologueTutorialSequenceTransitionEnd.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPrologueTutorialSequenceTransitionEnd.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._fade_out_anim_id and self._ui_sequence_animator:is_animation_completed(self._fade_out_anim_id) then
		self._active = false
		self._fade_out_anim_id = nil
	end
end

HudElementPrologueTutorialSequenceTransitionEnd._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._active then
		return
	end

	local widgets_by_name = self._widgets_by_name

	for _, widget in pairs(widgets_by_name) do
		UIWidget.draw(widget, ui_renderer)
	end
end

HudElementPrologueTutorialSequenceTransitionEnd.destroy = function (self, ui_renderer)
	HudElementPrologueTutorialSequenceTransitionEnd.super.destroy(self, ui_renderer)
	self:_unregister_events()
end

HudElementPrologueTutorialSequenceTransitionEnd._register_events = function (self)
	local event_manager = Managers.event
	local events = Settings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementPrologueTutorialSequenceTransitionEnd._unregister_events = function (self)
	local event_manager = Managers.event
	local events = Settings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

return HudElementPrologueTutorialSequenceTransitionEnd
