-- chunkname: @scripts/ui/hud/elements/player_weapon/hud_element_player_weapon.lua

local HudElementPlayerWeaponHandlerSettings = require("scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler_settings")
local HudElementPlayerWeaponSettings = require("scripts/ui/hud/elements/player_weapon/hud_element_player_weapon_settings")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
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
	self._ability_type = data.ability_type
	self._ability_extension = data.ability_extension

	local slot_settings = self._slot_name and ItemSlotSettings[self._slot_name]

	self._wield_input = self._ability_type or slot_settings.wield_input
	self._gamepad_wield_input = slot_settings and slot_settings.gamepad_wield_input or self._wield_input
	self._hide_input_on_gamepad_wielded = slot_settings and slot_settings.hide_input_on_gamepad_wielded

	local weapon_template = data.weapon_template

	self._weapon_name = data.weapon_name
	self._weapon_template = weapon_template

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

	self:_set_ammo_amount(nil, nil)

	if data.icon then
		self:set_icon(data.icon)
	else
		local item = data.item
		local hud_icon = item.hud_icon

		hud_icon = hud_icon or self._slot_name == "slot_primary" and "content/ui/materials/icons/weapons/hud/combat_blade_01" or "content/ui/materials/icons/weapons/hud/autogun_01"

		self:set_icon(hud_icon, is_weapon)
	end

	local hud_configuration = weapon_template.hud_configuration
	local uses_ammo = hud_configuration and hud_configuration.uses_ammunition
	local uses_overheat = hud_configuration and hud_configuration.uses_overheat
	local infinite_ammo = not uses_ammo and uses_overheat

	self._infinite_ammo = infinite_ammo
	self._widgets_by_name.infinite_symbol.content.visible = not not infinite_ammo
	self._widgets_by_name.ammo_text.content.visible = not not not infinite_ammo
	self._uses_ammo = uses_ammo
	self._uses_overheat = uses_overheat

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
	local ability_type = self._ability_type

	if ability_type then
		local ability_extension = self._ability_extension
		local remaining_ability_charges = ability_extension:remaining_ability_charges(ability_type)
		local max_ability_charges = ability_extension:max_ability_charges(ability_type)

		if self._uses_ammo and self._total_ammo ~= remaining_ability_charges then
			self._low_on_ammo = remaining_ability_charges <= 0

			self:_set_clip_amount(remaining_ability_charges, max_ability_charges)
			self:_set_ammo_amount(remaining_ability_charges, max_ability_charges)

			clip_information_updated = true
		end
	else
		local slot_component = self._slot_component

		if slot_component then
			if self._uses_ammo or self._uses_overheat then
				local max_reserve = slot_component.max_ammunition_reserve
				local max_ammunition_clip = slot_component.max_ammunition_clip

				if max_reserve and max_reserve > 0 then
					local current_ammunition_clip = slot_component.current_ammunition_clip
					local current_reserve = slot_component.current_ammunition_reserve
					local update_clip = self._current_ammunition_clip ~= current_ammunition_clip
					local total_ammo = current_ammunition_clip + current_reserve
					local total_max_ammo = max_reserve + max_ammunition_clip
					local update_total = self._total_ammo ~= total_ammo

					if update_clip or update_total or clip_information_updated then
						self:_set_clip_amount(current_ammunition_clip, max_ammunition_clip)

						clip_information_updated = true
					end

					if update_total or update_clip then
						if self._total_ammo and total_ammo > self._total_ammo then
							self._ammo_refill_progress = 0
						end

						self._low_on_ammo = total_ammo / total_max_ammo <= 0.2

						self:_set_ammo_amount(total_ammo, total_max_ammo)

						clip_information_updated = true
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
	widgets_by_name.ammo_text.offset[2] = height_offset
	widgets_by_name.ammo_text.dirty = true
end

HudElementPlayerWeapon._set_alpha = function (self, alpha_fraction)
	local general_fraction = 0.8 + alpha_fraction * 0.2
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.background.alpha_multiplier = 1
	widgets_by_name.icon.alpha_multiplier = general_fraction
	widgets_by_name.infinite_symbol.alpha_multiplier = general_fraction
	widgets_by_name.ammo_text.alpha_multiplier = general_fraction
end

HudElementPlayerWeapon.is_weapon = function (self)
	return self._is_weapon
end

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

	widgets_by_name.ammo_text.offset[1] = -icon_size[1] + (default_ammo_offset[1] + (small_ammo_offset[1] - default_ammo_offset[1]) * inverse_progress)
	widgets_by_name.input_text.offset[1] = size[1] - width_difference * inverse_progress

	if self._infinite_ammo then
		_animate_color_value(widgets_by_name.infinite_symbol.style.texture.color, progress, color_tint_main_3, color_tint_main_2)

		local infinite_symbol_size = HudElementPlayerWeaponSettings.infinite_symbol_size
		local infinite_symbol_size_focused = HudElementPlayerWeaponSettings.infinite_symbol_size_focused
		local infinite_symbol_style_size = widgets_by_name.infinite_symbol.style.texture.size

		infinite_symbol_style_size[1] = (infinite_symbol_size_focused[1] - infinite_symbol_size[1]) * progress + infinite_symbol_size[1]
		infinite_symbol_style_size[2] = (infinite_symbol_size_focused[2] - infinite_symbol_size[2]) * progress + infinite_symbol_size[2]
	else
		local low_on_ammo = self._low_on_ammo
		local scenegraph_id = "background"
		local background_scenegraph_size = self:scenegraph_size(scenegraph_id)
		local background_scenegraph_height = background_scenegraph_size[2]
		local height_difference = size[2] - size_small[2]
		local extra_height = height_difference * progress
		local height_difference_scale = extra_height / size[2]
		local ammo_text_style = widgets_by_name.ammo_text.style
		local ammo_text_content = widgets_by_name.ammo_text.content

		for pass_name, pass_style in pairs(ammo_text_style) do
			local default_font_size = pass_style.default_font_size
			local focused_font_size = pass_style.focused_font_size
			local font_size_difference = focused_font_size - default_font_size
			local font_size_difference_animated = font_size_difference * progress
			local animated_font_size = default_font_size + font_size_difference_animated

			pass_style.font_size = animated_font_size

			local wielded_color = low_on_ammo and HudElementPlayerWeaponSettings.urgent_color or color_tint_main_2
			local secondary_color = low_on_ammo and HudElementPlayerWeaponSettings.urgent_color_wielded or pass_style.primary_counter and color_tint_main_1 or color_tint_main_3
			local include_alpha = false

			_animate_color_value(pass_style.text_color, progress, wielded_color, secondary_color, include_alpha)

			local index = pass_style.index
			local max_ammo_digits = HudElementPlayerWeaponSettings.max_ammo_digits

			pass_style.offset[1] = -((max_ammo_digits - index) * (animated_font_size * 0.55))

			local ammo_text = ammo_text_content[pass_name]
			local ammo_text_height = self:_style_text_height(ammo_text, pass_style, ui_renderer)

			if pass_style.clip_ammo then
				local additional_height = self._use_one_line_ammunition and 12 or 4

				pass_style.offset[2] = background_scenegraph_height * 0.5 - ammo_text_height + (additional_height - height_difference_scale * inverse_progress)
			else
				pass_style.offset[2] = background_scenegraph_height * 0.5 + (8 - height_difference_scale * inverse_progress)
			end
		end
	end
end

HudElementPlayerWeapon._style_text_height = function (self, text, text_style, ui_renderer)
	local text_size = text_style.size
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local _, text_height = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, text_size, text_options)

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

HudElementPlayerWeapon._set_clip_amount = function (self, current, total)
	self._current_ammunition_clip = current

	if total and total > 0 and (not self._max_ammunition_clip or self._max_ammunition_clip ~= total) then
		self._max_ammunition_clip = total
	end
end

HudElementPlayerWeapon._set_ammo_amount = function (self, amount, total_max_amount)
	self._total_ammo = amount

	local is_weapon = self._is_weapon
	local current_ammunition_clip = self._current_ammunition_clip
	local max_ammo_digits = HudElementPlayerWeaponSettings.max_ammo_digits

	if not self._infinite_ammo then
		local widgets_by_name = self._widgets_by_name
		local ammo_text_widget = widgets_by_name.ammo_text
		local content = ammo_text_widget.content
		local style = ammo_text_widget.style

		if current_ammunition_clip then
			local display_texts = _convert_ammo_to_display_texts(current_ammunition_clip, string.len(self._max_ammunition_clip or amount), self._low_on_ammo, current_ammunition_clip == 0, amount == 0, is_weapon)

			for ii = max_ammo_digits, 1, -1 do
				local key = "ammo_amount_" .. ii
				local text = table.remove(display_texts, #display_texts)

				content[key] = text or ""
				style[key].drop_shadow = not not text
			end
		else
			for ii = max_ammo_digits, 1, -1 do
				content["ammo_amount_" .. ii] = ""
			end
		end

		local spare_clips = is_weapon and self._max_ammunition_clip and amount - current_ammunition_clip

		if spare_clips then
			local display_texts = _convert_ammo_to_display_texts(spare_clips, string.len(total_max_amount), self._low_on_ammo, true, amount == 0, is_weapon, true)

			for ii = max_ammo_digits, 1, -1 do
				local key = "ammo_spare_" .. ii
				local text = table.remove(display_texts, #display_texts)

				content[key] = text or ""
				style[key].drop_shadow = not not text
			end

			self._use_one_line_ammunition = false
		else
			for ii = max_ammo_digits, 1, -1 do
				content["ammo_spare_" .. ii] = ""
			end

			self._use_one_line_ammunition = true
		end

		self:set_height_offset(self._height_offset or 0)

		ammo_text_widget.dirty = true
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
