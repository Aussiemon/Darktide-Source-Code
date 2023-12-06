local BuffSettings = require("scripts/settings/buff/buff_settings")
local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local stat_buff_types = BuffSettings.stat_buffs
local WeaponSpecialDeactivateAfterNumActivations = class("WeaponSpecialDeactivateAfterNumActivations")

WeaponSpecialDeactivateAfterNumActivations.init = function (self, context, init_data)
	self._input_extension = context.input_extension
	self._weapon_extension = context.weapon_extension
	self._animation_extension = context.animation_extension
	self._inventory_slot_component = init_data.inventory_slot_component
	self._tweak_data = init_data.tweak_data
	self._player_unit = context.player_unit
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	self._warp_charge_component = context.warp_charge_component
end

WeaponSpecialDeactivateAfterNumActivations.update = function (self, dt, t)
	WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)
end

WeaponSpecialDeactivateAfterNumActivations.on_special_activation = function (self, t)
	local charge_template = self._weapon_extension:charge_template()

	if charge_template then
		WarpCharge.increase_immediate(t, nil, self._warp_charge_component, charge_template, self._player_unit)
	end
end

WeaponSpecialDeactivateAfterNumActivations.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialDeactivateAfterNumActivations.on_sweep_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialDeactivateAfterNumActivations.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, abort_attack, optional_origin_slot)
	if target_is_alive then
		self._inventory_slot_component.special_active_start_t = t
	end
end

WeaponSpecialDeactivateAfterNumActivations.on_exit_damage_window = function (self, t, num_hit_enemies, aborted)
	if self._inventory_slot_component.special_active and (num_hit_enemies > 0 or aborted) then
		self._inventory_slot_component.num_special_activations = self._inventory_slot_component.num_special_activations + 1
		self._inventory_slot_component.special_active_start_t = t

		WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)

		local deactivation_animation = self._tweak_data.deactivation_animation

		if deactivation_animation then
			self:trigger_anim_event(deactivation_animation, deactivation_animation)
		end
	end
end

WeaponSpecialDeactivateAfterNumActivations.trigger_anim_event = function (self, anim_event, anim_event_3p, action_time_offset, ...)
	local anim_ext = self._animation_extension
	local time_scale = 1
	action_time_offset = action_time_offset or 0

	anim_ext:anim_event_with_variable_floats_1p(anim_event, "attack_speed", time_scale, "action_time_offset", action_time_offset, ...)

	if anim_event_3p then
		anim_ext:anim_event_with_variable_floats(anim_event_3p, "attack_speed", time_scale, "action_time_offset", action_time_offset, ...)
	end
end

implements(WeaponSpecialDeactivateAfterNumActivations, WeaponSpecialInterface)

return WeaponSpecialDeactivateAfterNumActivations
