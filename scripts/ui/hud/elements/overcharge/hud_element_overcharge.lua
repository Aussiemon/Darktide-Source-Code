local Definitions = require("scripts/ui/hud/elements/overcharge/hud_element_overcharge_definitions")
local HudElementOverchargeSettings = require("scripts/ui/hud/elements/overcharge/hud_element_overcharge_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local WarpCharge = require("scripts/utilities/warp_charge")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementOvercharge = class("HudElementOvercharge", "HudElementBase")
local EPSILON = 0.00392156862745098

HudElementOvercharge.init = function (self, parent, draw_layer, start_scale)
	HudElementOvercharge.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._warp_charge_level = 0
	self._warp_charge_alpha_multiplier = 0
	self._overheat_level = 0
	self._overheat_alpha_multiplier = 0
	self._death_warning_alpha_multiplier = 0
end

HudElementOvercharge.destroy = function (self)
	HudElementOvercharge.super.destroy(self)
end

HudElementOvercharge.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementOvercharge.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_overcharge(dt)
	self:_update_overheat(dt)
	self:_update_death_warning(dt)
end

HudElementOvercharge._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local snap_pixel_positions = render_settings.snap_pixel_positions
	render_settings.snap_pixel_positions = true
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]

		if widget.dirty then
			UIWidget.draw(widget, ui_renderer)
		end
	end

	render_settings.snap_pixel_positions = snap_pixel_positions
end

HudElementOvercharge._update_overcharge = function (self, dt)
	local warp_charge_level = 0
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local player_unit_data = player_extensions.unit_data

		if player_unit_data then
			local warp_charge_component = player_unit_data:read_component("warp_charge")
			warp_charge_level = warp_charge_component.current_percentage
		end
	end

	local widget = self._widgets_by_name.overcharge

	if warp_charge_level == 0 then
		if widget.visible then
			widget.visible = false
			widget.dirty = true
		end

		self._warp_charge_level = warp_charge_level

		return
	end

	if warp_charge_level < self._warp_charge_level - EPSILON then
		warp_charge_level = math.lerp(self._warp_charge_level, warp_charge_level, dt * 5)
	end

	local previous_anim_progress = widget.content.anim_progress
	local animate_in = warp_charge_level > 0.75
	local anim_progress = self:_get_animation_progress(dt, warp_charge_level, previous_anim_progress, animate_in)

	if previous_anim_progress ~= anim_progress then
		widget.content.anim_progress = anim_progress

		self:_animate_widget_warnings(widget)
	end

	local old_warning_text = widget.content.warning_text
	local new_warning_text = string.format("%.0f%%", warp_charge_level * 100)
	widget.content.warning_text = new_warning_text

	if old_warning_text ~= new_warning_text then
		local fill_style = widget.style.fill
		local uvs = fill_style.uvs
		local size = fill_style.size
		local default_size = fill_style.default_size
		size[2] = default_size[2] * warp_charge_level
		uvs[1][2] = 1 - warp_charge_level
		widget.dirty = true
	end

	local visible = EPSILON < warp_charge_level
	self._warp_charge_alpha_multiplier = self:_update_visibility(dt, visible, self._warp_charge_alpha_multiplier)
	local alpha_multiplier = math.clamp(self._warp_charge_alpha_multiplier * 0.5 + warp_charge_level * 0.5, 0, 1)

	if EPSILON < math.abs((widget.alpha_multiplier or 0) - alpha_multiplier) then
		widget.alpha_multiplier = alpha_multiplier
		widget.dirty = true
		widget.visible = EPSILON < alpha_multiplier
	end

	self._warp_charge_level = warp_charge_level
end

HudElementOvercharge._update_overheat = function (self, dt)
	local overheat_level = 0
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local player_unit_data = player_extensions.unit_data

		if player_unit_data then
			local inventory_component = player_unit_data:read_component("inventory")
			local wielded_slot = inventory_component.wielded_slot

			if wielded_slot and wielded_slot ~= "none" then
				local slot_configuration = PlayerCharacterConstants.slot_configuration[wielded_slot]

				if slot_configuration.slot_type == "weapon" then
					local slot_component = player_unit_data:read_component(wielded_slot)
					local overheat_current_percentage = slot_component.overheat_current_percentage
					overheat_level = overheat_current_percentage
				end
			end
		end
	end

	local widget = self._widgets_by_name.overheat

	if overheat_level == 0 then
		if widget.visible then
			widget.visible = false
			widget.dirty = true
		end

		return
	end

	local previous_anim_progress = widget.content.anim_progress
	local animate_in = overheat_level > 0.75
	local anim_progress = self:_get_animation_progress(dt, overheat_level, previous_anim_progress, animate_in)

	if previous_anim_progress ~= anim_progress then
		widget.content.anim_progress = anim_progress

		self:_animate_widget_warnings(widget)
	end

	local old_warning_text = widget.content.warning_text
	local new_warning_text = string.format("%.0f%%", overheat_level * 100)
	widget.content.warning_text = new_warning_text

	if old_warning_text ~= new_warning_text then
		local fill_style = widget.style.fill
		local uvs = fill_style.uvs
		local size = fill_style.size
		local default_size = fill_style.default_size
		size[2] = default_size[2] * overheat_level
		uvs[1][2] = 1 - overheat_level
		widget.dirty = true
	end

	local visible = overheat_level > 0
	self._overheat_alpha_multiplier = self:_update_visibility(dt, visible, self._overheat_alpha_multiplier)
	local alpha_multiplier = math.clamp(self._overheat_alpha_multiplier * 0.5 + overheat_level, 0, 1)

	if EPSILON < math.abs((widget.alpha_multiplier or 0) - alpha_multiplier) then
		widget.alpha_multiplier = alpha_multiplier
		widget.dirty = true
		widget.visible = EPSILON < alpha_multiplier
	end

	self._overheat_level = overheat_level
end

HudElementOvercharge._update_death_warning = function (self, dt)
	local player = self._parent:player()
	local warp_charge_low, warp_charge_high, warp_charge_critical = WarpCharge.thresholds(player)
	local animate_in = warp_charge_critical < (self._warp_charge_level or 0)
	local max_value = math.max(self._overheat_level or 0, self._warp_charge_level or 0)
	animate_in = animate_in or max_value >= 1
	local widget = self._widgets_by_name.warning_text
	local previous_anim_progress = widget.content.anim_progress
	local anim_progress = self:_get_animation_progress(dt, max_value, previous_anim_progress, animate_in)

	if previous_anim_progress ~= anim_progress then
		widget.content.anim_progress = anim_progress

		self:_animate_widget_warnings(widget)
	end

	widget.style.warning.color[1] = 255
	local visible = animate_in
	self._death_warning_alpha_multiplier = self:_update_visibility(dt, visible, self._death_warning_alpha_multiplier)
	local alpha_multiplier = self._death_warning_alpha_multiplier

	if EPSILON < math.abs((widget.alpha_multiplier or 0) - alpha_multiplier) then
		widget.alpha_multiplier = alpha_multiplier
		widget.dirty = true
		widget.visible = EPSILON < alpha_multiplier
	elseif widget.visible and alpha_multiplier == 0 then
		widget.dirty = true
		widget.visible = false
	end
end

HudElementOvercharge._update_visibility = function (self, dt, visible, previous_alpha_multiplier)
	previous_alpha_multiplier = previous_alpha_multiplier or 0
	local alpha_speed = 8
	local alpha_multiplier = nil

	if visible then
		alpha_multiplier = math.min(previous_alpha_multiplier + dt * alpha_speed, 1)
	else
		alpha_multiplier = math.max(previous_alpha_multiplier - dt * alpha_speed, 0)
	end

	return alpha_multiplier
end

HudElementOvercharge._animate_widget_warnings = function (self, widget)
	local anim_progress = widget.content.anim_progress or 0
	local style = widget.style
	local warning_text_color = style.warning_text.text_color
	local warning_icon_color = style.warning.color
	local fill_color = style.fill and style.fill.color
	local alpha = 255 * anim_progress
	warning_icon_color[1] = alpha
	local speed = 12

	if anim_progress > 0 then
		local red_anim_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * speed) * 0.5) * anim_progress
		local red = 146 + red_anim_progress * 100
		warning_icon_color[2] = red
		warning_text_color[2] = red
		warning_text_color[3] = 69
		warning_text_color[4] = 69
	elseif fill_color then
		warning_text_color[2] = fill_color[2]
		warning_text_color[3] = fill_color[3]
		warning_text_color[4] = fill_color[4]
	end

	widget.dirty = true
end

HudElementOvercharge._get_animation_progress = function (self, dt, progress, previous_anim_progress, animate_in)
	local anim_speed = 5
	local anim_progress = previous_anim_progress or 0

	if animate_in then
		anim_progress = math.min(anim_progress + dt * anim_speed, 1)
	else
		anim_progress = math.max(anim_progress - dt * anim_speed, 0)
	end

	return anim_progress
end

return HudElementOvercharge
