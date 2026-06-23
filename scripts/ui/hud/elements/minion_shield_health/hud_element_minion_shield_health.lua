-- chunkname: @scripts/ui/hud/elements/minion_shield_health/hud_element_minion_shield_health.lua

local Definitions = require("scripts/ui/hud/elements/minion_shield_health/hud_element_minion_shield_health_definitions")
local HudElementMinionShieldHealthsSettings = require("scripts/ui/hud/elements/minion_shield_health/hud_element_minion_shield_health_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementMinionShieldHealth = class("HudElementMinionShieldHealth", "HudElementBase")

HudElementMinionShieldHealth.init = function (self, parent, draw_layer, start_scale)
	HudElementMinionShieldHealth.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._dirty = false
	self._remove_t = 0

	local event_manager = Managers.event

	self._percentage_for_icons = HudElementMinionShieldHealthsSettings.percentage_for_icons

	event_manager:register(self, "event_minion_shield_damage", "event_minion_shield_damage")
end

HudElementMinionShieldHealth.destroy = function (self, ui_renderer)
	local event_manager = Managers.event

	event_manager:unregister(self, "event_minion_shield_damage")
	HudElementMinionShieldHealth.super.destroy(self, ui_renderer)
end

HudElementMinionShieldHealth.is_active = function (self)
	return self._is_active
end

HudElementMinionShieldHealth._set_visible = function (self)
	return
end

HudElementMinionShieldHealth.event_minion_shield_damage = function (self, attacked_unit)
	self._attacked_unit = attacked_unit

	local game_session = Managers.state.game_session:game_session()
	local unit_spawner_manager = Managers.state.unit_spawner
	local game_object_id = unit_spawner_manager:game_object_id(attacked_unit)
	local go_field = GameSession.game_object_field
	local shield_health = go_field(game_session, game_object_id, "shield_health")
	local shield_max_health = go_field(game_session, game_object_id, "shield_max_health")

	self:_set_visible_by_health(shield_health, shield_max_health)
end

HudElementMinionShieldHealth._set_visible_by_health = function (self, shield_health, shield_max_health)
	local health_percentage = shield_health / shield_max_health * 100
	local widget = self._widgets_by_name.minion_shield_health
	local widget_styles = widget.style
	local widget_values
	local percentage_for_icons = self._percentage_for_icons

	for i = 1, #percentage_for_icons do
		local current_entry = percentage_for_icons[i]

		if health_percentage <= current_entry.health_value then
			widget_values = current_entry.values

			break
		end
	end

	for name, data in pairs(widget_styles) do
		if widget_values[name] then
			data.visible = true
		else
			data.visible = false
		end
	end

	self._dirty = true
end

HudElementMinionShieldHealth._death_check = function (self)
	local attacked_unit = self._attacked_unit

	if attacked_unit and HEALTH_ALIVE[attacked_unit] then
		local game_session = Managers.state.game_session:game_session()
		local go_field = GameSession.game_object_field
		local unit_spawner_manager = Managers.state.unit_spawner
		local game_object_id = unit_spawner_manager:game_object_id(attacked_unit)

		if game_object_id then
			local shield_health = go_field(game_session, game_object_id, "shield_health")
			local shield_max_health = go_field(game_session, game_object_id, "shield_max_health")
			local health_percentage = shield_health / shield_max_health * 100

			if health_percentage == 0 then
				return true
			else
				return false
			end
		end
	end

	return true
end

HudElementMinionShieldHealth.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local widget = self._widgets_by_name.minion_shield_health
	local widget_styles = widget.style
	local is_dead

	if self._dirty then
		self._remove_t = t + 2

		UIWidget.draw(widget, ui_renderer)

		self._dirty = false
	end

	if self._attacked_unit then
		is_dead = self:_death_check()
	end

	if not self._dirty and is_dead or not self._dirty and t > self._remove_t then
		for name, data in pairs(widget_styles) do
			data.visible = false
		end

		self._attacked_unit = nil
	end

	HudElementMinionShieldHealth.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementMinionShieldHealth._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	HudElementMinionShieldHealth.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

return HudElementMinionShieldHealth
