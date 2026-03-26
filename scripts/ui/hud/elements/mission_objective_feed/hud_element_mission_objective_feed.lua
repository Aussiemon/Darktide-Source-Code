-- chunkname: @scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed.lua

local ColorUtilities = require("scripts/utilities/ui/colors")
local Definitions = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_definitions")
local HudElementMissionObjective = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective")
local HudElementMissionObjectiveFeedSettings = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Text = require("scripts/utilities/ui/text")
local MissionObjectiveGoal = require("scripts/extension_systems/mission_objective/utilities/mission_objective_goal")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local HudElementMissionObjectiveFeed = class("HudElementMissionObjectiveFeed", "HudElementBase")

HudElementMissionObjectiveFeed.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementMissionObjectiveFeed.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._hud_objective_id_counter = 0
	self._hud_objectives = {}
	self._hud_objectives_sorted = {}
	self._objective_widgets = {}
	self._mission_widget_definitions = Definitions.objective_definitions
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
	self._scan_delay = HudElementMissionObjectiveFeedSettings.scan_delay
	self._scan_delay_duration = 0
	self._objective_widgets_counter = 0
	self._event_objectives_to_add = {}
	self._live_event_id = nil
	self._live_event_widgets = {}
	self._live_event_widgets_counter = 0
	self._hazard_stripes_active = false

	self:_set_live_event_visible(false)
	self:_set_background_visibility(false)
	self:_register_events()
end

HudElementMissionObjectiveFeed.destroy = function (self, ui_renderer)
	self:_clear_live_event_widgets()
	self:_unregister_events()
	HudElementMissionObjectiveFeed.super.destroy(self, ui_renderer)
end

HudElementMissionObjectiveFeed._clear_live_event_widgets = function (self)
	while self._live_event_widgets_counter > 0 do
		self:_pop_live_event_widget()
	end
end

HudElementMissionObjectiveFeed._set_live_event_visible = function (self, visible)
	self._widgets_by_name.live_event_background.content.visible = visible
	self._widgets_by_name.live_event_icon.content.visible = visible
end

HudElementMissionObjectiveFeed._update_live_event = function (self, force, ui_renderer)
	local live_event_id = Managers.live_event:active_event_id()

	if not force and self._live_event_id == live_event_id then
		return
	end

	self._live_event_id = live_event_id

	self:_clear_live_event_widgets()
	self:_set_live_event_visible(false)

	local game_mode = Managers.state.game_mode:game_mode_name()
	local is_hub = game_mode == "hub"
	local show_in_mission = game_mode == "coop_complete_objective" and GameParameters.show_live_event_objective_in_adventure
	local is_visible = live_event_id ~= nil and (is_hub or show_in_mission)

	if not is_visible then
		return
	end

	local live_event_template = Managers.live_event:get_event_template(live_event_id)
	local live_event_objective = live_event_template.objective

	if not live_event_objective then
		return
	end

	local widgets = live_event_objective.widgets
	local widget_count = widgets and #widgets or 0

	for i = 1, widget_count do
		local widget_data = widgets[i]

		self:_push_live_event_widget(widget_data.template, widget_data.context, ui_renderer)
	end

	self:_set_live_event_visible(widget_count > 0)
end

HudElementMissionObjectiveFeed._create_local_objective = function (self, objective_name, objective_type, sort_order)
	objective_type = objective_type or "default"

	local objective_data = {
		locally_added = true,
		marker_type = "hub_objective",
		name = objective_name,
		objective_category = objective_type,
		hud_sort_order = sort_order,
	}
	local objective = MissionObjectiveGoal:new()

	objective:start_objective(objective_data)

	return objective
end

HudElementMissionObjectiveFeed._overaching_state = function (self)
	local state = "default"
	local hazard_stripes = false
	local hud_objectives = self._hud_objectives

	for objective, hud_objective in pairs(hud_objectives) do
		local ui_state = hud_objective:state()
		local category = hud_objective:objective_category()

		if category == "overarching" and objective:use_hud() then
			hazard_stripes = true

			if ui_state == "alert" or ui_state == "critical" then
				state = ui_state

				break
			end
		end
	end

	return state, hazard_stripes
end

HudElementMissionObjectiveFeed._update_hazard_stripes_and_alert = function (self, ui_renderer)
	if DEDICATED_SERVER then
		return
	end

	local objective_widgets = self._objective_widgets
	local state, hazard_stripes = self:_overaching_state()
	local in_altered_state = state == "alert" or state == "critical"

	if in_altered_state and not self._alert_objective_info then
		self._alert_objective_info = self:_create_local_objective("alert_info", "alert_info", 100)

		self:_add_objective(self._alert_objective_info, ui_renderer, true)
	elseif not in_altered_state and self._alert_objective_info then
		self:_remove_objective(self._alert_objective_info)
		self._alert_objective_info:destroy()

		self._alert_objective_info = nil
	end

	if self._hazard_stripes_active ~= hazard_stripes then
		self._hazard_stripes_active = hazard_stripes

		if hazard_stripes then
			self._hazard_objective_top = self:_create_local_objective("hazard_top", "warning", -10)

			self:_add_objective(self._hazard_objective_top, ui_renderer, true)

			self._hazard_objective_bottom = self:_create_local_objective("hazard_bottom", "warning", -1)

			self:_add_objective(self._hazard_objective_bottom, ui_renderer, true)
		else
			self:_remove_objective(self._hazard_objective_top)
			self._hazard_objective_top:destroy()

			self._hazard_objective_top = nil

			self:_remove_objective(self._hazard_objective_bottom)
			self._hazard_objective_bottom:destroy()

			self._hazard_objective_bottom = nil
		end
	end

	if self._active_state ~= state then
		self._active_state = state

		local background_widget = self._widgets_by_name.background

		for _, pass_style in pairs(background_widget.style) do
			local default_color = pass_style.default_color or pass_style.base_color
			local alert_color = pass_style.alert_color
			local critical_color = pass_style.critical_color or HudElementMissionObjectiveFeedSettings.critical_color

			if default_color and alert_color and critical_color then
				if state == "alert" then
					pass_style.color = alert_color
				elseif state == "critical" then
					pass_style.color = critical_color
				else
					pass_style.color = default_color
				end
			end
		end

		if self._hazard_objective_top then
			local widget = objective_widgets[self._hazard_objective_top]

			widget.style.hazard_above.material_values.speed = in_altered_state and 1 or 0
		end

		if self._hazard_objective_bottom then
			local widget = objective_widgets[self._hazard_objective_bottom]

			widget.style.hazard_above.material_values.speed = in_altered_state and 1 or 0
		end

		local colors_by_category = HudElementMissionObjectiveFeedSettings.colors_by_category

		for objective, hud_objective in pairs(self._hud_objectives) do
			local locally_added = hud_objective:locally_added()

			if locally_added then
				local objective_category = hud_objective:objective_category()

				if in_altered_state then
					objective_category = state
				end

				local widget = objective_widgets[objective]

				if widget then
					local style = widget.style
					local content = widget.content
					local category_colors = colors_by_category[objective_category]

					for style_id, color in pairs(category_colors) do
						local pass_style = style[style_id]

						if pass_style and (pass_style.text_color or pass_style.color) then
							ColorUtilities.color_copy(color, pass_style.text_color or pass_style.color, true)
						end
					end
				end
			else
				local objective_category = hud_objective:objective_category()

				if in_altered_state then
					objective_category = state
				end

				if self._alert_objective_info then
					local widget = objective_widgets[self._alert_objective_info]

					if widget then
						local style = widget.style
						local content = widget.content
						local alert_message_by_state = HudElementMissionObjectiveFeedSettings.alert_text_by_state
						local state_message = alert_message_by_state and alert_message_by_state[state] or ""

						content.warning_text = state_message ~= "" and Utf8.upper(Localize(state_message)) or ""

						local color_by_state = HudElementMissionObjectiveFeedSettings.color_by_state
						local state_colors = color_by_state and color_by_state[state] or category_colors.default

						if style.warning_background then
							ColorUtilities.color_copy(state_colors.body, style.warning_background.color, true)
						end

						if style.warning_text then
							local text_color = state_colors.text or state_colors.body

							ColorUtilities.color_copy(text_color, style.warning_text.text_color, true)
						end
					end
				end
			end
		end
	end

	return in_altered_state
end

HudElementMissionObjectiveFeed.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._scan_delay_duration > 0 then
		self._scan_delay_duration = self._scan_delay_duration - dt
	else
		self:_mission_objectives_scan(ui_renderer)

		self._scan_delay_duration = self._scan_delay
	end

	self:_update_live_event(false, ui_renderer)
	self:_update_hazard_stripes_and_alert(ui_renderer)

	if self._objective_widgets_counter > 0 then
		self:_update_widgets(dt, t)

		if not self._background_visible then
			self:_set_background_visibility(true)
		end
	elseif self._background_visible then
		self:_set_background_visibility(false)
	end

	return HudElementMissionObjectiveFeed.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

local ALERT_COLOR = {
	255,
	0,
	0,
	0,
}

HudElementMissionObjectiveFeed._update_widgets = function (self, dt, t)
	local objective_widgets = self._objective_widgets

	for objective, hud_objective in pairs(self._hud_objectives) do
		local widget = objective_widgets[objective]

		if widget then
			local content = widget.content
			local ui_state = hud_objective:state()

			content.ui_state = ui_state

			if ui_state == "alert" then
				local style = widget.style
				local neutral_color = HudElementMissionObjectiveFeedSettings.colors_by_category.default.bar
				local alert_color = style.bar.alert_color or HudElementMissionObjectiveFeedSettings.alert_color
				local lerp = math.sin(t * 10) / 2 + 0.5

				ALERT_COLOR[2] = math.lerp(neutral_color[2], alert_color[2], lerp)
				ALERT_COLOR[3] = math.lerp(neutral_color[3], alert_color[3], lerp)
				ALERT_COLOR[4] = math.lerp(neutral_color[4], alert_color[4], lerp)

				if content.show_bar then
					style.bar.color = ALERT_COLOR
				end

				if content.show_timer then
					style.timer_text.text_color = ALERT_COLOR
				end
			end

			if content.show_timer then
				self:_update_timer_progress(hud_objective, widget, dt)
			end
		end
	end
end

HudElementMissionObjectiveFeed._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementMissionObjectiveFeedSettings.events

	for event_name, function_name in pairs(events) do
		event_manager:register(self, event_name, function_name)
	end
end

HudElementMissionObjectiveFeed._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementMissionObjectiveFeedSettings.events

	for event_name, function_name in pairs(events) do
		event_manager:unregister(self, event_name)
	end
end

HudElementMissionObjectiveFeed._set_background_visibility = function (self, visible)
	self._background_visible = visible
	self._widgets_by_name.background.content.visible = visible
end

HudElementMissionObjectiveFeed._mission_objectives_scan = function (self, ui_renderer)
	local event_objectives_to_add = self._event_objectives_to_add

	for i = #event_objectives_to_add, 1, -1 do
		local objective_data = table.remove(event_objectives_to_add, i)
		local objective = objective_data.objective
		local locally_added = objective_data.locally_added
		local should_show = locally_added or objective and objective:use_hud()

		if should_show then
			self:_add_objective(objective, ui_renderer, locally_added)
		end
	end

	local hud_objectives = self._hud_objectives
	local objective_widgets = self._objective_widgets

	for objective, hud_objective in pairs(hud_objectives) do
		local locally_added = hud_objective:locally_added()
		local should_show = locally_added or objective and objective:use_hud()

		if should_show then
			if not locally_added and not hud_objective:is_synchronized_with_objective() then
				hud_objective:synchronize_objective()

				local widget = objective_widgets[objective]

				if widget then
					self:_update_widget_height(widget, objective, hud_objective, ui_renderer)
					self:_synchronize_widget_with_hud_objective(objective)
					self:_align_objective_widgets()
				end
			end

			hud_objective:update_markers()
		else
			self:_remove_objective(objective)
		end
	end

	local active_objectives = self._mission_objective_system:active_objectives()

	for objective, _ in pairs(active_objectives) do
		local hud_objective_exists = hud_objectives[objective] ~= nil

		if not hud_objective_exists and objective:use_hud() then
			self:_add_objective(objective, ui_renderer)
		end
	end
end

HudElementMissionObjectiveFeed.event_add_objective = function (self, objective, locally_added, on_add_callback)
	self._event_objectives_to_add[#self._event_objectives_to_add + 1] = {
		objective = objective,
		locally_added = locally_added,
		on_add_callback = on_add_callback,
	}
end

HudElementMissionObjectiveFeed._add_objective = function (self, objective, ui_renderer, locally_added)
	self._hud_objective_id_counter = self._hud_objective_id_counter + 1

	local new_hud_objective = HudElementMissionObjective:new(objective, self._hud_objective_id_counter)

	self._hud_objectives[objective] = new_hud_objective
	self._hud_objectives_sorted[#self._hud_objectives_sorted + 1] = new_hud_objective

	if objective:hide_widget() then
		return
	end

	local objective_category = objective:objective_category()
	local mission_widget_definition = self._mission_widget_definitions[objective_category]
	local widget_name = objective:group_id() .. "-" .. objective:name()
	local widget = self:_create_widget(widget_name, mission_widget_definition)

	self._objective_widgets[objective] = widget
	self._objective_widgets_counter = self._objective_widgets_counter + 1

	self:_synchronize_widget_with_hud_objective(objective)
	self:_update_widget_height(widget, objective, new_hud_objective, ui_renderer)
	self:_align_objective_widgets()
end

HudElementMissionObjectiveFeed._update_widget_height = function (self, widget, objective, hud_objective, ui_renderer)
	local content = widget.content
	local style = widget.style
	local header_text = hud_objective:header()
	local header_text_style = style.header_text
	local objective_category = objective:objective_category()
	local widget_height = 0

	if header_text_style then
		local header_size = HudElementMissionObjectiveFeedSettings.header_size
		local text_size = {
			header_text_style.size[1],
			1000,
		}
		local _, text_height = self:_text_size(ui_renderer, header_text, header_text_style, text_size)
		local required_players = hud_objective:required_players() and hud_objective:required_players() > 0
		local header_height = text_height + 5

		if hud_objective:progress_bar() then
			header_height = header_height + (required_players and 5 or 0)

			local bar_height = style.bar.size[2] + 5
			local text_y_offset_adjustment = -(bar_height / 2)

			header_text_style.offset[2] = header_text_style.default_offset[2] + text_y_offset_adjustment

			local bar_y_offset_adjustment = header_height / 2

			style.bar.offset[2] = style.bar.default_offset[2] + bar_y_offset_adjustment
			style.bar_background.offset[2] = style.bar_background.default_offset[2] + bar_y_offset_adjustment
			style.bar_icon.offset[2] = style.bar_icon.default_offset[2] + bar_y_offset_adjustment

			if required_players and style.objective_progress_indicators and style.objective_progress_indicators_background then
				style.objective_progress_indicators.offset[2] = style.bar.offset[2] + style.bar.size[2] + 5
				style.objective_progress_indicators_background.offset[2] = style.bar.offset[2] + style.bar.size[2] + 5
			end

			header_height = header_height + bar_height + 10
		end

		if required_players and content.alert_text and style.alert_text then
			local player_count_alert_text = content.alert_text
			local _, player_count_alert_text_height = self:_text_size(ui_renderer, player_count_alert_text, style.alert_text, text_size)

			header_height = header_height + player_count_alert_text_height + 12
		end

		widget_height = widget_height + math.max(header_size[2], header_height)
	else
		widget_height = content.size[2]
	end

	local widget_padding_by_category = HudElementMissionObjectiveFeedSettings.widget_padding_by_category

	widget_height = widget_height + (widget_padding_by_category[objective_category] or 0)
	widget_height = widget_height + hud_objective:additional_height()
	content.size[2] = widget_height
end

HudElementMissionObjectiveFeed._remove_objective = function (self, objective)
	if self._hud_objectives[objective] then
		local array_index = table.find(self._hud_objectives_sorted, self._hud_objectives[objective])

		if array_index then
			table.remove(self._hud_objectives_sorted, array_index)
		end

		self._hud_objectives[objective]:delete()

		self._hud_objectives[objective] = nil

		if self._objective_widgets[objective] then
			local widget_name = objective:group_id() .. "-" .. objective:name()

			self:_unregister_widget_name(widget_name)

			self._objective_widgets[objective] = nil
			self._objective_widgets_counter = self._objective_widgets_counter - 1

			self:_align_objective_widgets()
		end
	else
		local event_objectives_to_add = self._event_objectives_to_add

		for i = 1, #event_objectives_to_add do
			local objective_data = event_objectives_to_add[i]

			if objective == objective_data.objective then
				table.remove(event_objectives_to_add, i)

				return
			end
		end
	end
end

HudElementMissionObjectiveFeed._synchronize_widget_with_hud_objective = function (self, objective)
	local widget = self._objective_widgets[objective]
	local hud_objective = self._hud_objectives[objective]
	local content = widget.content
	local style = widget.style
	local state = hud_objective:state()
	local objective_category = hud_objective:objective_category()

	content.header_text = hud_objective:header()
	content.description_text = hud_objective:description()
	content.category = objective_category

	if content.alert_text and content.alert_text == "" then
		content.alert_text = hud_objective:alert_text()
	end

	local icon = hud_objective:icon()

	if icon then
		content.icon = hud_objective:icon()
	end

	if hud_objective:use_counter() then
		local max_increment_hidden = hud_objective:max_increment_hidden()
		local current_amount = hud_objective:current_counter_amount()
		local max_amount = hud_objective:max_counter_amount()

		if max_increment_hidden then
			content.counter_text = tostring(current_amount)
		else
			content.counter_text = tostring(current_amount) .. "/" .. tostring(max_amount)
		end
	else
		content.counter_text = ""
	end

	local required_players = hud_objective:required_players()

	content.objective_require_players = required_players and required_players > 0

	if required_players and required_players > 0 then
		local available_players = hud_objective:available_players()

		content.available_players = available_players
		content.required_players = required_players
	end

	if hud_objective:progress_bar() then
		content.show_bar = true
		content.bar_icon = hud_objective:progress_bar_icon()

		self:_update_bar_progress(hud_objective, widget)
	else
		content.show_bar = false
	end

	if hud_objective:progress_timer() then
		local max_counter_amount = hud_objective:max_counter_amount()
		local minutes = math.floor(max_counter_amount / 60 % 60)
		local show_minutes = minutes > 0
		local show_hours = minutes > 60
		local realign = show_hours

		if content.max_counter_amount ~= max_counter_amount then
			content.max_counter_amount = max_counter_amount
			content.show_minutes = show_minutes
			content.show_hours = show_hours
			content.show_timer = true
			realign = true
		end

		if content.show_timer then
			content.icon = "content/ui/materials/hud/interactions/icons/time"
		end

		self:_update_timer_progress(hud_objective, widget, nil, realign)
	else
		content.max_counter_amount = nil
		content.show_timer = false
		content.show_minutes = false
		content.show_hours = false
		content.timer_text = ""
	end

	if required_players and required_players > 0 and style.player_icons_required then
		style.player_icons_required.amount = required_players
	end

	local colors_by_category = HudElementMissionObjectiveFeedSettings.colors_by_category
	local size_by_category = HudElementMissionObjectiveFeedSettings.size_by_category
	local offsets_by_category = HudElementMissionObjectiveFeedSettings.offsets_by_category
	local category_colors = colors_by_category[objective_category]
	local category_sizes = size_by_category[objective_category]
	local category_offsets = offsets_by_category[objective_category]

	for style_id, color in pairs(category_colors) do
		local pass_style = style[style_id]

		if pass_style and (pass_style.text_color or pass_style.color) then
			ColorUtilities.color_copy(color, pass_style.text_color or pass_style.color)
		end
	end

	for style_id, size in pairs(category_sizes) do
		local pass_style = style[style_id]

		if pass_style and (pass_style.font_size or pass_style.size) then
			if pass_style.font_size then
				pass_style.font_size = size
			else
				pass_style.size = size
			end
		end
	end

	for style_id, offset in pairs(category_offsets) do
		local pass_style = style[style_id]

		if pass_style and pass_style.offset then
			pass_style.offset = offset
		end
	end
end

HudElementMissionObjectiveFeed._update_bar_progress = function (self, hud_objective, widget)
	local style = widget.style
	local bar_style = style.bar
	local icon_style = style.bar_icon
	local progression = hud_objective:has_second_progression() and hud_objective:second_progression() or hud_objective:progression()
	local default_length = bar_style.default_length

	bar_style.size[1] = default_length * progression
	icon_style.offset[1] = 40 + default_length * progression
end

HudElementMissionObjectiveFeed._update_timer_progress = function (self, hud_objective, widget, dt, realign)
	local content = widget.content
	local show_minutes = content.show_minutes
	local show_hours = content.show_hours
	local time_left = math.max(hud_objective:time_left(dt), 0)
	local text

	if show_hours then
		local use_short = true
		local allow_skip = false
		local max_detail

		text = Text.format_time_span_localized(time_left, use_short, allow_skip, max_detail)
	elseif show_minutes then
		local millis = math.floor(time_left % 1 * 100)

		text = string.format("%.2d:%.2d:%.2d", time_left / 60 % 60, time_left % 60, millis)
	else
		local millis = math.floor(time_left % 1 * 100)

		text = string.format("%.2d:%.2d", time_left % 60, millis)
	end

	if realign then
		local realignment_text

		if show_hours then
			realignment_text = text
		else
			realignment_text = show_minutes and "00:00:00" or "00:00"
		end

		local style = widget.style
		local text_style = style.timer_text
		local optional_size = {
			500,
			40,
		}
		local ui_renderer = self._parent:ui_renderer()
		local width = self:_text_size(ui_renderer, realignment_text, text_style, optional_size)

		text_style.offset[1] = text_style.default_offset[1] - width
	end

	content.timer_text = text
end

HudElementMissionObjectiveFeed._get_objectives_height = function (self, widget, ui_renderer)
	local widget_height = widget.content.size[2]

	return widget_height
end

HudElementMissionObjectiveFeed._align_objective_widgets = function (self)
	local ui_renderer = self._parent:ui_renderer()
	local entry_spacing_by_category = HudElementMissionObjectiveFeedSettings.entry_spacing_by_category
	local entry_order_by_objective_category = HudElementMissionObjectiveFeedSettings.entry_order_by_objective_category
	local offset_y = 0
	local objective_widgets = self._objective_widgets
	local total_background_height = 0
	local index_counter = 0
	local hud_objectives_sorted = self._hud_objectives_sorted
	local objectives_counter = #hud_objectives_sorted

	local function mission_objective_sort_function(a_objective, b_objective)
		local a_priority = a_objective:sort_order() or entry_order_by_objective_category[a_objective:objective_category()]
		local b_priority = b_objective:sort_order() or entry_order_by_objective_category[b_objective:objective_category()]

		if a_priority == b_priority then
			return a_objective:id() < b_objective:id()
		elseif b_priority < a_priority then
			return false
		end

		return true
	end

	if #hud_objectives_sorted > 1 then
		table.sort(hud_objectives_sorted, mission_objective_sort_function)
	end

	for i = 1, #hud_objectives_sorted do
		local hud_objective = hud_objectives_sorted[i]
		local objective = hud_objective:objective()
		local widget = objective_widgets[objective]

		if widget then
			local objective_category = hud_objective:objective_category()
			local entry_spacing = entry_spacing_by_category[objective_category] or entry_spacing_by_category.default

			index_counter = index_counter + 1

			local widget_offset = widget.offset

			widget_offset[2] = offset_y

			local widget_height = self:_get_objectives_height(widget, ui_renderer)

			offset_y = offset_y + widget_height + entry_spacing
			total_background_height = total_background_height + widget_height

			if index_counter < objectives_counter then
				total_background_height = total_background_height + entry_spacing
			end
		end
	end

	local background_scenegraph_id = "background"

	self:_set_scenegraph_size(background_scenegraph_id, nil, total_background_height)
	self:set_scenegraph_position("live_event_background", nil, total_background_height + (total_background_height > 0 and 10 or 0))
end

HudElementMissionObjectiveFeed._get_live_event_widget_name = function (self, index)
	return string.format("live_event_%d", index)
end

HudElementMissionObjectiveFeed._update_live_event_size = function (self)
	local total_height = 4

	for i = 1, self._live_event_widgets_counter do
		local widget = self._live_event_widgets[i]

		widget.offset = {
			0,
			total_height,
			0,
		}
		total_height = total_height + widget.content.size[2] + 6
	end

	total_height = total_height + 4

	self:_set_scenegraph_size("live_event_background", nil, total_height)
end

HudElementMissionObjectiveFeed._push_live_event_widget = function (self, template_name, context, ui_renderer)
	local widget_definition = Definitions.live_event_definition[template_name]

	self._live_event_widgets_counter = self._live_event_widgets_counter + 1
	self._live_event_widgets[self._live_event_widgets_counter] = self:_create_widget(self:_get_live_event_widget_name(self._live_event_widgets_counter), widget_definition)

	for key, value in pairs(widget_definition) do
		if type(value) == "function" then
			self._live_event_widgets[self._live_event_widgets_counter][key] = value
		end
	end

	self._live_event_widgets[self._live_event_widgets_counter]:init(context, ui_renderer)
end

HudElementMissionObjectiveFeed._pop_live_event_widget = function (self)
	local widget = self._live_event_widgets[self._live_event_widgets_counter]

	widget:destroy()
	self:_unregister_widget_name(self:_get_live_event_widget_name(self._live_event_widgets_counter))

	self._live_event_widgets[self._live_event_widgets_counter] = nil
	self._live_event_widgets_counter = self._live_event_widgets_counter - 1
end

HudElementMissionObjectiveFeed._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	HudElementMissionObjectiveFeed.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	if self._objective_widgets_counter > 0 then
		local objective_widgets = self._objective_widgets

		if objective_widgets then
			for _, widget in pairs(objective_widgets) do
				UIWidget.draw(widget, ui_renderer)
			end
		end
	end

	self:_update_live_event_size()

	for _, widget in ipairs(self._live_event_widgets) do
		UIWidget.draw(widget, ui_renderer)
	end
end

return HudElementMissionObjectiveFeed
