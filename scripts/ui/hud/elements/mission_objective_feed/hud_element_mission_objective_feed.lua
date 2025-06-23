-- chunkname: @scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed.lua

local Definitions = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_definitions")
local HudElementMissionObjective = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective")
local HudElementMissionObjectiveFeedSettings = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local TextUtilities = require("scripts/utilities/ui/text")
local HudElementMissionObjectiveFeed = class("HudElementMissionObjectiveFeed", "HudElementBase")

HudElementMissionObjectiveFeed.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementMissionObjectiveFeed.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._objective_widgets_by_name = {}
	self._hud_objectives = {}
	self._hud_objectives_names_array = {}
	self._mission_widget_definitions = Definitions.objective_definitions
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
	self._scan_delay = HudElementMissionObjectiveFeedSettings.scan_delay
	self._scan_delay_duration = 0
	self._objective_widgets_counter = 0
	self._event_objectives_to_add = {}

	self:_set_background_visibility(false)
	self:_register_events()
end

HudElementMissionObjectiveFeed.destroy = function (self, ui_renderer)
	self:_unregister_events()
	HudElementMissionObjectiveFeed.super.destroy(self, ui_renderer)
end

HudElementMissionObjectiveFeed.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._scan_delay_duration > 0 then
		self._scan_delay_duration = self._scan_delay_duration - dt
	else
		self:_mission_objectives_scan(ui_renderer)

		self._scan_delay_duration = self._scan_delay
	end

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
	0
}

HudElementMissionObjectiveFeed._update_widgets = function (self, dt, t)
	for objective_name, hud_objective in pairs(self._hud_objectives) do
		if self:has_widget(objective_name) then
			local widget = self._widgets_by_name[objective_name]
			local content = widget.content
			local ui_state = hud_objective:state()

			if ui_state == "alert" then
				local neutral_color = HudElementMissionObjectiveFeedSettings.colors_by_category.default.bar
				local lerp = math.sin(t * 10) / 2 + 0.5

				ALERT_COLOR[2] = math.lerp(neutral_color[2], 255, lerp)
				ALERT_COLOR[3] = math.lerp(neutral_color[3], 151, lerp)
				ALERT_COLOR[4] = math.lerp(neutral_color[4], 29, lerp)

				local style = widget.style

				if content.show_bar then
					style.bar.color = ALERT_COLOR
				end

				if content.show_timer then
					style.timer_text.text_color = ALERT_COLOR
				end
			end

			if content.show_timer then
				self:_update_timer_progress(hud_objective, dt)
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

		self:_add_objective(objective, ui_renderer, locally_added)
	end

	local hud_objectives = self._hud_objectives
	local active_objectives = self._mission_objective_system:active_objectives()

	for objective_name, hud_objective in pairs(hud_objectives) do
		local active_objective = active_objectives[objective_name]
		local locally_added = hud_objective:locally_added()
		local should_show = locally_added or active_objective and active_objective:use_hud()

		if should_show then
			if not locally_added and not hud_objective:is_synchronized_with_objective(active_objective) then
				hud_objective:synchronize_objective(active_objective)

				local widget = self._widgets_by_name[objective_name]

				if widget then
					self:_update_widget_height(widget, active_objective, hud_objective, ui_renderer)
					self:_synchronize_widget_with_hud_objective(objective_name)
					self:_align_objective_widgets()
				end
			end

			hud_objective:update_markers()
		else
			self:_remove_objective(objective_name)
		end
	end

	for objective_name, objective in pairs(active_objectives) do
		local hud_objective_exists = hud_objectives[objective_name] ~= nil

		if not hud_objective_exists and objective:use_hud() then
			self:_add_objective(objective, ui_renderer)
		end
	end
end

HudElementMissionObjectiveFeed.event_add_objective = function (self, objective, locally_added, on_add_callback)
	self._event_objectives_to_add[#self._event_objectives_to_add + 1] = {
		objective = objective,
		locally_added = locally_added,
		on_add_callback = on_add_callback
	}
end

HudElementMissionObjectiveFeed._add_objective = function (self, objective, ui_renderer, locally_added)
	local objective_name = objective:name()
	local new_hud_objective = HudElementMissionObjective:new(objective)

	self._hud_objectives_names_array[#self._hud_objectives_names_array + 1] = objective_name
	self._hud_objectives[objective_name] = new_hud_objective

	if objective:hide_widget() then
		return
	end

	self._objective_widgets_counter = self._objective_widgets_counter + 1

	local objective_category = objective:objective_category()
	local mission_widget_definition = self._mission_widget_definitions[objective_category]
	local widget = self:_create_widget(objective_name, mission_widget_definition)

	self._objective_widgets_by_name[objective_name] = widget

	self:_synchronize_widget_with_hud_objective(objective_name)
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
			1000
		}
		local text_options = UIFonts.get_font_options_by_style(header_text_style)
		local _, text_height = UIRenderer.text_size(ui_renderer, header_text, header_text_style.font_type, header_text_style.font_size, text_size, text_options)
		local header_height = text_height + 5

		if hud_objective:progress_bar() then
			local bar_height = style.bar.size[2] + 5
			local text_y_offset_adjustment = -(bar_height / 2)

			if content.show_alert then
				text_y_offset_adjustment = text_y_offset_adjustment + 50
			end

			header_text_style.offset[2] = header_text_style.default_offset[2] + text_y_offset_adjustment

			local bar_y_offset_adjustment = header_height / 2

			style.bar.offset[2] = style.bar.default_offset[2] + bar_y_offset_adjustment
			style.bar_background.offset[2] = style.bar_background.default_offset[2] + bar_y_offset_adjustment
			style.bar_icon.offset[2] = style.bar_icon.default_offset[2] + bar_y_offset_adjustment
			header_height = header_height + bar_height + 10
		end

		widget_height = widget_height + math.max(header_size[2], header_height)
	else
		widget_height = content.size[2]
	end

	local widget_padding_by_category = HudElementMissionObjectiveFeedSettings.widget_padding_by_category

	widget_height = widget_height + (widget_padding_by_category[objective_category] or 0)

	if content.show_alert then
		widget_height = widget_height + style.alert_background.size[2]
	end

	if content.category == "overarching" then
		widget_height = widget_height + 20
	end

	content.size[2] = widget_height
end

HudElementMissionObjectiveFeed._remove_objective = function (self, objective_name)
	if self._hud_objectives[objective_name] then
		self._hud_objectives[objective_name]:delete()

		self._hud_objectives[objective_name] = nil

		local array_index = table.find(self._hud_objectives_names_array, objective_name)

		if array_index then
			table.remove(self._hud_objectives_names_array, array_index)
		end

		if self._objective_widgets_by_name[objective_name] then
			self:_unregister_widget_name(objective_name)

			self._objective_widgets_by_name[objective_name] = nil
			self._objective_widgets_counter = self._objective_widgets_counter - 1

			self:_align_objective_widgets()
		end
	else
		local event_objectives_to_add = self._event_objectives_to_add

		for i = 1, #event_objectives_to_add do
			local objective_data = event_objectives_to_add[i]
			local objective = objective_data.objective

			if objective:name() == objective_name then
				table.remove(event_objectives_to_add, i)

				return
			end
		end
	end
end

HudElementMissionObjectiveFeed._synchronize_widget_with_hud_objective = function (self, objective_name)
	local widget = self._widgets_by_name[objective_name]
	local hud_objective = self._hud_objectives[objective_name]
	local content = widget.content
	local style = widget.style
	local state = hud_objective:state()
	local objective_category = hud_objective:objective_category()

	content.header_text = hud_objective:header()
	content.description_text = hud_objective:description()
	content.category = objective_category

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

	if hud_objective:progress_bar() then
		content.show_bar = true
		content.bar_icon = hud_objective:progress_bar_icon()

		self:_update_bar_progress(hud_objective)
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

		self:_update_timer_progress(hud_objective, nil, realign)
	else
		content.max_counter_amount = nil
		content.show_timer = false
		content.show_minutes = false
		content.show_hours = false
		content.timer_text = ""
	end

	if objective_category == "overarching" then
		local alert = state == "alert"

		content.show_alert = alert

		if alert then
			style.hazard_above.color = HudElementMissionObjectiveFeedSettings.alert_color
		else
			style.hazard_above.color = style.hazard_above.base_color
		end
	else
		content.show_alert = false
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

HudElementMissionObjectiveFeed._update_bar_progress = function (self, hud_objective)
	local objective_name = hud_objective:objective_name()
	local widget = self._widgets_by_name[objective_name]
	local style = widget.style
	local bar_style = style.bar
	local icon_style = style.bar_icon
	local progression = hud_objective:has_second_progression() and hud_objective:second_progression() or hud_objective:progression()
	local default_length = bar_style.default_length

	bar_style.size[1] = default_length * progression
	icon_style.offset[1] = 40 + default_length * progression
end

HudElementMissionObjectiveFeed._update_timer_progress = function (self, hud_objective, dt, realign)
	local objective_name = hud_objective:objective_name()
	local widget = self._widgets_by_name[objective_name]
	local content = widget.content
	local show_minutes = content.show_minutes
	local show_hours = content.show_hours
	local time_left = math.max(hud_objective:time_left(dt), 0)
	local text

	if show_hours then
		local use_short = true
		local allow_skip = false
		local max_detail

		text = TextUtilities.format_time_span_localized(time_left, use_short, allow_skip, max_detail)
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
			40
		}
		local ui_renderer = self._parent:ui_renderer()
		local width = self:_text_size_for_style(ui_renderer, realignment_text, text_style, optional_size)

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
	local objective_widgets_by_name = self._objective_widgets_by_name
	local total_background_height = 0
	local objectives_counter = self._objective_widgets_counter
	local index_counter = 0
	local hud_objectives = self._hud_objectives

	local function mission_objective_sort_function(a, b)
		local a_objective = hud_objectives[a]
		local b_objective = hud_objectives[b]
		local a_priority = a_objective:sort_order() or entry_order_by_objective_category[a_objective:objective_category()]
		local b_priority = b_objective:sort_order() or entry_order_by_objective_category[b_objective:objective_category()]

		if a_priority == b_priority then
			return false
		elseif b_priority < a_priority then
			return false
		end

		return true
	end

	local hud_objectives_names_array = self._hud_objectives_names_array

	if #hud_objectives_names_array > 1 then
		table.sort(hud_objectives_names_array, mission_objective_sort_function)
	end

	for i = 1, #hud_objectives_names_array do
		local objective_name = hud_objectives_names_array[i]
		local widget = objective_widgets_by_name[objective_name]

		if widget then
			local hud_objective = hud_objectives[objective_name]
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
end

HudElementMissionObjectiveFeed._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._objective_widgets_counter > 0 then
		HudElementMissionObjectiveFeed.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

		local objective_widgets_by_name = self._objective_widgets_by_name

		if objective_widgets_by_name then
			for _, widget in pairs(objective_widgets_by_name) do
				UIWidget.draw(widget, ui_renderer)
			end
		end
	end
end

return HudElementMissionObjectiveFeed
