local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local attack_types = AttackSettings.attack_types
local stat_buff_types = BuffSettings.stat_buffs
local WeaponSpeciaShovels = class("WeaponSpeciaShovels")

WeaponSpeciaShovels.init = function (self, context, init_data)
	self._input_extension = context.input_extension
	self._weapon_extension = context.weapon_extension
	self._animation_extension = context.animation_extension
	self._inventory_slot_component = init_data.inventory_slot_component
	self._tweak_data = init_data.tweak_data
	self._player_unit = context.player_unit
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	self._warp_charge_component = context.warp_charge_component
	local unit_data_extension = context.unit_data_extension
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._locomotion_push_component = unit_data_extension:write_component("locomotion_push")
end

WeaponSpeciaShovels.update = function (self, dt, t)
	local time_to_play_deactivation_animation = self._time_to_play_deactivation_animation

	if time_to_play_deactivation_animation then
		time_to_play_deactivation_animation = time_to_play_deactivation_animation - dt

		if time_to_play_deactivation_animation <= 0 then
			local tweak_data = self._tweak_data
			local deactivation_animation = tweak_data.deactivation_animation

			self:trigger_anim_event(deactivation_animation, deactivation_animation)

			self._time_to_play_deactivation_animation = nil
		else
			self._time_to_play_deactivation_animation = time_to_play_deactivation_animation
		end
	end
end

WeaponSpeciaShovels.on_special_activation = function (self, t)
	return
end

WeaponSpeciaShovels.on_sweep_action_start = function (self, t)
	return
end

WeaponSpeciaShovels.on_sweep_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpeciaShovels.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, abort_attack, optional_origin_slot)
	local special_active = self._inventory_slot_component.special_active
	local player_unit = self._player_unit
	local tweak_data = self._tweak_data

	if not special_active or not target_is_alive then
		return
	end

	local only_deactive_on_abort = tweak_data.only_deactive_on_abort

	if only_deactive_on_abort and not abort_attack then
		return
	end

	local direction = Vector3.normalize(POSITION_LOOKUP[player_unit] - POSITION_LOOKUP[target_unit])
	local push_template = tweak_data.push_template

	if push_template then
		Push.add(player_unit, self._locomotion_push_component, direction, push_template, attack_types.melee)
	end
end

WeaponSpeciaShovels.on_exit_damage_window = function (self, t, num_hit_enemies, aborted)
	local inventory_slot_component = self._inventory_slot_component
	local tweak_data = self._tweak_data
	local is_sticky = self._action_sweep_component.is_sticky

	if inventory_slot_component.special_active and num_hit_enemies > 0 then
		inventory_slot_component.special_active = false
		local delay = tweak_data.deactivation_animation_delay or 0
		local deactivation_animation_on_abort = tweak_data.deactivation_animation_on_abort
		self._time_to_play_deactivation_animation = (not aborted or deactivation_animation_on_abort) and not is_sticky and delay or nil
	end
end

WeaponSpeciaShovels.trigger_anim_event = function (self, anim_event, anim_event_3p, action_time_offset, ...)
	local anim_ext = self._animation_extension
	local time_scale = 1
	action_time_offset = action_time_offset or 0

	anim_ext:anim_event_with_variable_floats_1p(anim_event, "attack_speed", time_scale, "action_time_offset", action_time_offset, ...)

	if anim_event_3p then
		anim_ext:anim_event_with_variable_floats(anim_event_3p, "attack_speed", time_scale, "action_time_offset", action_time_offset, ...)
	end
end

implements(WeaponSpeciaShovels, WeaponSpecialInterface)

return WeaponSpeciaShovels
