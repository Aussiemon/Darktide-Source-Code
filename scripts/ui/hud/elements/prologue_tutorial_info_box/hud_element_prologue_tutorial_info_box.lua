-- chunkname: @scripts/ui/hud/elements/prologue_tutorial_info_box/hud_element_prologue_tutorial_info_box.lua

local Definitions = require("scripts/ui/hud/elements/prologue_tutorial_info_box/hud_element_prologue_tutorial_info_box_definitions")
local HudElementPrologueTutorialInfoBoxSettings = require("scripts/ui/hud/elements/prologue_tutorial_info_box/hud_element_prologue_tutorial_info_box_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local TrainingGroundsSoundEvents = require("scripts/settings/training_grounds/training_grounds_sound_events")
local Vo = require("scripts/utilities/vo")
local InputUtils = require("scripts/managers/input/input_utils")
local InputDevice = require("scripts/managers/input/input_device")
local TextUtils = require("scripts/utilities/ui/text")
local HudElementPrologueTutorialInfoBox = class("HudElementPrologueTutorialInfoBox", "HudElementBase")
local info_box_settings = HudElementPrologueTutorialInfoBoxSettings
local devices = info_box_settings.devices
local NUM_ENTRY_SLOTS = 4

HudElementPrologueTutorialInfoBox.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementPrologueTutorialInfoBox.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._active = false
	self._player = parent:player()
	self._ui_renderer = parent._ui_renderer
	self._popup_queue = {}
	self._info_box_height = 0
	self._close_action_name = nil
	self._use_ingame_input = false
	self._ingame_input_service = Managers.input:get_input_service("Ingame")
	self._previous_keys_info = {}
	self._ui_manager = Managers.ui
	self._input_manager = Managers.input
	self._current_info_data = {}
	self._current_objectives = {}
	self._clearing_widgets = {}
	self._entry_widgets = {}
	self._last_index = nil
	self._using_gamepad = InputDevice.gamepad_active

	self:_register_events()
end

HudElementPrologueTutorialInfoBox.destroy = function (self, ui_renderer)
	self:_unregister_events()
	HudElementPrologueTutorialInfoBox.super.destroy(self, ui_renderer)
end

HudElementPrologueTutorialInfoBox.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._close_action_name then
		if self._use_ingame_input then
			input_service = self._ingame_input_service
		end

		if input_service:get(self._close_action_name) then
			Level.trigger_event(Managers.state.mission:mission_level(), "prologue_tutorial_message_skipped")
			self:event_player_hide_prologue_tutorial_info_box(self._player)
		end
	end

	if self._popup_animation_id and not self:_is_animation_active(self._popup_animation_id) then
		self._popup_animation_id = nil

		if #self._popup_queue > 0 then
			if self._active then
				self:event_player_hide_prologue_tutorial_info_box(self._player)
			else
				local area_data = table.remove(self._popup_queue, #self._popup_queue)
				local info_data = area_data.info_data

				self:_present_new_info_box(info_data)

				self._current_info_data = info_data
			end
		end
	end

	if self._remove_all_anim_id and self._ui_sequence_animator:is_animation_completed(self._remove_all_anim_id) then
		self:_clear_objectives()
	end

	if self:_should_update_input(self._current_info_data) then
		self:_set_widget_info(self._current_info_data)
	end

	if InputDevice.gamepad_active ~= self._using_gamepad then
		self._using_gamepad = InputDevice.gamepad_active

		if not table.is_empty(self._current_info_data) then
			self:_set_widget_info(self._current_info_data)
		end
	end

	HudElementPrologueTutorialInfoBox.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementPrologueTutorialInfoBox.event_player_display_prologue_tutorial_info_box = function (self, player, info_data)
	if not self._player or self._player ~= player then
		return
	end

	info_data = table.clone(info_data)

	if self._popup_animation_id or self._active then
		if self._popup_animation_id == nil then
			self:event_player_hide_prologue_tutorial_info_box(player)
		end

		table.insert(self._popup_queue, 1, {
			info_data = info_data
		})
	else
		self:_present_new_info_box(info_data)

		self._current_info_data = info_data
	end
end

HudElementPrologueTutorialInfoBox.event_player_hide_prologue_tutorial_info_box = function (self, player)
	if not self._player or self._player ~= player then
		return
	end

	if self._active and self._popup_animation_id == nil then
		self:_hide_info()
	end
end

HudElementPrologueTutorialInfoBox._validate_info_data = function (self, info_data)
	if table.is_empty(info_data) then
		return false
	end

	if not info_data.title or not info_data.description then
		return false
	end

	return true
end

HudElementPrologueTutorialInfoBox._present_new_info_box = function (self, info_data)
	local valid_data = self:_validate_info_data(info_data)

	if not valid_data then
		return
	end

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.info_widget

	self:_set_widget_info(info_data)
	self:_set_objectives_info(info_data)
	self:_play_sound(UISoundEvents.prologue_tutorial_message_enter)

	self._popup_animation_id = self:_start_animation("popup_enter", widget)
	self._active = true
end

HudElementPrologueTutorialInfoBox._should_update_input = function (self, info_data)
	if not info_data or not info_data.input_descriptions then
		return false
	end

	if InputDevice.gamepad_active then
		return false
	end

	local input_descriptions = info_data.input_descriptions
	local service_type = "Ingame"
	local alias = self._input_manager:alias_object(service_type)

	if alias then
		local index = 1

		for _, input_info in pairs(input_descriptions) do
			local input_action = input_info.input_action

			if type(input_action) == "table" then
				input_action = input_action.keyboard
			end

			local alias_name = self._ui_manager:get_input_alias_key(input_action, service_type)
			local current_key_info = alias:get_keys_for_alias(alias_name, devices)

			if current_key_info ~= self._previous_keys_info[index] then
				return true
			end

			index = index + 1
		end
	end

	return false
end

HudElementPrologueTutorialInfoBox._get_input_description_text = function (self, info_data)
	if not info_data.input_descriptions then
		return ""
	end

	local input_description_text = ""
	local input_actions = info_data.input_descriptions

	for _, action in ipairs(input_actions) do
		local description = action.description
		local input_action = action.input_action

		if type(input_action) == "table" then
			input_action = InputDevice.gamepad_active and input_action.controller or input_action.keyboard
		end

		local service_type = "Ingame"
		local include_input_type = true
		local end_of_line = #input_actions ~= 1 and "\n" or ""

		input_description_text = input_description_text .. TextUtils.localize_with_button_hint(input_action, description, nil, service_type, Localize("loc_input_legend_text_template"), include_input_type) .. end_of_line

		local alias = self._input_manager:alias_object(service_type)
		local alias_name = self._ui_manager:get_input_alias_key(input_action, service_type)
		local key_info = alias:get_keys_for_alias(alias_name, devices)

		self._previous_keys_info[#self._previous_keys_info + 1] = key_info
	end

	return input_description_text
end

HudElementPrologueTutorialInfoBox._set_widget_info = function (self, info_data)
	local widget = self._widgets_by_name.info_widget
	local content = widget.content

	content.title_text = Utf8.upper(Localize(info_data.title))
	content.description_text = Localize(info_data.description, true)
	self._close_action_name = info_data.close_action
	self._use_ingame_input = info_data.use_ingame_input

	local input_description_text = self:_get_input_description_text(info_data)

	content.input_description_text = input_description_text

	self:_set_widget_size_from_content(info_data.description, info_data.title, input_description_text)
end

HudElementPrologueTutorialInfoBox._set_objectives_info = function (self, info_data)
	if info_data.objectives then
		for i, objective in ipairs(info_data.objectives) do
			self:_create_entry(objective.objective_id, objective.name, objective.max_value, i)

			self._current_objectives[objective.objective_id] = objective

			self:_start_animation("add_entry", self._entry_widgets[objective.objective_id])

			if objective.play_sound then
				Managers.ui:play_2d_sound(TrainingGroundsSoundEvents.tg_objective_new)
				Vo.mission_giver_vo_event("training_ground_psyker_a", "mission_info", objective.objective_id)
			end
		end
	end
end

HudElementPrologueTutorialInfoBox._hide_info = function (self)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.info_widget

	self:_play_sound(UISoundEvents.prologue_tutorial_message_exit)

	self._popup_animation_id = self:_start_animation("popup_exit", widget)

	table.clear(self._previous_keys_info)
	table.clear(self._current_info_data)

	self._active = false
end

HudElementPrologueTutorialInfoBox._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._popup_animation_id and not self._active and table.is_empty(self._entry_widgets) then
		return
	end

	HudElementPrologueTutorialInfoBox.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
	self:_draw_entry_widgets(ui_renderer)
end

HudElementPrologueTutorialInfoBox._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPrologueTutorialInfoBoxSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementPrologueTutorialInfoBox._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPrologueTutorialInfoBoxSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

HudElementPrologueTutorialInfoBox._set_widget_size_from_content = function (self, description, title_text, input_description_text)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.info_widget
	local description_loc_text = Localize(description, true)
	local style = widget.style
	local base_offset = 20
	local base_width = 450
	local background_width = info_box_settings.info_box_background_size[1]
	local description_width = info_box_settings.info_box_description_text_size[1]
	local title_text_x_offset = 25
	local title_text_default_size = style.title_text.size
	local title_text_loc = Utf8.upper(Localize(title_text))
	local title_text_width, title_text_height = UIRenderer.text_size(self._ui_renderer, title_text_loc, style.title_text.font_type, style.title_text.font_size, title_text_default_size)
	local total_title_text_width = title_text_x_offset + title_text_width + 45
	local base_height = base_offset + title_text_height + 20

	if total_title_text_width > base_width - title_text_x_offset then
		background_width = total_title_text_width
		description_width = total_title_text_width - 50
	end

	style.description_text.size[1] = description_width

	local default_description_size = style.description_text.size
	local _, text_height, _, _ = UIRenderer.text_size(self._ui_renderer, description_loc_text, style.description_text.font_type, style.description_text.font_size, default_description_size)
	local description_text_height = text_height
	local total_height = base_height + description_text_height

	if input_description_text ~= "" then
		local default_input_description_size = style.input_description_text.size
		local _, input_text_height, _, _ = UIRenderer.text_size(self._ui_renderer, input_description_text, style.input_description_text.font_type, style.input_description_text.font_size, default_input_description_size)
		local input_description_text_height = input_text_height * 1.2
		local input_description_width = info_box_settings.info_box_input_description_size[1]

		style.input_description_text.size = {
			input_description_width,
			input_description_text_height
		}

		local offset_y = total_height + 35

		style.input_description_text.offset[2] = offset_y
		total_height = total_height + input_description_text_height
	end

	local height_adjust = 60

	total_height = total_height + height_adjust
	self._info_box_height = total_height

	self:_set_scenegraph_size("background", background_width, total_height)

	style.description_text.size = {
		description_width,
		description_text_height
	}
end

HudElementPrologueTutorialInfoBox._get_first_available_slot = function (self)
	if #self._entry_widgets == 0 then
		return 1
	end

	local unavailable_slots = {}

	for i = 1, #self._entry_widgets do
		local widget = self._entry_widgets[i]
		local index = widget.content.index

		unavailable_slots[#unavailable_slots + 1] = index
	end

	for i = 1, NUM_ENTRY_SLOTS do
		if not table.find(unavailable_slots, i) then
			return i
		end
	end
end

HudElementPrologueTutorialInfoBox.event_player_add_objective_tracker = function (self, objective)
	if table.is_empty(objective) or self._current_objectives[objective.objective_id] then
		return
	end

	local index = self._last_index and self._last_index + 1 or self:_get_first_available_slot()

	self:_create_entry(objective.objective_id, objective.name, objective.max_value, index)

	self._current_objectives[objective.objective_id] = objective

	self:_start_animation("add_entry", self._entry_widgets[objective.objective_id])
end

HudElementPrologueTutorialInfoBox._create_entry = function (self, objective_id, name, max_value, index)
	local widget_name = objective_id
	local scenegraph_id = "entry_pivot_" .. index
	local y_offset = self._info_box_height + 25 + 60 * (index - 1)

	self:set_scenegraph_position(scenegraph_id, 0, y_offset, 5)

	local definition = Definitions.create_entry_widget(scenegraph_id)
	local entry_widgets = self._entry_widgets
	local widget = UIWidget.init(widget_name, definition)

	entry_widgets[widget_name] = widget
	widget.dirty = true

	local content = widget.content
	local style = widget.style
	local current_value = 0
	local max_value = max_value
	local counter_string = string.format(Localize("loc_objective_counter"), current_value, max_value)

	content.counter_text = counter_string

	local entry_text = Localize(name)

	content.entry_text = entry_text

	local default_size = info_box_settings.tracker_entry_size
	local entry_text_width = UIRenderer.text_size(self._ui_renderer, entry_text, style.entry_text.font_type, style.entry_text.font_size, default_size)
	local entry_text_x_offset = 50
	local total_text_width = entry_text_x_offset + entry_text_width + 25

	if total_text_width > 400 - entry_text_x_offset then
		style.entry_text.size[1] = total_text_width + 25
		style.frame.size[1] = total_text_width + 25
	else
		style.entry_text.size[1] = total_text_width
		style.frame.size[1] = 400
	end

	content.index = index
	self._last_index = index
end

HudElementPrologueTutorialInfoBox.event_player_update_objectives_tracker = function (self, objective_id, current_value)
	if not self._entry_widgets[objective_id] then
		return
	end

	local widget = self._entry_widgets[objective_id]
	local objective_data = self._current_objectives[objective_id]
	local max_value = objective_data.max_value

	if max_value < current_value then
		return
	end

	local content = widget.content
	local text = string.format(Localize("loc_objective_counter"), current_value, max_value)

	content.counter_text = text

	if current_value == max_value then
		self:_start_animation("complete_entry", widget)
	else
		self:_start_animation("uptick_entry", widget)
	end
end

HudElementPrologueTutorialInfoBox.event_player_remove_objective = function (self, objective_id)
	table.clear(self._entry_widgets)

	local objective = self._current_objectives[objective_id]

	if objective then
		table.swap_delete(self._current_objectives, objective_id)
	end

	for i = 1, #self._current_objectives do
		local objective = self._current_objectives[i]

		self:_create_entry(objective.objective_id, objective.name, objective.max_value, i)
	end

	self._last_index = #self._current_objectives
end

HudElementPrologueTutorialInfoBox.event_player_remove_current_objectives = function (self)
	for id, widget in pairs(self._entry_widgets) do
		self._clearing_widgets[id] = widget
	end

	self._remove_all_anim_id = self:_start_animation("remove_entry", self._clearing_widgets)
	self._last_index = 0
end

HudElementPrologueTutorialInfoBox._clear_objectives = function (self)
	if self._clearing_widgets then
		for id, widget in pairs(self._clearing_widgets) do
			table.swap_delete(self._current_objectives, id)
			table.swap_delete(self._entry_widgets, id)
		end

		self._clearing_widgets = {}
		self._remove_all_anim_id = nil
	end
end

HudElementPrologueTutorialInfoBox.on_objective_completed = function (self, objective_id)
	local widget = self._entry_widgets[objective_id]

	self:_start_animation("on_complete", widget)
end

HudElementPrologueTutorialInfoBox._draw_entry_widgets = function (self, ui_renderer)
	local widgets = self._entry_widgets

	for _, widget in pairs(widgets) do
		UIWidget.draw(widget, ui_renderer)
	end
end

return HudElementPrologueTutorialInfoBox
