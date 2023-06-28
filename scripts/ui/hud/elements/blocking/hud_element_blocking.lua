local Definitions = require("scripts/ui/hud/elements/blocking/hud_element_blocking_definitions")
local HudElementBlockingSettings = require("scripts/ui/hud/elements/blocking/hud_element_blocking_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Stamina = require("scripts/utilities/attack/stamina")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local HudElementBlocking = class("HudElementBlocking", "HudElementBase")

HudElementBlocking.init = function (self, parent, draw_layer, start_scale)
	HudElementBlocking.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._shields = {}
	self._shield_width = 0
	self._shield_widget = self:_create_widget("shield", Definitions.shield_definition)
end

HudElementBlocking.destroy = function (self)
	HudElementBlocking.super.destroy(self)
end

HudElementBlocking._add_shield = function (self)
	self._shields[#self._shields + 1] = {}
end

HudElementBlocking._remove_shield = function (self)
	self._shields[#self._shields] = nil
end

HudElementBlocking.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementBlocking.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_shield_amount()
	self:_update_visibility(dt)
end

HudElementBlocking._update_shield_amount = function (self)
	local shield_amount = 0
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local unit_data_extension = player_extensions.unit_data

		if unit_data_extension then
			local stamina_component = unit_data_extension:read_component("stamina")
			local specialization = unit_data_extension:specialization()
			local base_stamina_template = specialization.stamina

			if stamina_component and base_stamina_template then
				local player_unit = player_extensions.unit
				local current, max = Stamina.current_and_max_value(player_unit, stamina_component, base_stamina_template)
				shield_amount = max
			end
		end
	end

	if shield_amount ~= self._shield_amount then
		local amount_difference = (self._shield_amount or 0) - shield_amount
		self._shield_amount = shield_amount
		local bar_size = HudElementBlockingSettings.bar_size
		local segment_spacing = HudElementBlockingSettings.spacing
		local total_segment_spacing = segment_spacing * math.max(shield_amount - 1, 0)
		local total_bar_length = bar_size[1] - total_segment_spacing
		self._shield_width = math.round(shield_amount > 0 and total_bar_length / shield_amount or total_bar_length)
		local widget = self._shield_widget

		self:_set_scenegraph_size("shield", self._shield_width)

		local add_shields = amount_difference < 0

		for i = 1, math.abs(amount_difference) do
			if add_shields then
				self:_add_shield()
			else
				self:_remove_shield()
			end
		end
	end
end

HudElementBlocking._update_visibility = function (self, dt)
	local draw = false
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local player_unit_data = player_extensions.unit_data

		if player_unit_data then
			local block_component = player_unit_data:read_component("block")
			local sprint_component = player_unit_data:read_component("sprint_character_state")
			local stamina_component = player_unit_data:read_component("stamina")

			if block_component and block_component.is_blocking or sprint_component and sprint_component.is_sprinting or stamina_component and stamina_component.current_fraction < 1 then
				draw = true
			end
		end
	end

	local alpha_speed = 3
	local alpha_multiplier = self._alpha_multiplier or 0

	if draw then
		alpha_multiplier = math.min(alpha_multiplier + dt * alpha_speed, 1)
	else
		alpha_multiplier = math.max(alpha_multiplier - dt * alpha_speed, 0)
	end

	self._alpha_multiplier = alpha_multiplier
end

HudElementBlocking._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._alpha_multiplier ~= 0 then
		local previous_alpha_multiplier = render_settings.alpha_multiplier
		render_settings.alpha_multiplier = self._alpha_multiplier

		HudElementBlocking.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
		self:_draw_shields(dt, t, ui_renderer)

		render_settings.alpha_multiplier = previous_alpha_multiplier
	end
end

local STAMINA_STATE_COLORS = {
	empty = {
		100,
		UIHudSettings.color_tint_secondary_3[2],
		UIHudSettings.color_tint_secondary_3[3],
		UIHudSettings.color_tint_secondary_3[4]
	},
	half = UIHudSettings.color_tint_main_3,
	full = UIHudSettings.color_tint_main_1
}

HudElementBlocking._draw_shields = function (self, dt, t, ui_renderer)
	local num_shields = self._shield_amount

	if num_shields < 1 then
		return
	end

	local widget = self._shield_widget
	local widget_offset = widget.offset
	local shield_width = self._shield_width
	local bar_size = HudElementBlockingSettings.bar_size
	local max_glow_alpha = HudElementBlockingSettings.max_glow_alpha
	local half_distance = HudElementBlockingSettings.half_distance
	local stamina_fraction = 1
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local player_unit_data = player_extensions.unit_data

		if player_unit_data then
			local stamina_component = player_unit_data:read_component("stamina")

			if stamina_component and stamina_component.current_fraction then
				stamina_fraction = stamina_component.current_fraction
			end
		end
	end

	local gauge_widget = self._widgets_by_name.gauge
	gauge_widget.content.value_text = string.format("%.0f%%", math.clamp(stamina_fraction, 0, 1) * 100)
	local step_fraction = 1 / num_shields
	local spacing = HudElementBlockingSettings.spacing
	local x_offset = (shield_width + spacing) * (num_shields - 1) * 0.5
	local shields = self._shields

	for i = num_shields, 1, -1 do
		local shield = shields[i]

		if not shield then
			return
		end

		local end_value = i * step_fraction
		local start_value = end_value - step_fraction
		local is_full, is_half, is_empty = nil

		if stamina_fraction >= start_value + step_fraction * 0.5 then
			is_full = true
		elseif start_value < stamina_fraction then
			is_half = true
		else
			is_empty = true
		end

		local active_color = nil

		if is_empty then
			active_color = STAMINA_STATE_COLORS.empty
		elseif is_full then
			active_color = STAMINA_STATE_COLORS.full
		elseif is_half then
			active_color = STAMINA_STATE_COLORS.half
		end

		local widget_style = widget.style
		local widget_color = widget_style.full.color
		widget_color[1] = active_color[1]
		widget_color[2] = active_color[2]
		widget_color[3] = active_color[3]
		widget_color[4] = active_color[4]
		widget_offset[1] = x_offset

		UIWidget.draw(widget, ui_renderer)

		x_offset = x_offset - shield_width - spacing
	end
end

return HudElementBlocking
