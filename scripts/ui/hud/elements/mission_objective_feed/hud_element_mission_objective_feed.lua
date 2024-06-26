-- chunkname: @scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed.lua

local Definitions = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_definitions")
local HudElementMissionObjective = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective")
local HudElementMissionObjectiveFeedSettings = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local HudElementMissionObjectiveFeed = class("HudElementMissionObjectiveFeed", "HudElementBase")

HudElementMissionObjectiveFeed.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementMissionObjectiveFeed.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._objective_widgets_by_name = {}
	self._hud_objectives = {}
	self._hud_objectives_names_array = {}
	self._mission_widget_definition = Definitions.objective_definition
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
		if not self._background_visible then
			self:_set_background_visibility(true)
		end
	elseif self._background_visible then
		self:_set_background_visibility(false)
	end

	return HudElementMissionObjectiveFeed.super.update(self, dt, t, ui_renderer, render_settings, input_service)
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

				if self:has_widget(objective_name) then
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

HudElementMissionObjectiveFeed.event_add_objective = function (self, objective, locally_added)
	self._event_objectives_to_add[#self._event_objectives_to_add + 1] = {
		objective = objective,
		locally_added = locally_added,
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

	local widget = self:_create_widget(objective_name, self._mission_widget_definition)

	self._objective_widgets_by_name[objective_name] = widget

	self:_synchronize_widget_with_hud_objective(objective_name)

	local content = widget.content
	local header_text = new_hud_objective:header()
	local header_height = 0
	local header_size = HudElementMissionObjectiveFeedSettings.header_size
	local style = widget.style
	local header_text_style = style.header_text

	if header_text_style then
		local text_font_data = UIFonts.data_by_type(header_text_style.font_type)
		local text_font = text_font_data.path
		local text_size = {
			header_text_style.size[1],
			1000,
		}
		local text_options = UIFonts.get_font_options_by_style(header_text_style)
		local _, text_height = UIRenderer.text_size(ui_renderer, header_text, header_text_style.font_type, header_text_style.font_size, text_size, text_options)

		header_height = text_height + 5
	end

	local widget_height = math.max(header_size[2], header_height)

	content.size[2] = widget_height

	self:_align_objective_widgets()
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

	content.header_text = hud_objective:header()
	content.description_text = hud_objective:description()
	content.state = hud_objective:state()

	local icon = hud_objective:icon()

	if icon then
		content.icon = hud_objective:icon()
	end

	if hud_objective:use_counter() then
		local current_amount = hud_objective:current_counter_amount()
		local max_amount = hud_objective:max_counter_amount()

		content.distance_text = tostring(current_amount) .. "/" .. tostring(max_amount)
	else
		content.distance_text = ""
	end

	if hud_objective:progress_bar() then
		content.show_bar = true

		self:_update_bar_progress(hud_objective)
	else
		content.show_bar = false
	end

	local colors_by_mission_type = HudElementMissionObjectiveFeedSettings.colors_by_mission_type
	local size_by_mission_type = HudElementMissionObjectiveFeedSettings.size_by_mission_type
	local offsets_by_mission_type = HudElementMissionObjectiveFeedSettings.offsets_by_mission_type
	local mission_colors, mission_sizes, mission_offsets

	if hud_objective:is_side_mission() then
		mission_colors = colors_by_mission_type.side_mission
		mission_sizes = size_by_mission_type.side_mission
		mission_offsets = offsets_by_mission_type.side_mission
	else
		mission_colors = colors_by_mission_type.default
		mission_sizes = size_by_mission_type.default
		mission_offsets = offsets_by_mission_type.default
	end

	for style_id, color in pairs(mission_colors) do
		local pass_style = style[style_id]

		if pass_style and (pass_style.text_color or pass_style.color) then
			ColorUtilities.color_copy(color, pass_style.text_color or pass_style.color)
		end
	end

	for style_id, size in pairs(mission_sizes) do
		local pass_style = style[style_id]

		if pass_style and (pass_style.font_size or pass_style.size) then
			if pass_style.font_size then
				pass_style.font_size = size
			else
				pass_style.size = size
			end
		end
	end

	for style_id, offset in pairs(mission_offsets) do
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
	local progression = hud_objective:has_second_progression() and hud_objective:second_progression() or hud_objective:progression()
	local default_length = bar_style.default_length

	bar_style.size[1] = default_length * progression
end

HudElementMissionObjectiveFeed._get_objectives_height = function (self, widget, ui_renderer)
	local content = widget.content
	local style = widget.style
	local widget_height = widget.content.size[2]
	local show_bar = content.show_bar
	local bar_height = show_bar and style.bar.size[2] or 0

	return widget_height + bar_height * 2
end

HudElementMissionObjectiveFeed._align_objective_widgets = function (self)
	local ui_renderer = self._parent:ui_renderer()
	local entry_spacing_by_mission_type = HudElementMissionObjectiveFeedSettings.entry_spacing_by_mission_type
	local offset_y = 0
	local objective_widgets_by_name = self._objective_widgets_by_name
	local total_background_height = 0
	local objectives_counter = self._objective_widgets_counter
	local index_counter = 0
	local hud_objectives = self._hud_objectives

	local function mission_objective_sort_function(a, b)
		local a_objective = hud_objectives[a]
		local b_objective = hud_objectives[b]
		local a_is_side_mission = a_objective and a_objective:is_side_mission() or false
		local b_is_side_mission = b_objective and b_objective:is_side_mission() or false

		if a_is_side_mission == b_is_side_mission then
			return false
		elseif a_is_side_mission then
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
			local is_side_mission = hud_objective:is_side_mission()
			local entry_spacing

			if is_side_mission then
				entry_spacing = entry_spacing_by_mission_type.side_mission
			else
				entry_spacing = entry_spacing_by_mission_type.default
			end

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

	self:_set_scenegraph_size(background_scenegraph_id, nil, total_background_height + 10)
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
