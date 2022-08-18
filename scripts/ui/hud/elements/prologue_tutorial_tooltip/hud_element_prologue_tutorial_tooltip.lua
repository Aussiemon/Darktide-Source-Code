local Definitions = require("scripts/ui/hud/elements/prologue_tutorial_tooltip/hud_element_prologue_tutorial_tooltip_definitions")
local HudElementPrologueTutorialTooltipSettings = require("scripts/ui/hud/elements/prologue_tutorial_tooltip/hud_element_prologue_tutorial_tooltip_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local InputUtils = require("scripts/managers/input/input_utils")
local HudElementPrologueTooltipPopup = class("HudElementPrologueTooltipPopup", "HudElementBase")

HudElementPrologueTooltipPopup.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementPrologueTooltipPopup.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._active = false
	self._player = parent:player()
	self._ui_renderer = parent._ui_renderer
	self._popup_queue = {}

	self:_register_events()

	self._gamepad_active = Managers.input:device_in_use("gamepad")
	self._currently_displayed_actions = nil
end

HudElementPrologueTooltipPopup.destroy = function (self)
	self:_unregister_events()
	HudElementPrologueTooltipPopup.super.destroy(self)
end

HudElementPrologueTooltipPopup.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPrologueTooltipPopup.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._popup_animation_id and not self:_is_animation_active(self._popup_animation_id) then
		self._popup_animation_id = nil

		if #self._popup_queue > 0 then
			if self._active then
				self:_hide_message()
			else
				local area_data = table.remove(self._popup_queue, #self._popup_queue)
				local actions = area_data.actions
				self._currently_displayed_actions = actions

				self:_present_new_tooltip(actions)
			end
		end
	end

	if self._gamepad_active ~= Managers.input:device_in_use("gamepad") and self._active and self._currently_displayed_actions then
		self._gamepad_active = Managers.input:device_in_use("gamepad")

		self:_set_widget_info(self._currently_displayed_actions)
	end
end

HudElementPrologueTooltipPopup.event_player_display_prologue_tutorial_tooltip = function (self, player, actions)
	if not self._player or self._player ~= player then
		return
	end

	self._currently_displayed_actions = actions

	if self._popup_animation_id or self._active then
		if self._popup_animation_id == nil then
			self:_hide_message()
		end

		table.insert(self._popup_queue, 1, {
			actions = actions
		})
	else
		self:_present_new_tooltip(actions)
	end
end

HudElementPrologueTooltipPopup.event_player_hide_prologue_tutorial_tooltip = function (self, player)
	if not self._player or self._player ~= player then
		return
	end

	if self._active and self._popup_animation_id == nil then
		self:_hide_message()
	end
end

HudElementPrologueTooltipPopup._present_new_tooltip = function (self, actions)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.tooltip

	self:_set_widget_info(actions, widget)
	self:_play_sound(UISoundEvents.prologue_tutorial_message_enter)

	self._popup_animation_id = self:_start_animation("popup_enter", widget)
	self._active = true
end

HudElementPrologueTooltipPopup._set_widget_info = function (self, actions, widget)
	if table.is_empty(actions) then
		return
	end

	local widget = widget or self._widgets_by_name.tooltip
	local content = widget.content
	local service_type = "Ingame"
	local text = ""

	for i = 1, #actions do
		local action_info = actions[i]
		local loc_action = Localize(action_info.action)
		local action_text = loc_action .. ": "
		local input_string = ""
		local inputs = action_info.inputs
		local is_combo = action_info.is_combo or false
		local type_override = action_info.type_override or false

		for j = 1, #inputs do
			local alias_key = Managers.ui:get_input_alias_key(inputs[j], service_type)
			local action_type = Managers.ui:get_action_type(inputs[j], service_type)
			local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

			if type_override and action_type ~= "held" then
				input_text = "[" .. Localize("loc_input_hold") .. "]" .. input_text
			elseif not type_override and action_type == "held" then
				input_text = "[" .. Localize("loc_input_hold") .. "]" .. input_text
			end

			if is_combo then
				input_string = j ~= 1 and input_string .. " + " .. input_text or input_text
			else
				input_string = j ~= 1 and input_string .. ", " .. input_text or input_text
			end

			if i ~= 1 then
				text = text .. "\n" .. action_text .. input_string
			else
				text = action_text .. input_string
			end
		end
	end

	content.input_text = text
end

HudElementPrologueTooltipPopup._hide_message = function (self)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.tooltip

	self:_play_sound(UISoundEvents.prologue_tutorial_message_exit)

	self._popup_animation_id = self:_start_animation("popup_exit", widget)
	self._active = false
end

HudElementPrologueTooltipPopup._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._popup_animation_id and not self._active then
		return
	end

	HudElementPrologueTooltipPopup.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

HudElementPrologueTooltipPopup._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPrologueTutorialTooltipSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementPrologueTooltipPopup._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPrologueTutorialTooltipSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

return HudElementPrologueTooltipPopup
