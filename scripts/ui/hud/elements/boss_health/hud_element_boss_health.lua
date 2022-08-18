local Definitions = require("scripts/ui/hud/elements/boss_health/hud_element_boss_health_definitions")
local HudElementBossHealthSettings = require("scripts/ui/hud/elements/boss_health/hud_element_boss_health_settings")
local HudElementBossToughnessSettings = require("scripts/ui/hud/elements/boss_health/hud_element_boss_toughness_settings")
local HudHealthBarLogic = require("scripts/ui/hud/elements/hud_health_bar_logic")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementBossHealth = class("HudElementBossHealth", "HudElementBase")

HudElementBossHealth.init = function (self, parent, draw_layer, start_scale)
	HudElementBossHealth.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._active_targets_array = {}
	self._active_targets_by_unit = {}
	self._max_target_units = 2

	self:_setup_widget_groups()

	local event_manager = Managers.event

	event_manager:register(self, "boss_encounter_start", "event_boss_encounter_start")
	event_manager:register(self, "boss_encounter_end", "event_boss_encounter_end")
	self:_set_active(false)
	self:_initial_boss_scan()
end

HudElementBossHealth._setup_widget_groups = function (self)
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
	local single_target_widgets = create_widgets(definitions.single_target_widget_definitions)
	local left_double_target_widgets = create_widgets(definitions.left_double_target_widget_definitions)
	local right_double_target_widgets = create_widgets(definitions.right_double_target_widget_definitions)
	self._widget_groups = {
		single_target_widgets,
		left_double_target_widgets,
		right_double_target_widgets
	}
end

HudElementBossHealth._initial_boss_scan = function (self)
	local side_system = Managers.state.extension:system("side_system")
	local default_player_side_name = side_system:get_default_player_side_name()
	local player_side = side_system:get_side_from_name(default_player_side_name)
	local monster_units = player_side:alive_units_by_tag("enemy", "monster")

	for i = 1, monster_units.size, 1 do
		local unit = monster_units[i]
		local boss_extension = ScriptUnit.has_extension(unit, "boss_system")

		if boss_extension then
			self:event_boss_encounter_start(unit, boss_extension)
		end
	end
end

HudElementBossHealth.destroy = function (self)
	HudElementBossHealth.super.destroy(self)

	local event_manager = Managers.event

	event_manager:unregister(self, "boss_encounter_start")
	event_manager:unregister(self, "boss_encounter_end")
end

HudElementBossHealth.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	local is_active = self._is_active

	if not is_active then
		return
	end

	HudElementBossHealth.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementBossHealth.event_boss_encounter_start = function (self, unit, boss_extension)
	local active_targets_by_unit = self._active_targets_by_unit
	local active_targets_array = self._active_targets_array

	if active_targets_by_unit[unit] or self._max_target_units <= #active_targets_array then
		return
	end

	local display_name = boss_extension:display_name()
	local localized_display_name = display_name and Localize(display_name)

	self:_set_active(true)

	local health_bar_logic = HudHealthBarLogic:new(HudElementBossHealthSettings)
	local toughness_bar_logic = HudHealthBarLogic:new(HudElementBossToughnessSettings)
	local target = {
		health_extension = ScriptUnit.extension(unit, "health_system"),
		toughness_extension = ScriptUnit.has_extension(unit, "toughness_system"),
		boss_extension = boss_extension,
		unit = unit,
		localized_display_name = localized_display_name,
		health_bar_logic = health_bar_logic,
		toughness_bar_logic = toughness_bar_logic
	}
	active_targets_by_unit[unit] = target
	active_targets_array[#active_targets_array + 1] = target
	self._force_update = true
end

HudElementBossHealth.event_boss_encounter_end = function (self, unit, boss_extension)
	local active_targets_array = self._active_targets_array
	local active_targets_by_unit = self._active_targets_by_unit
	local target = active_targets_by_unit[unit]

	if target then
		active_targets_by_unit[unit] = nil

		for i = 1, #active_targets_array, 1 do
			if active_targets_array[i].unit == unit then
				table.remove(active_targets_array, i)

				break
			end
		end

		if #active_targets_array == 0 then
			self:_set_active(false)
		else
			self._force_update = true
		end
	end
end

HudElementBossHealth.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local is_active = self._is_active

	if not is_active then
		return
	end

	local widget_groups = self._widget_groups
	local active_targets_array = self._active_targets_array
	local num_active_targets = #active_targets_array

	for i = 1, num_active_targets, 1 do
		local widget_group_index = (num_active_targets > 1 and i + 1) or i
		local widget_group = widget_groups[widget_group_index]
		local target = active_targets_array[i]
		local unit = target.unit

		if ALIVE[unit] then
			local localized_display_name = target.localized_display_name
			widget_group.health.content.text = localized_display_name
			local health_extension = target.health_extension
			local health_bar_logic = target.health_bar_logic
			local max_health_percentage = 1
			local current_health_percentage = health_extension:current_health_percent()

			health_bar_logic:update(dt, t, current_health_percentage, max_health_percentage)

			local health_fraction, health_ghost_fraction, health_max_fraction = health_bar_logic:animated_health_fractions()

			if self._force_update then
				health_fraction = health_fraction or current_health_percentage
				health_ghost_fraction = health_ghost_fraction or current_health_percentage
				health_max_fraction = health_max_fraction or max_health_percentage
			end

			if health_fraction and health_ghost_fraction then
				local widget = widget_group.health
				local bar_size = (widget_group_index == 1 and HudElementBossHealthSettings.size) or HudElementBossHealthSettings.size_small
				local bar_width = bar_size[1]

				self:_apply_widget_bar_fractions(widget, bar_width, health_fraction, health_ghost_fraction, health_max_fraction)
			end

			local toughness_extension = target.toughness_extension

			if toughness_extension then
				local toughness_bar_logic = target.toughness_bar_logic
				local max_toughness_percentage = 1
				local current_toughness_percentage = toughness_extension:current_toughness_percent()

				toughness_bar_logic:update(dt, t, current_toughness_percentage, max_toughness_percentage)

				local toughness_fraction, toughness_ghost_fraction, toughness_max_fraction = toughness_bar_logic:animated_health_fractions()

				if self._force_update then
					toughness_fraction = toughness_fraction or current_toughness_percentage
					toughness_ghost_fraction = toughness_ghost_fraction or current_toughness_percentage
					toughness_max_fraction = toughness_max_fraction or max_toughness_percentage
				end

				if toughness_fraction and toughness_ghost_fraction then
					local widget = widget_group.toughness

					if not widget.visible then
						widget.visible = true
					end

					local bar_size = (widget_group_index == 1 and HudElementBossToughnessSettings.size) or HudElementBossToughnessSettings.size_small
					local bar_width = bar_size[1]

					self:_apply_widget_bar_fractions(widget, bar_width, toughness_fraction, toughness_ghost_fraction, toughness_max_fraction)
				end
			else
				local widget = widget_group.toughness

				if widget.visible then
					widget.visible = false
				end
			end
		end
	end

	self._force_update = nil

	HudElementBossHealth.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementBossHealth._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	HudElementBossHealth.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local widget_groups = self._widget_groups
	local active_targets_array = self._active_targets_array
	local num_active_targets = #active_targets_array

	for i = 1, num_active_targets, 1 do
		local widget_group_index = (num_active_targets > 1 and i + 1) or i
		local widget_group = widget_groups[widget_group_index]
		local target = active_targets_array[i]
		local unit = target.unit

		if ALIVE[unit] then
			for _, widget in pairs(widget_group) do
				UIWidget.draw(widget, ui_renderer)
			end
		end
	end
end

HudElementBossHealth._set_active = function (self, active)
	self._is_active = active
end

HudElementBossHealth._set_health_bar_alpha = function (self, alpha_fraction)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.health.alpha_multiplier = alpha_fraction
	widgets_by_name.health_ghost.alpha_multiplier = alpha_fraction
	widgets_by_name.background.alpha_multiplier = alpha_fraction
end

HudElementBossHealth._apply_widget_bar_fractions = function (self, widget, bar_width_total, bar_fraction, ghost_fraction, max_fraction)
	local bar_width = math.floor(bar_width_total * bar_fraction)
	widget.style.bar.size[1] = bar_width
	local ghost_width = math.max(bar_width_total * ghost_fraction - bar_width, 0)
	widget.style.ghost.size[1] = bar_width + ghost_width
	local max_width = bar_width_total - math.max(bar_width_total * max_fraction, 0)
	max_width = math.max(max_width, 0)
	widget.style.max.size[1] = max_width
end

return HudElementBossHealth
