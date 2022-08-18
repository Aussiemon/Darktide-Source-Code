local Definitions = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_definitions")
local HudElementMissionObjective = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective")
local HudElementMissionObjectiveFeedSettings = require("scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ColorUtilities = require("scripts/utilities/ui/colors")
local HudElementMissionObjectiveFeed = class("HudElementMissionObjectiveFeed", "HudElementBase")

HudElementMissionObjectiveFeed.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementMissionObjectiveFeed.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._objective_widgets_by_name = {}
	self._hud_objectives = {}
	self._mission_widget_definition = Definitions.objective_definition
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
	self._scan_delay = HudElementMissionObjectiveFeedSettings.scan_delay
	self._scan_delay_duration = 0
	self._objectives_counter = 0

	self:_set_background_visibility(false)
	self:_register_events()
end

HudElementMissionObjectiveFeed.destroy = function (self)
	self:_unregister_events()
	HudElementMissionObjectiveFeed.super.destroy(self)
end

HudElementMissionObjectiveFeed.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._scan_delay_duration > 0 then
		self._scan_delay_duration = self._scan_delay_duration - dt
	else
		self:_mission_objectives_scan()

		self._scan_delay_duration = self._scan_delay
	end

	if self._objectives_counter > 0 then
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

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementMissionObjectiveFeed._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementMissionObjectiveFeedSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

HudElementMissionObjectiveFeed._set_background_visibility = function (self, visible)
	self._background_visible = visible
	self._widgets_by_name.background.content.visible = visible
end

HudElementMissionObjectiveFeed._mission_objectives_scan = function (self)
	local hud_objectives = self._hud_objectives
	local active_objectives = self._mission_objective_system:get_active_objectives()

	for objective_name, hud_objective in pairs(hud_objectives) do
		local active_objective = active_objectives[objective_name]
		local should_show = active_objective and active_objective:use_hud()

		if should_show then
			if not hud_objective:is_synchronized_with_objective(active_objective) then
				hud_objective:synchronize_objective(active_objective)
				self:_synchronize_widget_with_hud_objective(objective_name)
			end

			hud_objective:update_markers()
		else
			self:_remove_objective(objective_name)
		end
	end

	for objective_name, objective in pairs(active_objectives) do
		local hud_objective_exists = hud_objectives[objective_name] ~= nil

		if not hud_objective_exists and objective:use_hud() then
			self:_add_objective(objective_name)
		end
	end
end

HudElementMissionObjectiveFeed._add_objective = function (self, objective_name)
	fassert(self._hud_objectives[objective_name] == nil, "[HudElementMissionObjectiveFeed][_add_objective] HUD Objective already created.")

	local objective = self._mission_objective_system:get_active_objective(objective_name)

	fassert(objective, "[HudElementMissionObjectiveFeed][_add_objective] Objective not valid.")

	local new_hud_objective = HudElementMissionObjective:new(objective)
	self._hud_objectives[objective_name] = new_hud_objective
	self._objectives_counter = self._objectives_counter + 1
	local widget = self:_create_widget(objective_name, self._mission_widget_definition)
	self._objective_widgets_by_name[objective_name] = widget

	self:_synchronize_widget_with_hud_objective(objective_name)
end

HudElementMissionObjectiveFeed._remove_objective = function (self, objective_name)
	self._objective_widgets_by_name[objective_name] = nil

	self:_unregister_widget_name(objective_name)
	self._hud_objectives[objective_name]:delete()

	self._hud_objectives[objective_name] = nil
	self._objectives_counter = self._objectives_counter - 1

	self:_align_objective_widgets()
end

HudElementMissionObjectiveFeed._synchronize_widget_with_hud_objective = function (self, objective_name)
	fassert(self:has_widget(objective_name), "[HudElementMissionObjectiveFeed][_setup_widget] No widget.")
	fassert(self._hud_objectives[objective_name], "[HudElementMissionObjectiveFeed][_setup_widget] No HUD objective.")

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
	local mission_colors = nil

	if hud_objective:is_side_mission() then
		mission_colors = colors_by_mission_type.side_mission
	else
		mission_colors = colors_by_mission_type.default
	end

	for style_id, color in pairs(mission_colors) do
		local pass_style = style[style_id]

		if pass_style and pass_style.text_color then
			ColorUtilities.color_copy(color, pass_style.text_color)
		end
	end

	self:_align_objective_widgets()
end

HudElementMissionObjectiveFeed._update_bar_progress = function (self, hud_objective)
	local objective_name = hud_objective:objective_name()

	fassert(self:has_widget(objective_name), "[HudElementMissionObjectiveFeed][_update_bar_progress] No widget.")

	local widget = self._widgets_by_name[objective_name]
	local style = widget.style
	local bar_style = style.bar
	local progression = hud_objective:has_second_progression() and hud_objective:second_progression() or hud_objective:progression()
	local bar_default_size = bar_style.default_size
	bar_style.size[1] = bar_default_size[1] * progression
end

HudElementMissionObjectiveFeed._get_objectives_height = function (self, widget, ui_renderer)
	local header_size = HudElementMissionObjectiveFeedSettings.header_size
	local content = widget.content
	local style = widget.style
	local show_bar = content.show_bar
	local bar_height = show_bar and style.bar.size[2] or 0

	return header_size[2] + bar_height * 2
end

HudElementMissionObjectiveFeed._align_objective_widgets = function (self)
	local ui_renderer = self._parent:ui_renderer()
	local entry_spacing = HudElementMissionObjectiveFeedSettings.entry_spacing
	local offset_y = 0
	local objective_widgets_by_name = self._objective_widgets_by_name
	local total_background_height = 0
	local objectives_counter = self._objectives_counter
	local index_counter = 0

	for _, widget in pairs(objective_widgets_by_name) do
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

	local background_scenegraph_id = "background"

	self:_set_scenegraph_size(background_scenegraph_id, nil, total_background_height + 10)
end

HudElementMissionObjectiveFeed._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._objectives_counter > 0 then
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
