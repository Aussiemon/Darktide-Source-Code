-- chunkname: @scripts/extension_systems/weapon/special_classes/weapon_special_cooldown_charges.lua

local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecialCooldownCharges = class("WeaponSpecialCooldownCharges")

WeaponSpecialCooldownCharges.UPDATE_WHEN_UNWIELDED = true

WeaponSpecialCooldownCharges.init = function (self, context, init_data)
	local player_unit = context.player_unit

	self._player_unit = player_unit
	self._is_server = context.is_server
	self._world = context.world
	self._physics_world = context.physics_world
	self._input_extension = context.input_extension
	self._tweak_data = init_data.tweak_data
	self._weapon_template = init_data.weapon_template
	self._weapon_extension = context.weapon_extension

	local unit_data_extension = context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._locomotion_push_component = unit_data_extension:write_component("locomotion_push")
	self._inventory_slot_component = init_data.inventory_slot_component
	self._inventory_slot_component.max_num_special_charges = self._tweak_data.max_num_charges
	self._inventory_slot_component.num_special_charges = self._tweak_data.max_num_charges
	self._buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	self._next_charge_recovery_time = 0
end

WeaponSpecialCooldownCharges.on_wieldable_slot_equipped = function (self)
	self._inventory_slot_component.max_num_special_charges = self._tweak_data.max_num_charges
end

WeaponSpecialCooldownCharges.fixed_update = function (self, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local tweak_data = self._tweak_data
	local current_num_charges = inventory_slot_component.num_special_charges
	local max_num_charges = tweak_data.max_num_charges
	local at_max_charges = max_num_charges <= current_num_charges

	if not at_max_charges and t >= self._next_charge_recovery_time then
		inventory_slot_component.num_special_charges = math.min(current_num_charges + 1, max_num_charges)
		self._next_charge_recovery_time = t + tweak_data.cooldown
	end
end

WeaponSpecialCooldownCharges.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, damage, result, damage_efficiency, stagger_result, hit_position, attack_direction, abort_attack, optional_origin_slot)
	return
end

WeaponSpecialCooldownCharges.blocked_attack = function (self, attacking_unit, block_cost, block_broken, is_perfect_block)
	return
end

WeaponSpecialCooldownCharges.on_special_activation = function (self, t)
	local inventory_slot_component = self._inventory_slot_component
	local tweak_data = self._tweak_data
	local num_charges_to_consume_on_activation = tweak_data.num_charges_to_consume_on_activation

	inventory_slot_component.num_special_charges = math.max(inventory_slot_component.num_special_charges - num_charges_to_consume_on_activation, 0)
	self._next_charge_recovery_time = t + tweak_data.cooldown + tweak_data.active_duration
end

WeaponSpecialCooldownCharges.on_special_deactivation = function (self, t)
	return
end

WeaponSpecialCooldownCharges.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialCooldownCharges.on_sweep_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialCooldownCharges.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialCooldownCharges.on_weapon_shout_action_finish = function (self, t, aborted)
	return
end

implements(WeaponSpecialCooldownCharges, WeaponSpecialInterface)

return WeaponSpecialCooldownCharges
