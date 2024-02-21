local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialSimpleWarpCharge = class("WeaponSpecialSimpleWarpCharge")

WeaponSpecialSimpleWarpCharge.init = function (self, weapon_special_context, weapon_special_init_data)
	self._input_extension = weapon_special_context.input_extension
	self._weapon_extension = weapon_special_context.weapon_extension
	self._player_unit = weapon_special_context.player_unit
	self._warp_charge_component = weapon_special_context.warp_charge_component
	self._inventory_slot_component = weapon_special_init_data.inventory_slot_component
	local tweak_data = weapon_special_init_data.tweak_data
	self._tweak_data = tweak_data
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
end

WeaponSpecialSimpleWarpCharge.update = function (self, dt, t)
	WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)
end

WeaponSpecialSimpleWarpCharge.on_special_activation = function (self, t)
	local charge_template = self._weapon_extension:charge_template()

	if charge_template then
		WarpCharge.increase_immediate(t, nil, self._warp_charge_component, charge_template, self._player_unit)
	end
end

WeaponSpecialSimpleWarpCharge.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialSimpleWarpCharge.on_sweep_action_finish = function (self, t, num_hit_enemies)
	self._inventory_slot_component.special_active = false
	self._inventory_slot_component.num_special_activations = 0
end

WeaponSpecialSimpleWarpCharge.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, abort_attack, optional_origin_slot)
	return
end

WeaponSpecialSimpleWarpCharge.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

implements(WeaponSpecialSimpleWarpCharge, WeaponSpecialInterface)

return WeaponSpecialSimpleWarpCharge
