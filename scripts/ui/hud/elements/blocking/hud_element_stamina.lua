-- chunkname: @scripts/ui/hud/elements/blocking/hud_element_stamina.lua

local hud_element_stamina_definitions = require("scripts/ui/hud/elements/blocking/hud_element_stamina_definitions")
local HudElementStaminaSettings = require("scripts/ui/hud/elements/blocking/hud_element_stamina_settings")
local Stamina = require("scripts/utilities/attack/stamina")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementStamina = class("HudElementStamina", "HudElementBase")
local STAMINA_NODGES_COLOR = HudElementStaminaSettings.STAMINA_NODGES_COLOR

HudElementStamina.init = function (self, parent, draw_layer, start_scale)
	HudElementStamina.super.init(self, parent, draw_layer, start_scale, hud_element_stamina_definitions)

	self._stamina_chunk_width = 0
	self._last_stamina_fraction = 1
	self._spent_stamina_animation = {
		running = false,
		stamina = 1,
		starting_stamina = 1,
	}
	self._stamina_nodge_widget = self:_create_widget("stamina_nodge", hud_element_stamina_definitions.stamina_nodges_definition)

	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings

	self._visibility_setting = interface_settings.stamina_and_dodge_visibility_setting or "dynamic"
	self._syncronize_with_dodge_bar = interface_settings.stamina_and_dodge_show_together or false
	self._use_percentage_based_division = interface_settings.show_stamina_with_fixed_dividers or false
	self._show_stamina_percentage_text = interface_settings.show_stamina_percentage_text or false
	self._is_active = false

	Managers.event:register(self, "event_update_stamina_and_dodge_hud_visibility_changed", "cb_stamina_and_dodge_hud_visibility_changed")
	Managers.event:register(self, "event_update_stamina_and_dodge_hud_syncronized", "cb_syncronized_with_stamina_bar_settings_changed")
	Managers.event:register(self, "event_update_show_stamina_with_fixed_dividers", "cb_show_stamina_with_fixed_dividers_settings_changed")
	Managers.event:register(self, "event_update_show_stamina_percentage_text", "cb_show_stamina_percentage_text_settings_changed")
end

HudElementStamina.destroy = function (self, ui_renderer)
	HudElementStamina.super.destroy(self, ui_renderer)
	Managers.event:unregister(self, "event_update_stamina_and_dodge_hud_visibility_changed")
	Managers.event:unregister(self, "event_update_stamina_and_dodge_hud_syncronized")
	Managers.event:unregister(self, "event_update_show_stamina_with_fixed_dividers")
	Managers.event:unregister(self, "event_update_show_stamina_percentage_text")
end

HudElementStamina.cb_syncronized_with_stamina_bar_settings_changed = function (self, enabled)
	self._syncronize_with_dodge_bar = enabled
end

HudElementStamina.cb_show_stamina_with_fixed_dividers_settings_changed = function (self, enabled)
	self._use_percentage_based_division = enabled
end

HudElementStamina.cb_show_stamina_percentage_text_settings_changed = function (self, enabled)
	self._show_stamina_percentage_text = enabled
end

HudElementStamina.cb_stamina_and_dodge_hud_visibility_changed = function (self, visibility_setting)
	self._visibility_setting = visibility_setting
end

HudElementStamina.is_active = function (self)
	return self._is_active
end

HudElementStamina.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementStamina.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_stamina_amount()
	self:_update_visibility(dt)
end

HudElementStamina._update_stamina_amount = function (self)
	local num_stamina_chunks = 0
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if not self._use_percentage_based_division and player_extensions then
		local unit_data_extension = player_extensions.unit_data

		if unit_data_extension then
			local stamina_component = unit_data_extension:read_component("stamina")
			local archetype = unit_data_extension:archetype()
			local base_stamina_template = archetype.stamina

			if stamina_component and base_stamina_template then
				local player_unit = player_extensions.unit
				local _, max = Stamina.current_and_max_value(player_unit, stamina_component, base_stamina_template)

				num_stamina_chunks = max
			end
		end
	else
		num_stamina_chunks = 4
	end

	if num_stamina_chunks ~= self._num_stamina_chunks then
		self._num_stamina_chunks = num_stamina_chunks

		local bar_size = HudElementStaminaSettings.bar_size
		local segment_spacing = HudElementStaminaSettings.spacing
		local total_segment_spacing = segment_spacing * math.max(math.floor(num_stamina_chunks), 0)
		local total_bar_length = bar_size[1] - total_segment_spacing

		self._stamina_chunk_width = self._num_stamina_chunks > 0 and total_bar_length / self._num_stamina_chunks or total_bar_length
	end
end

HudElementStamina._update_visibility = function (self, dt)
	local visibility_setting = self._visibility_setting
	local should_always_be_visible = visibility_setting == "always_stamina" or visibility_setting == "always_both"
	local is_visibility_enabled = should_always_be_visible or visibility_setting ~= "stamina_disabled" and visibility_setting ~= "both_disabled"
	local draw = not not should_always_be_visible
	local parent = self._parent
	local player_extensions = parent:player_extensions()
	local check_stamina_usage_status = is_visibility_enabled and not should_always_be_visible

	if check_stamina_usage_status and player_extensions then
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

	self._is_active = draw

	local syncronize_with_dodge_bar = self._syncronize_with_dodge_bar

	if is_visibility_enabled and not should_always_be_visible and syncronize_with_dodge_bar then
		local dodge_counter_hud_element = parent:element("HudElementDodgeCounter")

		draw = draw or dodge_counter_hud_element and dodge_counter_hud_element:is_active()
	end

	local alpha_speed = draw and 8 or 3
	local alpha_multiplier = self._alpha_multiplier or 0

	if draw then
		alpha_multiplier = math.min(alpha_multiplier + dt * alpha_speed, 1)
	else
		alpha_multiplier = math.max(alpha_multiplier - dt * alpha_speed, 0)
	end

	self._alpha_multiplier = alpha_multiplier
end

HudElementStamina._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._alpha_multiplier ~= 0 then
		local previous_alpha_multiplier = render_settings.alpha_multiplier

		render_settings.alpha_multiplier = self._alpha_multiplier

		HudElementStamina.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
		self:_draw_stamina_chunks(dt, t, ui_renderer)

		render_settings.alpha_multiplier = previous_alpha_multiplier
	end
end

HudElementStamina._draw_stamina_chunks = function (self, dt, t, ui_renderer)
	local num_stamina_chunks = self._num_stamina_chunks

	if num_stamina_chunks < 1 then
		return
	end

	local stamina_chunk_width = self._stamina_chunk_width
	local bar_size = HudElementStaminaSettings.bar_size
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

	if stamina_fraction <= 0 and self._last_stamina_fraction > 0 then
		self:_start_animation("on_stamina_depleted", self._widgets_by_name, 1)
	end

	local stamina_spent = self._last_stamina_fraction - stamina_fraction
	local spent_stamina_animation = self._spent_stamina_animation

	if stamina_spent > HudElementStaminaSettings.stamina_spent_threshold and not spent_stamina_animation.running then
		spent_stamina_animation.running = true
		spent_stamina_animation.start_t = t + HudElementStaminaSettings.stamina_spent_delay
		spent_stamina_animation.starting_stamina = self._last_stamina_fraction
		spent_stamina_animation.stamina = self._last_stamina_fraction
	end

	self._last_stamina_fraction = stamina_fraction

	local gauge_widget = self._widgets_by_name.gauge
	local stamina_text_style = gauge_widget.style.value_text
	local stamina_text_color = stamina_text_style.text_color

	stamina_text_color[1] = self._show_stamina_percentage_text and 255 or 0
	gauge_widget.content.value_text = string.format("%.0f%%", math.clamp(stamina_fraction, 0, 1) * 100)

	local spacing = HudElementStaminaSettings.spacing
	local stamina_bar_widget = self._widgets_by_name.stamina_bar

	stamina_bar_widget.style.bar_fill.size_addition[1] = -(bar_size[1] * (1 - stamina_fraction))

	if spent_stamina_animation.running then
		if stamina_fraction >= spent_stamina_animation.stamina then
			spent_stamina_animation.running = false
		end

		if t >= spent_stamina_animation.start_t then
			spent_stamina_animation.stamina = spent_stamina_animation.stamina - dt * HudElementStaminaSettings.stamina_spent_drain_speed
		end

		stamina_bar_widget.style.bar_spent.size_addition[1] = -(bar_size[1] * (1 - spent_stamina_animation.stamina))
	else
		stamina_bar_widget.style.bar_spent.size_addition[1] = -(bar_size[1] * (1 - stamina_fraction))
	end

	local show_last_nodge = num_stamina_chunks - math.floor(num_stamina_chunks) > 0
	local num_stamina_chunks_to_show = show_last_nodge and num_stamina_chunks or num_stamina_chunks - 1
	local stamina_nodge_widget = self._stamina_nodge_widget
	local stamina_nodge_widget_offset = stamina_nodge_widget.offset
	local stamina_nodge_widget_style = stamina_nodge_widget.style.nodges
	local stamina_nodge_widget_color = stamina_nodge_widget_style.color
	local stamina_nodge_offset = stamina_chunk_width

	for i = 1, num_stamina_chunks_to_show do
		stamina_nodge_widget_offset[1] = stamina_nodge_offset

		local is_nodge_above_current_stamina = i > stamina_fraction * num_stamina_chunks
		local nodge_color = is_nodge_above_current_stamina and STAMINA_NODGES_COLOR.empty or STAMINA_NODGES_COLOR.filled

		stamina_nodge_widget_color[1] = nodge_color[1]
		stamina_nodge_widget_color[2] = nodge_color[2]
		stamina_nodge_widget_color[3] = nodge_color[3]
		stamina_nodge_widget_color[4] = nodge_color[4]

		UIWidget.draw(stamina_nodge_widget, ui_renderer)

		stamina_nodge_offset = stamina_nodge_offset + (stamina_chunk_width + spacing)
	end
end

return HudElementStamina
