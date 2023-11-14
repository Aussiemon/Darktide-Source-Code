local Definitions = require("scripts/ui/hud/elements/boss_health/hud_element_boss_health_definitions")
local HudElementBossHealthSettings = require("scripts/ui/hud/elements/boss_health/hud_element_boss_health_settings")
local HudElementBossToughnessSettings = require("scripts/ui/hud/elements/boss_health/hud_element_boss_toughness_settings")
local HudHealthBarLogic = require("scripts/ui/hud/elements/hud_health_bar_logic")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
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

HudElementBossHealth.destroy = function (self, ui_renderer)
	HudElementBossHealth.super.destroy(self, ui_renderer)

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
	local health_extension = ScriptUnit.extension(unit, "health_system")
	local max_health = math.floor(health_extension:max_health())
	local breed = ScriptUnit.extension(unit, "unit_data_system"):breed()
	local breed_name = breed.name

	if not breed.ignore_weakened_boss_name then
		local initial_max_health = math.floor(Managers.state.difficulty:get_minion_max_health(breed_name))

		if max_health < initial_max_health then
			localized_display_name = Localize("loc_weakened_monster_prefix", true, {
				breed = localized_display_name
			})
		end
	end

	self:_set_active(true)

	local health_bar_logic = HudHealthBarLogic:new(HudElementBossHealthSettings)
	local toughness_bar_logic = HudHealthBarLogic:new(HudElementBossToughnessSettings)
	local target = {
		health_extension = health_extension,
		toughness_extension = ScriptUnit.has_extension(unit, "toughness_system"),
		boss_extension = boss_extension,
		unit = unit,
		localized_display_name = " " .. localized_display_name,
		health_bar_logic = health_bar_logic,
		toughness_bar_logic = toughness_bar_logic,
		breed = breed
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

		for i = 1, #active_targets_array do
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

local INVULNERABLE_TOUGHNESS_COLOR = UIHudSettings.color_tint_6
local DEFAULT_TOUGHNESS_COLOR = UIHudSettings.color_tint_secondary_1

HudElementBossHealth.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local is_active = self._is_active

	if not is_active then
		return
	end

	local widget_groups = self._widget_groups
	local active_targets_array = self._active_targets_array
	local num_active_targets = #active_targets_array

	for i = 1, num_active_targets do
		local widget_group_index = num_active_targets > 1 and i + 1 or i
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
				local bar_size = widget_group_index == 1 and HudElementBossHealthSettings.size or HudElementBossHealthSettings.size_small
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
				local can_have_invulnerable_toughness = target.breed.can_have_invulnerable_toughness

				if can_have_invulnerable_toughness then
					local game_session = Managers.state.game_session:game_session()
					local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
					local is_toughness_invulnerable = GameSession.game_object_field(game_session, game_object_id, "is_toughness_invulnerable")
					local widget = widget_group.toughness
					local texture_style = widget.style.bar
					local color = is_toughness_invulnerable and INVULNERABLE_TOUGHNESS_COLOR or DEFAULT_TOUGHNESS_COLOR
					texture_style.color = color
					widget.style.max.color = color
				end

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

					local bar_size = widget_group_index == 1 and HudElementBossToughnessSettings.size or HudElementBossToughnessSettings.size_small
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

	for i = 1, num_active_targets do
		local widget_group_index = num_active_targets > 1 and i + 1 or i
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
	widget.style.bar.uvs[2][1] = bar_fraction
	local ghost_width = math.max(bar_width_total * ghost_fraction - bar_width, 0)
	widget.style.ghost.size[1] = bar_width + ghost_width
	widget.style.ghost.uvs[2][1] = ghost_fraction
	local max_width = bar_width_total - math.max(bar_width_total * max_fraction, 0)
	max_width = math.max(max_width, 0)
	widget.style.max.size[1] = max_width
end

return HudElementBossHealth
