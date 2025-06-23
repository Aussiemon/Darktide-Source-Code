-- chunkname: @scripts/extension_systems/weapon/special_classes/weapon_special_fake_separate_ammo_pool.lua

local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecialFakeSeparateAmmoPool = class("WeaponSpecialFakeSeparateAmmoPool")

WeaponSpecialFakeSeparateAmmoPool.init = function (self, context, init_data)
	local player_unit = context.player_unit
	local tweak_data = init_data.tweak_data
	local inventory_slot_component = init_data.inventory_slot_component

	self._player_unit = player_unit
	self._is_server = context.is_server
	self._world = context.world
	self._physics_world = context.physics_world
	self._input_extension = context.input_extension
	self._tweak_data = tweak_data
	self._weapon_template = init_data.weapon_template
	self._weapon_extension = context.weapon_extension

	local unit_data_extension = context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._locomotion_push_component = unit_data_extension:write_component("locomotion_push")
	self._inventory_slot_component = inventory_slot_component
end

WeaponSpecialFakeSeparateAmmoPool.on_wieldable_slot_equipped = function (self)
	self._inventory_slot_component.num_special_charges = self._tweak_data.max_num_charges
	self._inventory_slot_component.max_num_special_charges = self._tweak_data.max_num_charges
end

WeaponSpecialFakeSeparateAmmoPool.fixed_update = function (self, dt, t)
	return
end

WeaponSpecialFakeSeparateAmmoPool.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, damage, result, damage_efficiency, stagger_result, hit_position, attack_direction, abort_attack, optional_origin_slot)
	return
end

WeaponSpecialFakeSeparateAmmoPool.blocked_attack = function (self, attacking_unit, block_cost, block_broken, is_perfect_block)
	return
end

WeaponSpecialFakeSeparateAmmoPool.on_special_activation = function (self, t, num_hit_enemies)
	self._inventory_slot_component.num_special_charges = math.max(self._inventory_slot_component.num_special_charges - 1, 0)
end

WeaponSpecialFakeSeparateAmmoPool.on_special_deactivation = function (self, t)
	return
end

WeaponSpecialFakeSeparateAmmoPool.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialFakeSeparateAmmoPool.on_sweep_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialFakeSeparateAmmoPool.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

implements(WeaponSpecialFakeSeparateAmmoPool, WeaponSpecialInterface)

return WeaponSpecialFakeSeparateAmmoPool
