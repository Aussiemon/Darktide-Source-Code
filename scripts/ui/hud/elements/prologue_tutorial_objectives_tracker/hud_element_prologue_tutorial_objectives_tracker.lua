local HudElementPrologueTutorialObjectivesTrackerSettings = require("scripts/ui/hud/elements/prologue_tutorial_objectives_tracker/hud_element_prologue_tutorial_objectives_tracker_settings")
local Definitions = require("scripts/ui/hud/elements/prologue_tutorial_objectives_tracker/hud_element_prologue_tutorial_objectives_tracker_definitions")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementPrologueObjectiveTracker = class("HudElementPrologueObjectiveTracker", "HudElementBase")

HudElementPrologueObjectiveTracker.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementPrologueObjectiveTracker.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._player = parent:player()
	self._current_objectives = {}
	self._index = 1
	self._clearing_widgets = {}

	self:_register_events()
end

HudElementPrologueObjectiveTracker.destroy = function (self)
	self:_unregister_events()
	HudElementPrologueObjectiveTracker.super.destroy(self)
end

HudElementPrologueObjectiveTracker.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPrologueObjectiveTracker.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._remove_all_anim_id and self._ui_sequence_animator:is_animation_completed(self._remove_all_anim_id) then
		self:_clear_objectives()
	end
end

HudElementPrologueObjectiveTracker.event_player_add_objective_tracker = function (self, objective)
	if table.is_empty(objective) or self._current_objectives[objective.objective_id] then
		return
	end

	self:_create_entry(objective.objective_id, objective.name, objective.max_value)

	self._current_objectives[objective.objective_id] = objective

	self:_start_animation("add_entry", self._widgets_by_name[objective.objective_id])
end

HudElementPrologueObjectiveTracker._create_entry = function (self, objective_id, name, max_value)
	local widget_name = objective_id
	local y_offset = 60 * (self._index - 1)
	local offset = {
		0,
		y_offset,
		2
	}
	local definition = Definitions.create_entry_widget("entry_pivot", offset)
	local widget = self:_create_widget(widget_name, definition)
	local content = widget.content
	local current_value = 0
	local max_value = max_value
	local counter_string = string.format(Localize("loc_objective_counter"), current_value, max_value)
	content.counter_text = counter_string
	content.entry_text = Localize(name)
	self._index = self._index + 1
end

HudElementPrologueObjectiveTracker.event_player_update_objectives_tracker = function (self, objective_id, current_value)
	if not self._widgets_by_name[objective_id] then
		return
	end

	local widget = self._widgets_by_name[objective_id]
	local objective_data = self._current_objectives[objective_id]
	local max_value = objective_data.max_value

	if max_value < current_value then
		return
	end

	local content = widget.content
	local text = string.format(Localize("loc_objective_counter"), current_value, max_value)
	content.counter_text = text
end

HudElementPrologueObjectiveTracker.event_player_remove_objective = function (self, objective_id)
	table.clear(self._widgets_by_name)

	local objective = self._current_objectives[objective_id]

	if objective then
		table.swap_delete(self._current_objectives, objective_id)
	end

	self._index = 1

	for _, objective in pairs(self._current_objectives) do
		self:_create_entry(objective.objective_id, objective.name, objective.max_value)
	end
end

HudElementPrologueObjectiveTracker.event_player_remove_current_objectives = function (self)
	for id, widget in pairs(self._widgets_by_name) do
		self._clearing_widgets[id] = widget
	end

	self._remove_all_anim_id = self:_start_animation("remove_entry", self._clearing_widgets)
end

HudElementPrologueObjectiveTracker._clear_objectives = function (self)
	if self._clearing_widgets then
		for id, widget in pairs(self._clearing_widgets) do
			table.swap_delete(self._current_objectives, id)
			table.swap_delete(self._widgets_by_name, id)
		end

		self._clearing_widgets = {}
		self._remove_all_anim_id = nil
		self._index = 1
	end
end

HudElementPrologueObjectiveTracker.on_objective_completed = function (self, objective_id)
	local widget = self._widgets_by_name[objective_id]

	self:_start_animation("on_complete", widget)
end

HudElementPrologueObjectiveTracker._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local widgets_by_name = self._widgets_by_name

	for _, widget in pairs(widgets_by_name) do
		UIWidget.draw(widget, ui_renderer)
	end
end

HudElementPrologueObjectiveTracker._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPrologueTutorialObjectivesTrackerSettings.events

	for i = 1, #events, 1 do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementPrologueObjectiveTracker._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPrologueTutorialObjectivesTrackerSettings.events

	for i = 1, #events, 1 do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

return HudElementPrologueObjectiveTracker
