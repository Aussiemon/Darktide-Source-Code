-- chunkname: @scripts/ui/hud/elements/player_weapon/hud_element_player_weapon.lua

local Ammo = require("scripts/utilities/ammo")
local HudElementPlayerWeaponHandlerSettings = require("scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler_settings")
local HudElementPlayerWeaponSettings = require("scripts/ui/hud/elements/player_weapon/hud_element_player_weapon_settings")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local DEFINITION_PATH = "scripts/ui/hud/elements/player_weapon/hud_element_player_weapon_definitions"
local HudElementPlayerWeapon = class("HudElementPlayerWeapon", "HudElementBase")

HudElementPlayerWeapon.init = function (self, parent, draw_layer, start_scale, data)
	local definitions = require(DEFINITION_PATH)

	HudElementPlayerWeapon.super.init(self, parent, draw_layer, start_scale, definitions)

	self._data = data
	self._inventory_component = data.inventory_component
	self._slot_component = data.slot_component
	self._slot_name = self._slot_component.__name
	self._slot_index = data.index
	self._ability = data.ability
	self._ability_extension = data.ability_extension

	local slot_settings = self._slot_name and ItemSlotSettings[self._slot_name]

	self._wield_input = slot_settings.wield_input or self._ability and self._ability.ability_type
	self._gamepad_wield_input = slot_settings and slot_settings.gamepad_wield_input or self._wield_input
	self._hide_input_on_gamepad_wielded = slot_settings and slot_settings.hide_input_on_gamepad_wielded

	local weapon_template = data.weapon_template

	self._weapon_name = data.weapon_name
	self._weapon_template = weapon_template
	self._current_ammunition_clips = {}
	self._max_ammunition_clips = {}

	local weapon_slots = {}
	local slot_configuration = PlayerCharacterConstants.slot_configuration

	for slot_id, config in pairs(slot_configuration) do
		if config.category == "weapon" then
			weapon_slots[#weapon_slots + 1] = slot_id
		end
	end

	self._weapon_slots = weapon_slots

	local is_weapon = self._slot_name == "slot_primary" or self._slot_name == "slot_secondary"

	self._is_weapon = is_weapon

	if data.icon then
		self:set_icon(data.icon)
	else
		local item = data.item
		local hud_icon = item.hud_icon

		hud_icon = hud_icon or self._slot_name == "slot_primary" and "content/ui/materials/icons/weapons/hud/combat_blade_01" or "content/ui/materials/icons/weapons/hud/autogun_01"

		self:set_icon(hud_icon, is_weapon)
	end

	local hud_configuration = weapon_template and weapon_template.hud_configuration or self._ability.hud_configuration
	local uses_ammo = hud_configuration and hud_configuration.uses_ammunition
	local hud_ammo_icon = hud_configuration and hud_configuration.hud_ammo_icon
	local uses_overheat = hud_configuration and hud_configuration.uses_overheat
	local uses_weapon_special_charges = hud_configuration and hud_configuration.uses_weapon_special_charges
	local infinite_ammo = not uses_ammo and uses_overheat

	self._infinite_ammo = infinite_ammo
	self._widgets_by_name.infinite_symbol.content.visible = not not infinite_ammo

	for i = 1, NetworkConstants.clips_in_use.max_size do
		self._widgets_by_name["ammo_text_" .. i].content.visible = not not not infinite_ammo
	end

	self._uses_ammo = uses_ammo
	self._hud_ammo_icon = hud_ammo_icon
	self._uses_overheat = uses_overheat
	self._uses_weapon_special_charges = uses_weapon_special_charges

	self:_set_ammo_amount(nil, nil)
	self:_update_input()
	self:_register_events()

	self._first_frame = true
end

HudElementPlayerWeapon.destroy = function (self, ui_renderer)
	self:_unregister_events()
	self:_destroy_widgets(ui_renderer)
	HudElementPlayerWeapon.super.destroy(self, ui_renderer)
end

HudElementPlayerWeapon._destroy_widgets = function (self, ui_renderer, use_retained_mode)
	local widgets = self._widgets
	local num_widgets = #widgets

	for ii = 1, num_widgets do
		local widget = widgets[ii]

		UIWidget.destroy(ui_renderer, widget, use_retained_mode)
	end
end

HudElementPlayerWeapon.set_visible = function (self, visible, ui_renderer, use_retained_mode)
	if use_retained_mode then
		if visible then
			self:set_dirty()
		else
			self:_destroy_widgets(ui_renderer)
		end
	end
end

HudElementPlayerWeapon.set_wielded = function (self, wielded)
	self._wielded = wielded
	self._updated_input_text = true
end

HudElementPlayerWeapon.wielded = function (self)
	return self._wielded
end

HudElementPlayerWeapon.slot_name = function (self)
	return self._slot_name
end

HudElementPlayerWeapon._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._first_frame then
		self._first_frame = false

		return
	end

	local widgets = self._widgets
	local num_widgets = #widgets

	for ii = 1, num_widgets do
		local widget = widgets[ii]

		if widget.dirty then
			UIWidget.draw(widget, ui_renderer)
		end
	end
end

HudElementPlayerWeapon._apply_color_values = function (self, destination_color, target_color, include_alpha)
	if include_alpha then
		destination_color[1] = target_color[1]
	end

	destination_color[2] = target_color[2]
	destination_color[3] = target_color[3]
	destination_color[4] = target_color[4]
end

HudElementPlayerWeapon._set_ammo_refill_alpha = function (self, alpha)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.background

	widget.dirty = true
end

local _clips_in_use_scratch = {}

HudElementPlayerWeapon.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerWeapon.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._updated_input_text then
		self._updated_input_text = nil

		self:_update_input()
	end

	if self._ammo_refill_progress then
		self._ammo_refill_progress = self._ammo_refill_progress + dt * 2

		if self._ammo_refill_progress >= 1 then
			self._ammo_refill_progress = nil

			self:_set_ammo_refill_alpha(0)
		else
			local anim_progress = math.ease_out_quad(math.ease_pulse((math.min(self._ammo_refill_progress, 1))))
			local alpha = 255 * anim_progress

			self:_set_ammo_refill_alpha(alpha)
		end
	end

	local clip_information_updated = false

	if self._ability or self._uses_weapon_special_charges then
		local remaining_ability_charges, clip_total, total_max_ammo_amount

		if self._uses_weapon_special_charges then
			local weapon_special_tweak_data = self._weapon_template.weapon_special_tweak_data

			remaining_ability_charges = self._slot_component.num_special_charges
			clip_total = weapon_special_tweak_data.max_charges
			total_max_ammo_amount = false
		elseif self._ability then
			local ability_extension = self._ability_extension
			local ability_type = self._ability.ability_type
			local max_ability_charges = self._ability_extension:max_ability_charges(ability_type)

			remaining_ability_charges = self._ability_extension:remaining_ability_charges(ability_type)
			clip_total = max_ability_charges
			total_max_ammo_amount = max_ability_charges

			local max_ability_cooldown = ability_extension:max_ability_cooldown(ability_type)
			local remaining_ability_cooldown = ability_extension:remaining_ability_cooldown(ability_type)
			local cooldown_progress = max_ability_cooldown > 0 and remaining_ability_cooldown / max_ability_cooldown or 0

			if remaining_ability_charges ~= self._remaining_ability_charges then
				if self._remaining_ability_charges and remaining_ability_charges > self._remaining_ability_charges then
					self._animate_charge_gained = true
					self._animate_first_charge = self._animate_first_charge or remaining_ability_charges == 1
					self._animate_charge_gained_t = t
				end

				local icon_widget = self._widgets_by_name.icon
				local icon_style = icon_widget.style.icon
				local icon_opacity = 255

				if remaining_ability_charges == 0 then
					icon_opacity = icon_opacity * 0.5
				end

				if icon_style.color[1] ~= icon_opacity then
					icon_style.color[1] = icon_opacity
					icon_widget.dirty = true
				end

				self._remaining_ability_charges = remaining_ability_charges
			end

			if cooldown_progress ~= self._cooldown_progress then
				if self._cooldown_progress ~= nil then
					local background_widget = self._widgets_by_name.background
					local background_glow_style = background_widget.style.background_glow

					background_glow_style.uvs[2][2] = cooldown_progress
					background_glow_style.scale[2] = cooldown_progress
					background_widget.dirty = true
				end

				self._cooldown_progress = cooldown_progress
			end

			if self._animate_charge_gained then
				local background_widget = self._widgets_by_name.background
				local background_style = background_widget.style
				local icon_widget = self._widgets_by_name.icon
				local icon_style = icon_widget.style.icon
				local icon_cooldown_done_style = icon_widget.style.icon_cooldown_done

				background_widget.dirty = true
				icon_widget.dirty = true

				local icon_pop_time = 0.2
				local glass_time = 0.25
				local glow_time = 0.5
				local time_in_anim = t - self._animate_charge_gained_t
				local glass_anim_p = math.clamp01(time_in_anim / glass_time)
				local glow_anim_p = math.clamp01(time_in_anim / glow_time)
				local pop_anim_p = math.clamp01(time_in_anim / icon_pop_time)
				local all_done = math.min(glass_anim_p, glow_anim_p, pop_anim_p) == 1

				if all_done then
					self._animate_charge_gained = false
					self._animate_charge_gained_t = nil
					self._animate_first_charge = false
					background_style.background_stripe_wide.color[1] = 0
					background_style.background_stripe_thin_left.color[1] = 0
					background_style.background_stripe_thin_right.color[1] = 0
					icon_cooldown_done_style.color[1] = 0
					icon_style.color[1] = 255
				else
					if self._animate_first_charge then
						table.merge(background_style.background_stripe_wide.color, background_style.background_stripe_wide.active_color)
						table.merge(background_style.background_stripe_thin_left.color, background_style.background_stripe_thin_left.active_color)
						table.merge(background_style.background_stripe_thin_right.color, background_style.background_stripe_thin_right.active_color)

						background_style.background_stripe_wide.offset_scale[1] = math.remap(0, 1, -0.5, 1, glass_anim_p)

						local icon_scale_multiplier = HudElementPlayerWeaponHandlerSettings.icon_shrink_scale
						local pop_size = 1 / (1 - icon_scale_multiplier)
						local size_increase = math.lerp(pop_size, 1, pop_anim_p)

						icon_cooldown_done_style.size[1] = icon_style.size[1] * size_increase
						icon_cooldown_done_style.size[2] = icon_style.size[2] * size_increase
						icon_cooldown_done_style.color[1] = 200
					end

					local glow_p = 1 - math.easeInCubic(glow_anim_p)

					background_style.cooldown_done_glow.color[1] = glow_p * 255
				end
			end
		end

		if self._uses_ammo and self._total_ammo ~= remaining_ability_charges then
			self._low_on_ammo = remaining_ability_charges <= 0

			self:_set_clip_amount(remaining_ability_charges, clip_total, 1)
			self:_set_ammo_amount(remaining_ability_charges, total_max_ammo_amount, 1)

			clip_information_updated = true
		end
	else
		local slot_component = self._slot_component

		if slot_component then
			if self._uses_ammo or self._uses_overheat then
				local max_reserve = slot_component.max_ammunition_reserve

				if max_reserve and max_reserve > 0 then
					local any_clip_in_use = Ammo.clips_in_use(slot_component, _clips_in_use_scratch)

					if any_clip_in_use then
						local current_reserve = slot_component.current_ammunition_reserve
						local total_ammo = current_reserve
						local total_max_ammo = max_reserve
						local clip_updated = false

						for i = 1, NetworkConstants.clips_in_use.max_size do
							local max_ammunition_clip = Ammo.max_ammo_in_clips(slot_component, i)
							local current_ammunition_clip = Ammo.current_ammo_in_clips(slot_component, i)
							local max_clip_dirty = self._max_ammunition_clips[i] ~= max_ammunition_clip
							local update_clip = max_clip_dirty or self._current_ammunition_clips[i] ~= current_ammunition_clip

							total_ammo = total_ammo + current_ammunition_clip
							total_max_ammo = total_max_ammo + max_ammunition_clip

							if update_clip or clip_information_updated then
								self:_set_clip_amount(current_ammunition_clip, max_ammunition_clip, i)

								clip_information_updated = true
								clip_updated = true
							end
						end

						local update_total = self._total_ammo ~= total_ammo

						if update_total or clip_updated then
							if self._total_ammo and total_ammo > self._total_ammo then
								self._ammo_refill_progress = 0
							end

							self._low_on_ammo = total_ammo / total_max_ammo <= 0.2

							self:_set_ammo_amount(total_ammo, total_max_ammo)

							clip_information_updated = true
						end
					end
				end
			end

			if self._uses_overheat then
				local overheat_current_percentage = slot_component.overheat_current_percentage

				if overheat_current_percentage ~= self._overheat_progress then
					self._overheat_progress = overheat_current_percentage
				end
			end
		end
	end

	if clip_information_updated then
		self:set_wield_anim_progress(self._wield_anim_progress or 0, ui_renderer)
	end
end

local function _animate_color_value(target, progress, from, to, include_alpha)
	local start_index = include_alpha and 1 or 2

	for ii = start_index, 4 do
		target[ii] = (to[ii] - from[ii]) * progress + from[ii]
	end
end

HudElementPlayerWeapon.set_size = function (self, width, height)
	local scenegraph_id = "background"

	self:_set_scenegraph_size(scenegraph_id, width, height)
end

HudElementPlayerWeapon.set_height_offset = function (self, height_offset)
	self._height_offset = height_offset

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.background.offset[2] = height_offset
	widgets_by_name.background.dirty = true
	widgets_by_name.icon.offset[2] = height_offset
	widgets_by_name.icon.dirty = true
	widgets_by_name.input_text.offset[2] = height_offset
	widgets_by_name.input_text.dirty = true
	widgets_by_name.infinite_symbol.offset[2] = height_offset
	widgets_by_name.infinite_symbol.dirty = true

	for i = 1, NetworkConstants.clips_in_use.max_size do
		widgets_by_name["ammo_text_" .. i].offset[2] = height_offset
		widgets_by_name["ammo_text_" .. i].dirty = true
	end

	widgets_by_name.hud_ammo_icon.offset[2] = height_offset
end

HudElementPlayerWeapon._set_alpha = function (self, alpha_fraction)
	local general_fraction = 0.8 + alpha_fraction * 0.2
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.background.alpha_multiplier = 1
	widgets_by_name.icon.alpha_multiplier = general_fraction
	widgets_by_name.infinite_symbol.alpha_multiplier = general_fraction

	for i = 1, NetworkConstants.clips_in_use.max_size do
		widgets_by_name["ammo_text_" .. i].alpha_multiplier = general_fraction
	end
end

HudElementPlayerWeapon.is_weapon = function (self)
	return self._is_weapon
end

local function _update_ammo_number(pass_style, progress, low_on_ammo, ammo_text_height, background_scenegraph_height, height_difference_scale, inverse_progress, use_one_line_ammunition, free_transfer)
	local default_font_size = pass_style.default_font_size
	local focused_font_size = pass_style.focused_font_size
	local font_size_difference = focused_font_size - default_font_size
	local font_size_difference_animated = font_size_difference * progress
	local animated_font_size = default_font_size + font_size_difference_animated

	pass_style.font_size = animated_font_size

	local color_tint_main_1 = UIHudSettings.color_tint_main_1
	local color_tint_main_2 = UIHudSettings.color_tint_main_2
	local color_tint_main_3 = UIHudSettings.color_tint_main_3
	local free_transfer_color = UIHudSettings.color_tint_10
	local wielded_color = free_transfer and free_transfer_color or low_on_ammo and HudElementPlayerWeaponSettings.urgent_color or color_tint_main_2
	local secondary_color = free_transfer and free_transfer_color or low_on_ammo and HudElementPlayerWeaponSettings.urgent_color_wielded or pass_style.primary_counter and color_tint_main_1 or color_tint_main_3
	local include_alpha = free_transfer

	_animate_color_value(pass_style.text_color or pass_style.color, progress, wielded_color, secondary_color, include_alpha)

	local max_ammo_digits = HudElementPlayerWeaponSettings.max_ammo_digits
	local digit_width = math.round(animated_font_size * 0.55)
	local index = pass_style.index

	if index then
		pass_style.offset[1] = -((max_ammo_digits - index) * digit_width)
	end

	if pass_style.clip_ammo then
		local additional_height = use_one_line_ammunition and 12 or 4

		pass_style.offset[2] = background_scenegraph_height * 0.5 - ammo_text_height + (additional_height - height_difference_scale * inverse_progress)
	else
		pass_style.offset[2] = background_scenegraph_height * 0.5 + (8 - height_difference_scale * inverse_progress)
	end

	return digit_width, ammo_text_height
end

local _clip_in_use_scratch = {}

HudElementPlayerWeapon.set_wield_anim_progress = function (self, progress, ui_renderer)
	local inverse_progress = 1 - progress

	self._wield_anim_progress = progress

	self:_set_alpha(progress)

	local widgets_by_name = self._widgets_by_name
	local color_tint_main_1 = UIHudSettings.color_tint_main_1
	local color_tint_main_2 = UIHudSettings.color_tint_main_2
	local color_tint_main_3 = UIHudSettings.color_tint_main_3
	local line_style = widgets_by_name.background.style.line

	_animate_color_value(line_style.color, progress, line_style.default_color, line_style.highlight_color)

	local icon_style = widgets_by_name.icon.style.icon

	_animate_color_value(icon_style.color, progress, icon_style.default_color, line_style.highlight_color)
	_animate_color_value(widgets_by_name.infinite_symbol.style.texture.color, progress, color_tint_main_2, color_tint_main_1)

	local is_weapon = self._is_weapon
	local size = is_weapon and HudElementPlayerWeaponHandlerSettings.weapon_size or HudElementPlayerWeaponHandlerSettings.size
	local size_small = is_weapon and HudElementPlayerWeaponHandlerSettings.weapon_size_small or HudElementPlayerWeaponHandlerSettings.size_small
	local icon_size = icon_style.size
	local icon_scale_multiplier = HudElementPlayerWeaponHandlerSettings.icon_shrink_scale
	local default_icon_size = icon_style.default_size

	icon_size[1] = default_icon_size[1] - default_icon_size[1] * icon_scale_multiplier * inverse_progress
	icon_size[2] = default_icon_size[2] - default_icon_size[2] * icon_scale_multiplier * inverse_progress

	local ammo_offsets = is_weapon and HudElementPlayerWeaponHandlerSettings.ammo_offsets_weapon or HudElementPlayerWeaponHandlerSettings.ammo_offsets_icon
	local default_ammo_offset = ammo_offsets.default
	local small_ammo_offset = ammo_offsets.small
	local width_difference = size[1] - size_small[1]
	local ammo_text_offset = -icon_size[1] + (default_ammo_offset[1] + (small_ammo_offset[1] - default_ammo_offset[1]) * inverse_progress)
	local spare_text_offset = ammo_text_offset

	widgets_by_name.input_text.offset[1] = size[1] - width_difference * inverse_progress

	if self._infinite_ammo then
		_animate_color_value(widgets_by_name.infinite_symbol.style.texture.color, progress, color_tint_main_3, color_tint_main_2)

		local infinite_symbol_size = HudElementPlayerWeaponSettings.infinite_symbol_size
		local infinite_symbol_size_focused = HudElementPlayerWeaponSettings.infinite_symbol_size_focused
		local infinite_symbol_style_size = widgets_by_name.infinite_symbol.style.texture.size

		infinite_symbol_style_size[1] = (infinite_symbol_size_focused[1] - infinite_symbol_size[1]) * progress + infinite_symbol_size[1]
		infinite_symbol_style_size[2] = (infinite_symbol_size_focused[2] - infinite_symbol_size[2]) * progress + infinite_symbol_size[2]
	elseif self._uses_ammo then
		local low_on_ammo = self._low_on_ammo
		local scenegraph_id = "background"
		local background_scenegraph_size = self:scenegraph_size(scenegraph_id)
		local background_scenegraph_height = background_scenegraph_size[2]
		local height_difference = size[2] - size_small[2]
		local extra_height = height_difference * progress
		local height_difference_scale = extra_height / size[2]

		Ammo.clips_in_use(self._slot_component, _clip_in_use_scratch)

		local free_transfer = self._slot_component.free_ammunition_transfer
		local first_digit_offset_x, first_digit_offset_y, first_digit_height

		for clip_index = NetworkConstants.clips_in_use.max_size, 1, -1 do
			local ammo_text_widget = widgets_by_name["ammo_text_" .. clip_index]
			local ammo_text_style = ammo_text_widget.style
			local ammo_text_content = ammo_text_widget.content

			if _clip_in_use_scratch[clip_index] or clip_index == 1 and self._ability then
				ammo_text_widget.offset[1] = ammo_text_offset

				for digit_i = 1, HudElementPlayerWeaponSettings.max_ammo_digits do
					local spare_pass_name = "ammo_spare_" .. digit_i
					local spare_pass_style = ammo_text_style[spare_pass_name]

					if spare_pass_style then
						local spare_pass_content = ammo_text_content[spare_pass_name]

						_update_ammo_number(spare_pass_style, progress, low_on_ammo, self:_style_text_height(spare_pass_content, spare_pass_style, ui_renderer), background_scenegraph_height, height_difference_scale, inverse_progress, self._use_one_line_ammunition, false)

						spare_pass_style.offset[1] = spare_pass_style.offset[1] + (spare_text_offset - ammo_text_offset)
					end
				end

				for digit_i = 1, HudElementPlayerWeaponSettings.max_ammo_digits do
					local ammo_pass_name = "ammo_amount_" .. digit_i
					local pass_style = ammo_text_style[ammo_pass_name]
					local pass_content = ammo_text_content[ammo_pass_name]
					local digit_width, ammo_text_height = _update_ammo_number(pass_style, progress, low_on_ammo, self:_style_text_height(pass_content, pass_style, ui_renderer), background_scenegraph_height, height_difference_scale, inverse_progress, self._use_one_line_ammunition, free_transfer)

					if pass_content ~= "" then
						if not first_digit_offset_x then
							first_digit_offset_x = pass_style.offset[1] - digit_width
							first_digit_offset_y = pass_style.offset[2]
							first_digit_height = ammo_text_height
						end

						ammo_text_offset = ammo_text_offset - digit_width
					end
				end

				if ammo_text_style.divider then
					ammo_text_style.divider.offset[1] = (first_digit_offset_x or 0) - (HudElementPlayerWeaponSettings.divider_padding - HudElementPlayerWeaponSettings.divider_width - 3)
					ammo_text_style.divider.offset[2] = first_digit_offset_y
					ammo_text_style.divider.size[2] = first_digit_height
					ammo_text_offset = ammo_text_offset - HudElementPlayerWeaponSettings.divider_padding * 2 + 3
				end
			end
		end

		if first_digit_offset_y then
			local ammo_icon_widget = widgets_by_name.hud_ammo_icon
			local ammo_icon_x_width, ammo_icon_x_height = _update_ammo_number(ammo_icon_widget.style.hud_ammo_icon_x, progress, false, self:_style_text_height(ammo_icon_widget.content.hud_ammo_icon_x, ammo_icon_widget.style.hud_ammo_icon_x, ui_renderer), background_scenegraph_height, height_difference_scale, inverse_progress, self._use_one_line_ammunition, false)

			ammo_icon_widget.content.hud_ammo_icon = self._hud_ammo_icon
			ammo_icon_widget.style.hud_ammo_icon_x.offset[1] = ammo_text_offset
			ammo_icon_widget.style.hud_ammo_icon_x.offset[2] = first_digit_offset_y + first_digit_height - ammo_icon_x_height - 1
			ammo_text_offset = ammo_text_offset - ammo_icon_x_width

			local _, ammo_icon_height = _update_ammo_number(ammo_icon_widget.style.hud_ammo_icon, progress, false, first_digit_height, background_scenegraph_height, height_difference_scale, inverse_progress, self._use_one_line_ammunition, false)

			ammo_icon_widget.style.hud_ammo_icon.offset[1] = ammo_text_offset - 4
			ammo_icon_widget.style.hud_ammo_icon.offset[2] = first_digit_offset_y
			ammo_icon_widget.style.hud_ammo_icon.size[2] = ammo_icon_height
			ammo_icon_widget.dirty = true
		end
	end
end

HudElementPlayerWeapon._style_text_height = function (self, text, text_style, ui_renderer)
	local text_size = text_style.size
	local _, text_height = self:_text_size(ui_renderer, text, text_style, text_size)

	return text_height
end

local function _apply_color_to_text(text, color)
	return "{#color(" .. color[2] .. "," .. color[3] .. "," .. color[4] .. ")}" .. text .. "{#reset()}"
end

local _temp_ammo_display_texts = {}

local function _convert_ammo_to_display_texts(amount, max_character, low_on_ammo, color_zero_values, ignore_coloring, is_weapon, is_spare)
	local zero_numeral_color = low_on_ammo and UIHudSettings.color_tint_alert_3 or UIHudSettings.color_tint_main_3

	table.clear(_temp_ammo_display_texts)

	local max_ammo_digits = HudElementPlayerWeaponSettings.max_ammo_digits
	local length = string.len(amount)
	local num_adds = math.min(max_character, max_ammo_digits) - length
	local zero_string = "0"
	local zero_string_colored = ignore_coloring and zero_string or _apply_color_to_text("0", zero_numeral_color)

	for ii = 1, num_adds do
		_temp_ammo_display_texts[#_temp_ammo_display_texts + 1] = zero_string_colored
	end

	local num_amount_strings = string.format("%1d", amount)

	for ii = 1, #num_amount_strings do
		local value = string.sub(num_amount_strings, ii, ii)

		if amount == 0 and color_zero_values then
			_temp_ammo_display_texts[#_temp_ammo_display_texts + 1] = zero_string_colored
		else
			_temp_ammo_display_texts[#_temp_ammo_display_texts + 1] = value
		end
	end

	return _temp_ammo_display_texts
end

HudElementPlayerWeapon._set_clip_amount = function (self, current, total, clip_index)
	self._current_ammunition_clips[clip_index] = current
	self._max_ammunition_clips[clip_index] = total
end

HudElementPlayerWeapon._set_ammo_amount = function (self, amount, total_max_amount)
	self._total_ammo = amount

	local is_weapon = self._is_weapon
	local current_ammunition_clips = self._current_ammunition_clips
	local max_ammo_digits = HudElementPlayerWeaponSettings.max_ammo_digits

	if not self._infinite_ammo then
		local slot_component = self._slot_component
		local widgets_by_name = self._widgets_by_name
		local content_idx = 0

		if self._uses_ammo then
			Ammo.clips_in_use(slot_component, _clip_in_use_scratch)

			local free_transfer = slot_component.free_ammunition_transfer
			local total_ammo_in_clips = 0

			for clip_index = 1, NetworkConstants.clips_in_use.max_size do
				if _clip_in_use_scratch[clip_index] or clip_index == 1 and self._ability then
					content_idx = content_idx + 1

					local ammo_text_widget = widgets_by_name["ammo_text_" .. content_idx]
					local current_ammunition_clip = current_ammunition_clips[clip_index]

					total_ammo_in_clips = total_ammo_in_clips + (current_ammunition_clip or 0)

					local content = ammo_text_widget.content
					local style = ammo_text_widget.style

					if current_ammunition_clip then
						local display_texts = _convert_ammo_to_display_texts(current_ammunition_clip, string.len(self._max_ammunition_clips[clip_index] or amount), self._low_on_ammo, current_ammunition_clip == 0, amount == 0, is_weapon)

						for ii = max_ammo_digits, 1, -1 do
							local key = "ammo_amount_" .. ii
							local text = table.remove(display_texts, #display_texts)

							content[key] = text or ""

							local digit_style = style[key]

							digit_style.drop_shadow = not not text
							digit_style.color = free_transfer and digit_style.free_transfer_text_color or digit_style.default_text_color
						end
					else
						for ii = max_ammo_digits, 1, -1 do
							content["ammo_amount_" .. ii] = ""
						end
					end

					ammo_text_widget.dirty = true
					ammo_text_widget.visible = true
				end
			end

			local spare_clip_content = widgets_by_name.ammo_text_1.content
			local spare_clip_style = widgets_by_name.ammo_text_1.style
			local spare_clips = is_weapon and not table.is_empty(self._max_ammunition_clips) and amount - total_ammo_in_clips

			if spare_clips and total_max_amount then
				local display_texts = _convert_ammo_to_display_texts(spare_clips, string.len(total_max_amount), self._low_on_ammo, true, amount == 0, is_weapon, true)

				for ii = max_ammo_digits, 1, -1 do
					local key = "ammo_spare_" .. ii
					local text = table.remove(display_texts, #display_texts)

					spare_clip_content[key] = text or ""
					spare_clip_style[key].drop_shadow = not not text
				end

				self._use_one_line_ammunition = false
			else
				for ii = max_ammo_digits, 1, -1 do
					spare_clip_content["ammo_spare_" .. ii] = ""
				end

				self._use_one_line_ammunition = true
			end
		end

		for i = content_idx + 1, NetworkConstants.clips_in_use.max_size do
			local ammo_text_widget = widgets_by_name["ammo_text_" .. i]
			local content = ammo_text_widget.content

			if content.visible then
				content.visible = false
				ammo_text_widget.dirty = true
			end
		end

		self:set_height_offset(self._height_offset or 0)
	end
end

local function _find_input_key(alias_names, service_type, color_tint_text)
	for _, sub_alias_name in ipairs(alias_names) do
		local input_key = InputUtils.input_text_for_current_input_device(service_type, sub_alias_name, color_tint_text)

		if input_key ~= nil and input_key ~= "" then
			return input_key
		end
	end

	return ""
end

HudElementPlayerWeapon._update_input = function (self)
	local service_type = "Ingame"
	local color_tint_text = false
	local alias_name = InputDevice.gamepad_active and self._gamepad_wield_input or self._wield_input
	local input_key

	if type(alias_name) == "table" then
		input_key = _find_input_key(alias_name, service_type, color_tint_text)
	else
		input_key = InputUtils.input_text_for_current_input_device(service_type, alias_name, color_tint_text)
	end

	local faded = self._wielded

	self:set_input_text(input_key, faded)
end

HudElementPlayerWeapon.set_input_text = function (self, text, faded)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.input_text

	widget.content.text = text or " "
	widget.style.text.text_color[1] = faded and 63 or 255
	widget.dirty = true
end

HudElementPlayerWeapon.set_icon = function (self, icon, is_weapon)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.icon
	local content = widget.content

	content.icon = icon
	widget.dirty = true

	if is_weapon then
		local weapon_icon_size = HudElementPlayerWeaponHandlerSettings.weapon_icon_size
		local icon_style = widget.style.icon

		icon_style.size[1] = weapon_icon_size[1]
		icon_style.default_size[1] = weapon_icon_size[1]
		widget.dirty = true
	end
end

HudElementPlayerWeapon._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPlayerWeaponSettings.events

	for ii = 1, #events do
		local event = events[ii]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementPlayerWeapon._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPlayerWeaponSettings.events

	for ii = 1, #events do
		local event = events[ii]

		event_manager:unregister(self, event[1])
	end
end

HudElementPlayerWeapon.event_on_input_changed = function (self)
	self._updated_input_text = true
end

return HudElementPlayerWeapon
