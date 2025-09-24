-- chunkname: @scripts/ui/hud/elements/dodge_counter/hud_element_dodge_counter.lua

local Definitions = require("scripts/ui/hud/elements/dodge_counter/hud_element_dodge_counter_definitions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HudElementDodgeCounterSettings = require("scripts/ui/hud/elements/dodge_counter/hud_element_dodge_counter_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Stamina = require("scripts/utilities/attack/stamina")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local DODGE_BAR_STATE_COLORS_BAR_FILL = HudElementDodgeCounterSettings.DODGE_BAR_STATE_COLORS_BAR_FILL
local DODGE_BAR_STATE_COLORS_BAR_BACKGROUND = HudElementDodgeCounterSettings.DODGE_BAR_STATE_COLORS_BAR_BACKGROUND
local HudElementDodgeCounter = class("HudElementDodgeCounter", "HudElementBase")

HudElementDodgeCounter.init = function (self, parent, draw_layer, start_scale)
	HudElementDodgeCounter.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._dodge_bars = {}
	self._dodge_bar_width = 0
	self._is_dodging = false
	self._is_dodge_on_cooldown = false
	self._effective_dodges_left = 0
	self._consecutive_dodges_performed = 0
	self._last_consecutive_dodges_performed = 0
	self._max_effective_dodges = 0

	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings

	self._syncronize_with_stamina_bar = interface_settings.stamina_and_dodge_show_together or false
	self._visibility_setting = interface_settings.stamina_and_dodge_visibility_setting or "dynamic"
	self._is_active = false

	Managers.event:register(self, "event_update_stamina_and_dodge_hud_visibility_changed", "cb_stamina_and_dodge_hud_visibility_changed")
	Managers.event:register(self, "event_update_stamina_and_dodge_hud_syncronized", "cb_syncronized_with_stamina_bar_settings_changed")
end

HudElementDodgeCounter.destroy = function (self, ui_renderer)
	HudElementDodgeCounter.super.destroy(self, ui_renderer)
	Managers.event:unregister(self, "event_update_stamina_and_dodge_hud_visibility_changed")
	Managers.event:unregister(self, "event_update_stamina_and_dodge_hud_syncronized")
end

HudElementDodgeCounter.cb_syncronized_with_stamina_bar_settings_changed = function (self, enabled)
	self._syncronize_with_stamina_bar = enabled
end

HudElementDodgeCounter.cb_stamina_and_dodge_hud_visibility_changed = function (self, visibility_setting)
	self._visibility_setting = visibility_setting
end

HudElementDodgeCounter.is_active = function (self)
	return self._is_active
end

HudElementDodgeCounter._add_dodge_bar = function (self)
	local dodge_bar_index = #self._dodge_bars + 1
	local dodge_bar_widget_name = "dodge_bar_" .. dodge_bar_index
	local is_available = self._effective_dodges_left >= self._max_effective_dodges - dodge_bar_index + 1
	local is_on_cooldown = self._is_dodging or self._is_dodge_on_cooldown
	local starting_status = "available"
	local override_starting_color

	if is_available and is_on_cooldown then
		override_starting_color = DODGE_BAR_STATE_COLORS_BAR_FILL.available_on_cooldown
		starting_status = "available_on_cooldown"
	elseif not is_available then
		override_starting_color = DODGE_BAR_STATE_COLORS_BAR_FILL.spent
		starting_status = "spent"
	end

	local new_bar = {
		status = starting_status,
		widget_name = dodge_bar_widget_name,
		widget = self:_create_widget(dodge_bar_widget_name, Definitions.dodge_bar_definition),
	}

	if override_starting_color then
		local widget = new_bar.widget
		local fill_widget_color = widget.style.bar_fill.color

		fill_widget_color[1] = override_starting_color[1]
		fill_widget_color[2] = override_starting_color[2]
		fill_widget_color[3] = override_starting_color[3]
		fill_widget_color[4] = override_starting_color[4]
	end

	self._dodge_bars[dodge_bar_index] = new_bar
end

HudElementDodgeCounter._remove_dodge_bar = function (self, ui_renderer)
	local dodge_bar_index = #self._dodge_bars
	local dodge_bar = self._dodge_bars[dodge_bar_index]
	local widget = dodge_bar.widget

	self:_unregister_widget_name(widget.name)
	UIWidget.destroy(ui_renderer, widget)

	self._dodge_bars[#self._dodge_bars] = nil
end

HudElementDodgeCounter.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementDodgeCounter.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_dodge_amount(t, ui_renderer)
	self:_update_visibility(dt)
end

HudElementDodgeCounter._update_dodge_amount = function (self, t, ui_renderer)
	local parent = self._parent
	local player_extensions = parent:player_extensions()
	local current_max_effective_dodges = self:_update_dodging_data(player_extensions)
	local max_effective_dodges_changed = current_max_effective_dodges ~= self._max_effective_dodges

	if max_effective_dodges_changed then
		local amount_difference = (self._max_effective_dodges or 0) - current_max_effective_dodges

		self._max_effective_dodges = current_max_effective_dodges

		local bar_size = HudElementDodgeCounterSettings.bar_size
		local segment_spacing = HudElementDodgeCounterSettings.spacing
		local total_segment_spacing = segment_spacing * math.max(current_max_effective_dodges - 1, 0)
		local total_bar_length = bar_size[1] - total_segment_spacing

		self._dodge_bar_width = math.round(current_max_effective_dodges > 0 and total_bar_length / current_max_effective_dodges or total_bar_length)

		local add_dodges = amount_difference < 0

		for i = 1, math.abs(amount_difference) do
			if add_dodges then
				self:_add_dodge_bar()
			else
				self:_remove_dodge_bar(ui_renderer)
			end
		end

		self._start_on_half_bar = false
	end
end

HudElementDodgeCounter._update_dodging_data = function (self, player_extensions)
	local current_max_effective_dodges = 0

	if player_extensions then
		local unit_data_extension = player_extensions.unit_data
		local weapon_extension = player_extensions.weapon

		if unit_data_extension and weapon_extension then
			local movement_state_component = unit_data_extension and unit_data_extension:read_component("movement_state")
			local dodge_character_state_component = unit_data_extension:read_component("dodge_character_state")
			local slide_character_state_component = unit_data_extension:read_component("slide_character_state")
			local character_state_component = unit_data_extension:read_component("character_state")
			local fixed_t = FixedFrame.get_latest_fixed_time()
			local num_effective_dodges = Dodge.num_effective_dodges(player_extensions.unit)

			current_max_effective_dodges = math.floor(num_effective_dodges)

			local is_vaulting = movement_state_component.method == "vaulting"
			local is_lunging = movement_state_component.method == "lunging"
			local is_dodging = movement_state_component.is_dodging and not is_vaulting and not is_lunging
			local is_sliding = movement_state_component.method == "sliding"
			local was_in_consecutive_dodge_cooldown = slide_character_state_component.was_in_dodge_cooldown
			local current_state_name = character_state_component.state_name
			local current_state_enter_t = character_state_component.entered_t
			local entered_dodge_cooldown_this_frame = is_dodging and (current_state_name == "dodging" or current_state_name == "sliding") and current_state_enter_t == fixed_t
			local can_consecutive_dodges_reset = not is_dodging or is_sliding and not was_in_consecutive_dodge_cooldown
			local effective_dodges_have_reset = can_consecutive_dodges_reset and fixed_t > dodge_character_state_component.consecutive_dodges_cooldown
			local consecutive_dodges_performed = effective_dodges_have_reset and 0 or dodge_character_state_component.consecutive_dodges
			local effective_dodges_left = math.floor(num_effective_dodges - consecutive_dodges_performed)
			local effective_dodges_left_capped = math.max(math.floor(num_effective_dodges - consecutive_dodges_performed), 0)
			local dodge_was_spent = consecutive_dodges_performed - self._last_consecutive_dodges_performed > 0
			local triggered_ineffective_dodge = consecutive_dodges_performed - self._last_consecutive_dodges_performed > 0 and effective_dodges_left < 0

			self._last_consecutive_dodges_performed = self._consecutive_dodges_performed
			self._consecutive_dodges_performed = consecutive_dodges_performed
			self._consecutive_dodges_cooldown = dodge_character_state_component.consecutive_dodges_cooldown
			self._effective_dodges_left = effective_dodges_left_capped
			self._is_dodging = is_dodging
			self._is_dodge_on_cooldown = fixed_t <= dodge_character_state_component.cooldown
			self._dodge_was_spent = dodge_was_spent
			self._entered_dodge_cooldown_this_frame = entered_dodge_cooldown_this_frame
			self._triggered_ineffective_dodge = triggered_ineffective_dodge
		end
	end

	return current_max_effective_dodges
end

HudElementDodgeCounter._update_visibility = function (self, dt)
	local consecutive_dodges_performed = self._consecutive_dodges_performed
	local consecutive_dodges_cooldown = self._consecutive_dodges_cooldown
	local fixed_t = FixedFrame.get_latest_fixed_time()
	local visibility_setting = self._visibility_setting
	local should_always_be_visible = visibility_setting == "always_dodge" or visibility_setting == "always_both"
	local is_visibility_enabled = should_always_be_visible or visibility_setting ~= "dodge_disabled" and visibility_setting ~= "both_disabled"
	local draw = should_always_be_visible or is_visibility_enabled and (consecutive_dodges_performed > 0 or fixed_t <= consecutive_dodges_cooldown + 1)

	self._is_active = draw

	local parent = self._parent
	local syncronize_with_stamina_bar = self._syncronize_with_stamina_bar

	if is_visibility_enabled and not should_always_be_visible and syncronize_with_stamina_bar then
		local stamina_bar_hud_element = parent:element("HudElementStamina")

		draw = draw or stamina_bar_hud_element and stamina_bar_hud_element:is_active()
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

HudElementDodgeCounter._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._alpha_multiplier ~= 0 then
		local previous_alpha_multiplier = render_settings.alpha_multiplier

		render_settings.alpha_multiplier = self._alpha_multiplier

		HudElementDodgeCounter.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
		self:_draw_dodge_bars(dt, t, ui_renderer)

		render_settings.alpha_multiplier = previous_alpha_multiplier
	end
end

HudElementDodgeCounter._draw_dodge_bars = function (self, dt, t, ui_renderer)
	local max_effective_dodges = self._max_effective_dodges

	if max_effective_dodges < 1 then
		return
	end

	local effective_dodges_left = self._effective_dodges_left

	if self._triggered_ineffective_dodge then
		local wide_bar_animation_id = self:_start_animation("on_inefficient_dodge", self._widgets_by_name, 1)
	end

	local dodge_bar_width = self._dodge_bar_width
	local spacing = HudElementDodgeCounterSettings.spacing
	local x_offset = 0
	local dodge_was_spent = self._dodge_was_spent
	local is_dodge_on_cooldown = self._is_dodging or self._is_dodge_on_cooldown
	local entered_dodging_state_this_frame = self._entered_dodge_cooldown_this_frame
	local dodge_bars = self._dodge_bars

	for i = 1, max_effective_dodges do
		local bar_index = max_effective_dodges - i + 1
		local dodge_bar = dodge_bars[i]

		if not dodge_bar then
			return
		end

		local dodge_bar_widget = dodge_bar.widget
		local dodge_bar_widget_style_fill = dodge_bar_widget.style.bar_fill
		local dodge_bar_widget_style_background = dodge_bar_widget.style.bar_background

		dodge_bar_widget_style_fill.size[1] = dodge_bar_width
		dodge_bar_widget_style_background.size[1] = dodge_bar_width

		local dodge_bar_widget_offset = dodge_bar_widget.offset
		local is_dodge_bar_available = bar_index <= effective_dodges_left

		self:_check_animation_triggers(dodge_bar, entered_dodging_state_this_frame, dodge_was_spent, is_dodge_bar_available, is_dodge_on_cooldown)
		self:_update_dodge_bars_background_colors(dodge_bar, is_dodge_bar_available, is_dodge_on_cooldown)

		dodge_bar_widget_offset[1] = x_offset

		UIWidget.draw(dodge_bar_widget, ui_renderer)

		x_offset = x_offset - dodge_bar_width - spacing
	end
end

HudElementDodgeCounter._check_animation_triggers = function (self, dodge_bar, entered_dodging_state_this_frame, dodge_was_spent, is_dodge_bar_available, is_dodge_on_cooldown)
	local bar_status = dodge_bar.status

	if not is_dodge_bar_available and (bar_status == "available" or bar_status == "available_on_cooldown") then
		dodge_bar.status = "spent"

		self:_start_dodge_bar_animation(dodge_bar, "on_bar_spent")
	elseif is_dodge_bar_available and bar_status == "spent" then
		self:_start_dodge_bar_animation(dodge_bar, "on_bar_restored")

		dodge_bar.status = "available"
	end

	if is_dodge_bar_available then
		if (dodge_was_spent or entered_dodging_state_this_frame) and is_dodge_on_cooldown and dodge_bar.status == "available" then
			self:_start_dodge_bar_animation(dodge_bar, "on_bar_enter_cooldown")

			dodge_bar.status = "available_on_cooldown"
		elseif not is_dodge_on_cooldown and dodge_bar.status == "available_on_cooldown" then
			self:_start_dodge_bar_animation(dodge_bar, "on_bar_exit_cooldown")

			dodge_bar.status = "available"
		end
	end
end

HudElementDodgeCounter._update_dodge_bars_background_colors = function (self, dodge_bar, is_dodge_bar_available, is_dodge_on_cooldown)
	local dodge_bar_widget = dodge_bar.widget
	local background_active_color
	local widget_style = dodge_bar_widget.style

	if is_dodge_bar_available then
		background_active_color = DODGE_BAR_STATE_COLORS_BAR_BACKGROUND.default
	else
		background_active_color = is_dodge_on_cooldown and DODGE_BAR_STATE_COLORS_BAR_BACKGROUND.on_cooldown or DODGE_BAR_STATE_COLORS_BAR_BACKGROUND.default
	end

	local background_widget_color = widget_style.bar_background.color

	background_widget_color[1] = background_active_color[1]
	background_widget_color[2] = background_active_color[2]
	background_widget_color[3] = background_active_color[3]
	background_widget_color[4] = background_active_color[4]
end

HudElementDodgeCounter._start_dodge_bar_animation = function (self, dodge_bar, animation_name)
	local dodge_bar_widget = dodge_bar.widget
	local running_animation_id = dodge_bar.animation_id

	if running_animation_id then
		self:_stop_animation(running_animation_id)

		dodge_bar.animation_id = nil
	end

	local animation_id = self:_start_animation(animation_name, self._widgets_by_name, 1, {
		dodge_bar = dodge_bar,
		dodge_bar_widget = dodge_bar_widget,
		name = dodge_bar.widget_name,
	})

	dodge_bar.animation_id = animation_id
end

return HudElementDodgeCounter
