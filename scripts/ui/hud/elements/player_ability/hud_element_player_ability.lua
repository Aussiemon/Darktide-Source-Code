-- chunkname: @scripts/ui/hud/elements/player_ability/hud_element_player_ability.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local HudElementPlayerAbilitySettings = require("scripts/ui/hud/elements/player_ability/hud_element_player_ability_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local InputUtils = require("scripts/managers/input/input_utils")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementPlayerAbility = class("HudElementPlayerAbility", "HudElementBase")

HudElementPlayerAbility.init = function (self, parent, draw_layer, start_scale, data)
	local definition_path = data.definition_path
	local definitions = dofile(definition_path)

	HudElementPlayerAbility.super.init(self, parent, draw_layer, start_scale, definitions)

	self._data = data

	local weapon_slots = {}
	local slot_configuration = PlayerCharacterConstants.slot_configuration

	for slot_id, config in pairs(slot_configuration) do
		if config.category == "weapon" then
			weapon_slots[#weapon_slots + 1] = slot_id
		end
	end

	self._weapon_slots = weapon_slots
	self._ability_type = data.ability_id
	self._slot_id = data.slot_id

	self:set_charges_amount(99)
	self:set_icon(data.icon, data.icon_ramp)
	self:update_shape(data.icon_mask, data.frame, data.frame_glow, data.frame_glow_spin)
	self:_update_input()
	self:_register_events()
end

HudElementPlayerAbility.destroy = function (self, ui_renderer)
	self:_unregister_events()
	HudElementPlayerAbility.super.destroy(self, ui_renderer)
end

HudElementPlayerAbility._update_input = function (self)
	local ability_type = self._ability_type
	local service_type = "Ingame"
	local alias_name = ability_type
	local color_tint_text = false
	local input_key = InputUtils.input_text_for_current_input_device(service_type, alias_name, color_tint_text)

	self:set_input_text(input_key)
end

HudElementPlayerAbility.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerAbility.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local player = self._data.player
	local parent = self._parent
	local ability_extension = parent:get_player_extension(player, "ability_system")
	local ability_type = self._ability_type
	local cooldown_progress, remaining_ability_charges
	local has_charges_left = true
	local has_more_than_one_charge = false
	local in_process_of_going_on_cooldown = false
	local force_on_cooldown = false

	if ability_extension and ability_extension:ability_is_equipped(ability_type) then
		local max_ability_resource = ability_extension:max_ability_resource(ability_type)
		local ability_resource_regen_progress = ability_extension:get_ability_resource_regen_progress(ability_type)
		local is_paused = ability_extension:is_ability_resource_regen_paused(ability_type)
		local max_ability_charges = ability_extension:max_ability_charges(ability_type)

		remaining_ability_charges = ability_extension:remaining_ability_charges(ability_type)
		has_charges_left = remaining_ability_charges > 0
		has_more_than_one_charge = max_ability_charges and max_ability_charges > 1

		local should_show_empty_cooldown = is_paused

		if should_show_empty_cooldown then
			cooldown_progress = 0
		elseif max_ability_resource and max_ability_resource > 0 then
			cooldown_progress = ability_resource_regen_progress
		else
			cooldown_progress = has_more_than_one_charge and 1 or 0
		end

		local pause_cooldown_settings = ability_extension:ability_pause_cooldown_settings(ability_type)

		if pause_cooldown_settings then
			local duration_tracking_buff = pause_cooldown_settings.duration_tracking_buff

			if duration_tracking_buff then
				if type(duration_tracking_buff) == "table" then
					for _, duration_tracking_buff_name in ipairs(duration_tracking_buff) do
						local buff_extension = parent:get_player_extension(player, "buff_system")

						if buff_extension:current_stacks(duration_tracking_buff_name) > 0 then
							cooldown_progress = buff_extension:buff_duration_progress(duration_tracking_buff_name)
							in_process_of_going_on_cooldown = cooldown_progress > 0

							break
						end
					end
				else
					local buff_extension = parent:get_player_extension(player, "buff_system")

					if buff_extension:current_stacks(duration_tracking_buff) > 0 then
						cooldown_progress = buff_extension:buff_duration_progress(duration_tracking_buff)
						in_process_of_going_on_cooldown = cooldown_progress > 0
					end
				end
			end

			local on_cooldown_tracking_buff = pause_cooldown_settings.on_cooldown_tracking_buff

			if on_cooldown_tracking_buff then
				local buff_extension = parent:get_player_extension(player, "buff_system")

				if type(on_cooldown_tracking_buff) == "table" then
					for i = 1, #on_cooldown_tracking_buff do
						if buff_extension:current_stacks(on_cooldown_tracking_buff[i]) > 0 then
							force_on_cooldown = true

							break
						end
					end
				else
					force_on_cooldown = buff_extension:current_stacks(on_cooldown_tracking_buff) > 0
				end
			end
		end
	end

	if cooldown_progress ~= self._ability_progress then
		self:_set_progress(cooldown_progress)
	end

	local can_use_ability = ability_extension:can_use_ability(ability_type)
	local on_cooldown = not can_use_ability and (cooldown_progress ~= 1 and not in_process_of_going_on_cooldown or force_on_cooldown)

	if on_cooldown ~= self._on_cooldown or has_more_than_one_charge ~= self._has_more_than_one_charge or has_charges_left ~= self._has_charges_left then
		if not on_cooldown and self._on_cooldown and (not has_more_than_one_charge or has_charges_left) then
			self:_play_sound(UISoundEvents.ability_off_cooldown)
		end

		self._on_cooldown = on_cooldown
		self._has_more_than_one_charge = has_more_than_one_charge
		self._has_charges_left = has_charges_left

		self:_set_widget_state_colors(on_cooldown, has_more_than_one_charge, has_charges_left)
	end

	if remaining_ability_charges and remaining_ability_charges ~= self._remaining_ability_charges then
		self._remaining_ability_charges = remaining_ability_charges

		self:set_charges_amount(has_more_than_one_charge and remaining_ability_charges)
	end
end

HudElementPlayerAbility.set_charges_amount = function (self, amount)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.ability
	local content = widget.content

	widget.dirty = true
	content.text = amount and tostring(amount) or nil
end

HudElementPlayerAbility._set_widget_state_colors = function (self, on_cooldown, has_more_than_one_charge, has_charges_left)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.ability
	local source_colors

	if on_cooldown then
		if has_more_than_one_charge then
			if has_charges_left then
				source_colors = HudElementPlayerAbilitySettings.has_charges_cooldown_colors
			else
				source_colors = HudElementPlayerAbilitySettings.out_of_charges_cooldown_colors
			end
		else
			source_colors = HudElementPlayerAbilitySettings.cooldown_colors
		end
	elseif not has_more_than_one_charge or has_more_than_one_charge and has_charges_left then
		source_colors = HudElementPlayerAbilitySettings.active_colors
	else
		source_colors = HudElementPlayerAbilitySettings.inactive
	end

	local style = widget.style

	for pass_id, pass_style in pairs(style) do
		local source_color = source_colors[pass_id]

		if source_color then
			ColorUtilities.color_copy(source_color, pass_style.color or pass_style.text_color)
		end
	end
end

HudElementPlayerAbility.set_input_text = function (self, text)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.ability

	widget.content.input_text = text
	widget.dirty = true
end

HudElementPlayerAbility.set_icon = function (self, icon, icon_ramp)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.ability
	local style = widget.style

	if icon then
		style.icon.material_values.talent_icon = icon
	end

	if icon_ramp then
		style.icon.material_values.ramp = icon_ramp
	end

	widget.dirty = true
end

HudElementPlayerAbility.update_shape = function (self, icon_mask, frame, frame_glow, frame_glow_spin)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.ability
	local style = widget.style

	if icon_mask then
		style.icon.material_values.mask = icon_mask
	end

	if frame then
		style.frame.material_values.texture_map = frame
	end

	if frame_glow then
		style.frame_glow.material_values.glow_shape = frame_glow
	end

	if frame_glow_spin then
		style.frame_glow.material_values.glow_spin = frame_glow_spin
	end

	widget.dirty = true
end

HudElementPlayerAbility._set_progress = function (self, progress)
	local is_nan = progress ~= progress

	progress = not is_nan and progress or 0
	self._ability_progress = progress

	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.ability
	local content = widget.content

	widget.dirty = true
	content.duration_progress = progress
end

HudElementPlayerAbility.set_visible = function (self, visible, ui_renderer, use_retained_mode)
	if use_retained_mode then
		if visible then
			self:set_dirty()
		else
			self:_destroy_widgets(ui_renderer)
		end
	end
end

HudElementPlayerAbility._destroy_widgets = function (self, ui_renderer)
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]

		UIWidget.destroy(ui_renderer, widget)
	end
end

HudElementPlayerAbility._register_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPlayerAbilitySettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end
end

HudElementPlayerAbility._unregister_events = function (self)
	local event_manager = Managers.event
	local events = HudElementPlayerAbilitySettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end
end

HudElementPlayerAbility.event_on_input_changed = function (self)
	self:_update_input()
end

return HudElementPlayerAbility
