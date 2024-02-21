local AttackSettings = require("scripts/settings/damage/attack_settings")
local HitReaction = require("scripts/utilities/attack/hit_reaction")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local attack_types = AttackSettings.attack_types
local WeaponSpecialSelfDisorientation = class("WeaponSpecialSelfDisorientation")

WeaponSpecialSelfDisorientation.init = function (self, context, init_data)
	local player_unit = context.player_unit
	self._player_unit = player_unit
	self._is_server = context.is_server
	self._world = context.world
	self._physics_world = context.physics_world
	self._input_extension = context.input_extension
	self._tweak_data = init_data.tweak_data
	self._weapon_template = init_data.weapon_template
	self._animation_extension = context.animation_extension
	local unit_data_extension = context.unit_data_extension
	self._unit_data_extension = unit_data_extension
	self._locomotion_push_component = unit_data_extension:write_component("locomotion_push")
	self._inventory_slot_component = init_data.inventory_slot_component
	self._buff_extension = ScriptUnit.extension(player_unit, "buff_system")
end

WeaponSpecialSelfDisorientation.update = function (self, dt, t)
	WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)
end

WeaponSpecialSelfDisorientation.on_special_activation = function (self, t)
	return
end

WeaponSpecialSelfDisorientation.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialSelfDisorientation.on_sweep_action_finish = function (self, t, num_hit_enemies)
	local inventory_slot_component = self._inventory_slot_component

	if num_hit_enemies > 0 and inventory_slot_component.special_active then
		inventory_slot_component.special_active = false
		inventory_slot_component.num_special_activations = 0
		local deactivation_animation = self._tweak_data.deactivation_animation

		if deactivation_animation then
			self:trigger_anim_event(deactivation_animation, deactivation_animation)
		end
	end
end

WeaponSpecialSelfDisorientation.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, abort_attack, optional_origin_slot)
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

	local hazard_prop_extension = ScriptUnit.has_extension(target_unit, "hazard_prop_system")

	if hazard_prop_extension then
		return
	end

	local direction = Vector3.normalize(POSITION_LOOKUP[player_unit] - POSITION_LOOKUP[target_unit])
	local disorientation_type = tweak_data.disorientation_type

	if disorientation_type then
		HitReaction.disorient_player(player_unit, self._unit_data_extension, disorientation_type, true, true, direction, attack_types.melee, self._weapon_template, true)
	end

	local push_template = tweak_data.push_template

	if push_template then
		Push.add(player_unit, self._locomotion_push_component, direction, push_template, attack_types.melee)
	end

	local inventory_slot_component = self._inventory_slot_component
	inventory_slot_component.special_active = false
	inventory_slot_component.num_special_activations = 0
	local deactivation_animation = self._tweak_data.deactivation_animation

	if deactivation_animation then
		self:trigger_anim_event(deactivation_animation, deactivation_animation)
	end
end

WeaponSpecialSelfDisorientation.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialSelfDisorientation.trigger_anim_event = function (self, anim_event, anim_event_3p, action_time_offset, ...)
	local anim_ext = self._animation_extension
	local time_scale = 1
	action_time_offset = action_time_offset or 0

	anim_ext:anim_event_with_variable_floats_1p(anim_event, "attack_speed", time_scale, "action_time_offset", action_time_offset, ...)

	if anim_event_3p then
		anim_ext:anim_event_with_variable_floats(anim_event_3p, "attack_speed", time_scale, "action_time_offset", action_time_offset, ...)
	end
end

implements(WeaponSpecialSelfDisorientation, WeaponSpecialInterface)

return WeaponSpecialSelfDisorientation
