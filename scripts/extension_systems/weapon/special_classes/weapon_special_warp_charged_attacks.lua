-- chunkname: @scripts/extension_systems/weapon/special_classes/weapon_special_warp_charged_attacks.lua

local HazardProp = require("scripts/utilities/level_props/hazard_prop")
local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecialWarpChargedAttacks = class("WeaponSpecialWarpChargedAttacks")

WeaponSpecialWarpChargedAttacks.init = function (self, weapon_special_context, weapon_special_init_data)
	self._input_extension = weapon_special_context.input_extension
	self._weapon_extension = weapon_special_context.weapon_extension
	self._player_unit = weapon_special_context.player_unit
	self._warp_charge_component = weapon_special_context.warp_charge_component
	self._inventory_slot_component = weapon_special_init_data.inventory_slot_component

	local tweak_data = weapon_special_init_data.tweak_data

	self._tweak_data = tweak_data
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
end

WeaponSpecialWarpChargedAttacks.fixed_update = function (self, dt, t)
	WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension, self._weapon_extension)
end

WeaponSpecialWarpChargedAttacks.on_special_activation = function (self, t)
	local charge_template = self._weapon_extension:charge_template()

	if charge_template then
		WarpCharge.increase_immediate(t, nil, self._warp_charge_component, charge_template, self._player_unit)
	end
end

WeaponSpecialWarpChargedAttacks.on_special_deactivation = function (self, t)
	return
end

WeaponSpecialWarpChargedAttacks.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialWarpChargedAttacks.on_sweep_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialWarpChargedAttacks.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, damage, result, damage_efficiency, stagger_result, hit_position, attack_direction, abort_attack, optional_origin_slot)
	if not target_is_alive then
		return
	end

	local target_is_hazard_prop, hazard_prop_is_active = HazardProp.status(target_unit)

	if target_is_hazard_prop and not hazard_prop_is_active then
		return
	end

	local hit_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local target_breed_or_nil = hit_unit_data_extension and hit_unit_data_extension:breed()

	if not target_breed_or_nil then
		return
	end

	self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "max_activations")
end

WeaponSpecialWarpChargedAttacks.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

implements(WeaponSpecialWarpChargedAttacks, WeaponSpecialInterface)

return WeaponSpecialWarpChargedAttacks
