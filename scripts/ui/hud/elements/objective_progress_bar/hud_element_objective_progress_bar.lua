-- chunkname: @scripts/ui/hud/elements/objective_progress_bar/hud_element_objective_progress_bar.lua

local Definitions = require("scripts/ui/hud/elements/objective_progress_bar/hud_element_objective_progress_bar_definitions")
local HudElementObjectiveProgressBarSettings = require("scripts/ui/hud/elements/objective_progress_bar/hud_element_objective_progress_bar_settings")
local HudHealthBarLogic = require("scripts/ui/hud/elements/hud_health_bar_logic")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementObjectiveProgressBar = class("HudElementObjectiveProgressBar", "HudElementBase")

HudElementObjectiveProgressBar.init = function (self, parent, draw_layer, start_scale)
	HudElementObjectiveProgressBar.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._active_objective_array = {}
	self._active_objective_size = 0
	self._max_objectives = 2

	self:_setup_widget_groups()
	self:_set_active(false)

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	if mission_objective_system then
		local active_objectives = mission_objective_system:active_objectives()

		for _, objective in pairs(active_objectives) do
			if objective:large_progress_bar() then
				self:event_objective_progress_bar_open(objective)
			end
		end
	end

	local event_manager = Managers.event

	event_manager:register(self, "objective_progress_bar_open", "event_objective_progress_bar_open")
	event_manager:register(self, "objective_progress_bar_close", "event_objective_progress_bar_close")
end

HudElementObjectiveProgressBar._setup_widget_groups = function (self)
	local name_index_preffix = 1

	local function create_widgets(widget_definitions)
		local target_widgets = {}

		for name, definition in pairs(widget_definitions) do
			target_widgets[name] = self:_create_widget(name .. "_" .. name_index_preffix, definition)
			name_index_preffix = name_index_preffix + 1
		end

		return target_widgets
	end

	local definitions = self._definitions

	self._bar_widgets = create_widgets(definitions.single_target_widget_definitions)
end

HudElementObjectiveProgressBar.destroy = function (self, ui_renderer)
	HudElementObjectiveProgressBar.super.destroy(self, ui_renderer)

	local event_manager = Managers.event

	event_manager:unregister(self, "objective_progress_bar_open")
	event_manager:unregister(self, "objective_progress_bar_close")
end

HudElementObjectiveProgressBar.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	local is_active = self._is_active

	if not is_active then
		return
	end

	HudElementObjectiveProgressBar.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementObjectiveProgressBar.event_objective_progress_bar_open = function (self, objective)
	local active_objective_array = self._active_objective_array

	if active_objective_array[objective] or #active_objective_array >= self._max_objectives then
		return
	end

	local localized_display_name = objective:header()

	self:_set_active(true)

	local bar_logic = HudHealthBarLogic:new(HudElementObjectiveProgressBarSettings)
	local target = {
		objective = objective,
		localized_display_name = localized_display_name,
		bar_logic = bar_logic
	}

	self._active_objective_size = self._active_objective_size + 1
	active_objective_array[objective] = target
	self._force_update = true
end

HudElementObjectiveProgressBar.event_objective_progress_bar_close = function (self, objective)
	local active_objective_array = self._active_objective_array
	local target = active_objective_array[objective]

	if target then
		active_objective_array[objective] = nil
		self._active_objective_size = self._active_objective_size - 1

		if self._active_objective_size == 0 then
			self:_set_active(false)
		else
			self._force_update = true
		end
	end
end

HudElementObjectiveProgressBar.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local is_active = self._is_active

	if not is_active then
		return
	end

	for objective, target in pairs(self._active_objective_array) do
		local widgets = self._bar_widgets
		local localized_display_name = target.localized_display_name

		widgets.health.content.text = localized_display_name

		local bar_logic = target.bar_logic
		local max_health_percentage = 1
		local current_health_percentage = objective:progression()

		bar_logic:update(dt, t, current_health_percentage, max_health_percentage)

		local health_fraction, health_ghost_fraction, health_max_fraction = bar_logic:animated_health_fractions()

		if self._force_update then
			health_fraction = health_fraction or current_health_percentage
			health_ghost_fraction = health_ghost_fraction or current_health_percentage
			health_max_fraction = health_max_fraction or max_health_percentage
		end

		local widget = widgets.health

		if health_fraction and health_ghost_fraction then
			self:_apply_widget_bar_fractions(objective, widget, health_fraction, health_ghost_fraction, health_max_fraction, t)
		end

		if objective:ui_state() == "alert" then
			local bar_color = UIHudSettings.color_tint_main_1
			local lerp = math.sin(t * 10) / 2 + 0.5
			local bar_style = widget.style.bar

			bar_style.color[2] = math.lerp(bar_color[2], 255, lerp)
			bar_style.color[3] = math.lerp(bar_color[3], 151, lerp)
			bar_style.color[4] = math.lerp(bar_color[4], 29, lerp)
		end
	end

	self._force_update = nil

	HudElementObjectiveProgressBar.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementObjectiveProgressBar._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	HudElementObjectiveProgressBar.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local widgets = self._bar_widgets

	for objective, target in pairs(self._active_objective_array) do
		if objective then
			for _, widget in pairs(widgets) do
				UIWidget.draw(widget, ui_renderer)
			end
		end
	end
end

HudElementObjectiveProgressBar._set_active = function (self, active)
	self._is_active = active
end

HudElementObjectiveProgressBar._set_health_bar_alpha = function (self, alpha_fraction)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.health.alpha_multiplier = alpha_fraction
	widgets_by_name.health_ghost.alpha_multiplier = alpha_fraction
	widgets_by_name.background.alpha_multiplier = alpha_fraction
end

HudElementObjectiveProgressBar._apply_widget_bar_fractions = function (self, objective, widget, bar_fraction, ghost_fraction, max_fraction, t)
	local bar_size = HudElementObjectiveProgressBarSettings.size
	local bar_width_total = bar_size[1]
	local bar_width = math.floor(bar_width_total * bar_fraction)
	local bar_style = widget.style.bar

	bar_style.size[1] = bar_width
	bar_style.uvs[2][1] = bar_fraction

	local ghost_width = math.max(bar_width_total * ghost_fraction - bar_width, 0)

	widget.style.ghost.size[1] = bar_width + ghost_width
	widget.style.ghost.uvs[2][1] = ghost_fraction

	local max_width = bar_width_total - math.max(bar_width_total * max_fraction, 0)

	max_width = math.max(max_width, 0)
	widget.style.max.size[1] = max_width
end

return HudElementObjectiveProgressBar
