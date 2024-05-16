-- chunkname: @scripts/ui/hud/elements/mission_objective_popup/hud_element_mission_objective_popup.lua

local Definitions = require("scripts/ui/hud/elements/mission_objective_popup/hud_element_mission_objective_popup_definitions")
local HudElementMissionObjectivePopupSettings = require("scripts/ui/hud/elements/mission_objective_popup/hud_element_mission_objective_popup_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local HudElementMissionObjectivePopup = class("HudElementMissionObjectivePopup", "HudElementBase")

HudElementMissionObjectivePopup.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementMissionObjectivePopup.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
	self._popup_queue = {}

	self:_register_events()
end

HudElementMissionObjectivePopup.destroy = function (self, ui_renderer)
	self:_unregister_events()
	HudElementMissionObjectivePopup.super.destroy(self, ui_renderer)
end

HudElementMissionObjectivePopup.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._popup_animation_id and not self:_is_animation_active(self._popup_animation_id) then
		self._popup_animation_id = nil
		self._active_popup_widget = nil

		if #self._popup_queue > 0 then
			local popup_data = table.remove(self._popup_queue, #self._popup_queue)

			self:_present_popup(popup_data)
		end
	end

	HudElementMissionObjectivePopup.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementMissionObjectivePopup._present_popup = function (self, popup_data)
	if self._popup_animation_id then
		self:_stop_animation(self._popup_animation_id)

		self._popup_animation_id = nil
	end

	local widget = popup_data.widget
	local title_text = popup_data.title_text
	local description_text = popup_data.description_text
	local update_text = popup_data.update_text

	if update_text then
		description_text = description_text .. "\n" .. update_text
	end

	if title_text and description_text then
		self:_setup_mission_popup_texts(widget, title_text, description_text)
	end

	local icon = popup_data.icon

	if icon then
		widget.content.icon = icon
	end

	local sound_event = popup_data.sound_event

	if sound_event then
		self:_play_sound(sound_event)
	end

	self._active_popup_widget = widget

	local animation_event = popup_data.animation_event
	local popup_animation_id = self:_start_animation(animation_event, widget)

	self._popup_animation_id = popup_animation_id
end

HudElementMissionObjectivePopup._can_present_mission = function (self, mission_name)
	local mission_objective = self._mission_objective_system:get_active_objective(mission_name)

	if mission_objective and mission_objective:use_hud() then
		return true
	end

	return false
end

HudElementMissionObjectivePopup.event_mission_objective_start = function (self, mission_name)
	if not self:_can_present_mission(mission_name) then
		return
	end

	local mission_objective = self._mission_objective_system:get_active_objective(mission_name)
	local description_text = mission_objective:header()
	local icon = mission_objective:icon()
	local title_text = self:_localize("loc_hud_mission_objective_popup_title_start")
	local widget = self._widgets_by_name.mission_popup
	local popup_data = {
		animation_event = "popup_start",
		widget = widget,
		title_text = title_text,
		description_text = description_text,
		icon = icon,
		sound_event = UISoundEvents.mission_objective_popup_new,
	}

	if self._popup_animation_id then
		table.insert(self._popup_queue, 1, popup_data)
	else
		self:_present_popup(popup_data)
	end
end

HudElementMissionObjectivePopup.event_mission_objective_update = function (self, mission_name)
	if not self:_can_present_mission(mission_name) then
		return
	end

	local mission_objective = self._mission_objective_system:get_active_objective(mission_name)
	local show_progression_popup_on_update = mission_objective:show_progression_popup_on_update()

	if not show_progression_popup_on_update then
		return
	end

	local max_counter_amount = mission_objective:max_incremented_progression()

	if max_counter_amount == 0 then
		return
	end

	local current_counter_amount = mission_objective:incremented_progression()
	local update_text

	if current_counter_amount and max_counter_amount then
		update_text = tostring(current_counter_amount) .. "/" .. tostring(max_counter_amount)
	end

	local description_text = mission_objective:header()
	local icon = mission_objective:icon()
	local title_text = self:_localize("loc_hud_mission_objective_popup_title_update")
	local widget = self._widgets_by_name.mission_popup
	local popup_data = {
		animation_event = "popup_start",
		widget = widget,
		title_text = title_text,
		description_text = description_text,
		update_text = update_text,
		icon = icon,
		sound_event = UISoundEvents.mission_objective_popup_part_complete,
	}

	if self._popup_animation_id then
		table.insert(self._popup_queue, 1, popup_data)
	else
		self:_present_popup(popup_data)
	end
end

HudElementMissionObjectivePopup.event_mission_objective_complete = function (self, mission_name)
	if not self:_can_present_mission(mission_name) then
		return
	end

	local mission_objective = self._mission_objective_system:get_active_objective(mission_name)
	local description_text = mission_objective:header()
	local icon = mission_objective:icon()
	local title_text = self:_localize("loc_hud_mission_objective_popup_title_complete")
	local widget = self._widgets_by_name.mission_popup
	local popup_data = {
		animation_event = "popup_start",
		widget = widget,
		title_text = title_text,
		description_text = description_text,
		icon = icon,
		sound_event = UISoundEvents.mission_objective_popup_complete,
	}

	if self._popup_animation_id then
		table.insert(self._popup_queue, 1, popup_data)
	else
		self:_present_popup(popup_data)
	end
end

HudElementMissionObjectivePopup._setup_mission_update_texts = function (self, widget, update_text)
	local parent = self._parent
	local ui_renderer = parent:ui_renderer()
	local content = widget.content

	content.update_text = update_text

	local style = widget.style
	local icon_style = style.icon
	local update_text_style = style.update_text
	local text_size = update_text_style.size
	local text_options = UIFonts.get_font_options_by_style(update_text_style)
	local text_width, _, _, _ = UIRenderer.text_size(ui_renderer, update_text, update_text_style.font_type, update_text_style.font_size, text_size, text_options)
	local icon_width = icon_style.size[1]
	local spacing = 5
	local total_width = text_width + icon_width + spacing

	update_text_style.offset[1] = icon_width + text_width * 0.5 + spacing - total_width * 0.5
	icon_style.offset[1] = icon_width * 0.5 - total_width * 0.5
end

HudElementMissionObjectivePopup._setup_mission_popup_texts = function (self, widget, title_text, description_text)
	local parent = self._parent
	local ui_renderer = parent:ui_renderer()
	local content = widget.content
	local style = widget.style
	local description_text_style = style.description_text

	content.title_text = title_text
	content.description_text = description_text

	local text_size = description_text_style.size
	local text_options = UIFonts.get_font_options_by_style(description_text_style)
	local _, height, _, _ = UIRenderer.text_size(ui_renderer, description_text, description_text_style.font_type, description_text_style.font_size, text_size, text_options)
end

HudElementMissionObjectivePopup._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._active_popup_widget then
		return
	end

	UIWidget.draw(self._active_popup_widget, ui_renderer)
end

HudElementMissionObjectivePopup._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementMissionObjectivePopupSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementMissionObjectivePopup._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementMissionObjectivePopupSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

return HudElementMissionObjectivePopup
