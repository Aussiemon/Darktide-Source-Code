local definition_path = "scripts/ui/hud/elements/player_health/hud_element_player_health_definitions"
local HudElementPlayerHealthSettings = require("scripts/ui/hud/elements/player_health/hud_element_player_health_settings")
local HudElementPlayerToughnessSettings = require("scripts/ui/hud/elements/player_health/hud_element_player_toughness_settings")
local HudHealthBarLogic = require("scripts/ui/hud/elements/hud_health_bar_logic")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local HudElementPlayerHealth = class("HudElementPlayerHealth", "HudElementBase")

HudElementPlayerHealth.init = function (self, parent, draw_layer, start_scale, definitions)
	local definitions = require(definition_path)

	HudElementPlayerHealth.super.init(self, parent, draw_layer, start_scale, definitions)

	self._bar_logic = HudHealthBarLogic:new(HudElementPlayerHealthSettings)
	self._toughness_bar_logic = HudHealthBarLogic:new(HudElementPlayerToughnessSettings)
end

HudElementPlayerHealth.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local health_percentage = 1
	local health_max_percentage = 1
	local toughness_percentage = 1
	local player_extensions = self._parent:player_extensions()

	if player_extensions then
		local health_extension = player_extensions.health
		local toughness_extension = player_extensions.toughness
		health_percentage = health_extension:current_health_percent()
		local permanent_damage = health_extension:permanent_damage_taken()
		local max_health = health_extension:max_health()
		health_max_percentage = (max_health - permanent_damage) / max_health
		toughness_percentage = toughness_extension:current_toughness_percent()
		local unit_data_extension = player_extensions.unit_data
		local disabled = self:_is_player_disabled(unit_data_extension)

		if disabled ~= self._disabled then
			self:_set_disabled(disabled)
		end
	end

	local bar_logic = self._bar_logic

	bar_logic:update(dt, t, health_percentage, health_max_percentage)

	local alpha_multiplier = bar_logic:alpha_multiplier()

	self:_set_bar_alpha(1)

	local health_fraction, health_ghost_fraction, health_max_fraction = bar_logic:animated_health_fractions()

	if health_fraction and health_ghost_fraction then
		self:_apply_health_fraction(health_fraction, health_ghost_fraction, health_max_fraction)
	end

	local toughness_bar_logic = self._toughness_bar_logic

	toughness_bar_logic:update(dt, t, toughness_percentage, 1)

	local toughness_fraction, toughness_ghost_fraction, toughness_max_fraction = toughness_bar_logic:animated_health_fractions()

	if toughness_fraction and toughness_ghost_fraction then
		self:_apply_toughness_fraction(toughness_fraction, toughness_ghost_fraction, toughness_max_fraction)
	end

	HudElementPlayerHealth.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

HudElementPlayerHealth._set_disabled = function (self, disabled)
	self._disabled = disabled
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.death_pulse.content.visible = disabled
	widgets_by_name.toughness_death_pulse.content.visible = disabled
	local color_tint_5 = UIHudSettings.color_tint_5
	local health_bar_frame_color = widgets_by_name.frame.style.texture.color
	health_bar_frame_color[2] = disabled and 255 or color_tint_5[2]
	health_bar_frame_color[3] = disabled and 0 or color_tint_5[3]
	health_bar_frame_color[4] = disabled and 0 or color_tint_5[4]
end

HudElementPlayerHealth._is_player_disabled = function (self, unit_data_extension)
	local character_state_component = unit_data_extension:read_component("character_state")

	return PlayerUnitStatus.is_disabled(character_state_component) or false
end

HudElementPlayerHealth._set_bar_alpha = function (self, alpha_fraction)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.health.alpha_multiplier = alpha_fraction
	widgets_by_name.health_ghost.alpha_multiplier = alpha_fraction
	widgets_by_name.background.alpha_multiplier = alpha_fraction
end

HudElementPlayerHealth._apply_health_fraction = function (self, health_fraction, health_ghost_fraction, health_max_fraction)
	local ui_scenegraph = self._ui_scenegraph
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local widgets_by_name = self._widgets_by_name
	local critical_health_threshold = HudElementPlayerHealthSettings.critical_health_threshold
	local critical_health_color = HudElementPlayerHealthSettings.critical_health_color
	local default_health_color = HudElementPlayerHealthSettings.default_health_color
	local bar_width = scenegraph_definition.bar.size[1]
	local health_id = "health"
	local health_width = math.floor(bar_width * health_fraction)
	local health_widget = widgets_by_name[health_id]
	health_widget.style.texture.size[1] = health_width
	local health_ghost_id = "health_ghost"
	local health_ghost_width = math.max(bar_width * health_ghost_fraction - health_width, 0)
	local health_ghost_widget = widgets_by_name[health_ghost_id]
	health_ghost_widget.style.texture.size[1] = health_width + health_ghost_width
	local health_max_id = "health_max"
	local health_max_width = bar_width - math.max(bar_width * health_max_fraction, 0)
	health_max_width = math.max(health_max_width, 0)
	local health_max_widget = widgets_by_name[health_max_id]
	health_max_widget.style.texture.size[1] = health_max_width
end

HudElementPlayerHealth._apply_toughness_fraction = function (self, health_fraction, health_ghost_fraction, health_max_fraction)
	local definitions = self._definitions
	local scenegraph_definition = definitions.scenegraph_definition
	local widgets_by_name = self._widgets_by_name
	local bar_width = scenegraph_definition.bar.size[1]
	local health_id = "toughness"
	local health_width = math.floor(bar_width * health_fraction)
	local health_widget = widgets_by_name[health_id]
	health_widget.style.texture.size[1] = health_width
	local health_ghost_id = "toughness_ghost"
	local health_ghost_width = math.max(bar_width * health_ghost_fraction - health_width, 0)
	local health_ghost_widget = widgets_by_name[health_ghost_id]
	health_ghost_widget.style.texture.size[1] = health_width + health_ghost_width
	local health_max_id = "toughness_max"
	local health_max_width = bar_width - math.max(bar_width * health_max_fraction, 0)
	health_max_width = math.max(health_max_width, 0)
	local health_max_widget = widgets_by_name[health_max_id]
	health_max_widget.style.texture.size[1] = health_max_width
end

return HudElementPlayerHealth
