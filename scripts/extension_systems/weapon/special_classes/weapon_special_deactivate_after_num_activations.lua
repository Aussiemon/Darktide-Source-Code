local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecialDeactivateAfterNumActivations = class("WeaponSpecialDeactivateAfterNumActivations")

WeaponSpecialDeactivateAfterNumActivations.init = function (self, context, init_data)
	self._input_extension = context.input_extension
	self._weapon_extension = context.weapon_extension
	self._inventory_slot_component = init_data.inventory_slot_component
	self._tweak_data = init_data.tweak_data
	self._player_unit = context.player_unit
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	self._warp_charge_component = context.warp_charge_component
end

WeaponSpecialDeactivateAfterNumActivations.update = function (self, dt, t)
	WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)
end

WeaponSpecialDeactivateAfterNumActivations.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, abort_attack, optional_origin_slot)
	if target_is_alive then
		self._inventory_slot_component.special_active_start_t = t
	end
end

WeaponSpecialDeactivateAfterNumActivations.on_action_start = function (self, t, num_hit_enemies)
	local charge_template = self._weapon_extension:charge_template()

	if charge_template then
		WarpCharge.increase_immediate(t, nil, self._warp_charge_component, charge_template, self._player_unit)
	end
end

WeaponSpecialDeactivateAfterNumActivations.on_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialDeactivateAfterNumActivations.on_exit_damage_window = function (self, t, num_hit_enemies)
	if self._inventory_slot_component.special_active and num_hit_enemies > 0 then
		self._inventory_slot_component.num_special_activations = self._inventory_slot_component.num_special_activations + 1
		self._inventory_slot_component.special_active_start_t = t
	end
end

implements(WeaponSpecialDeactivateAfterNumActivations, WeaponSpecialInterface)

return WeaponSpecialDeactivateAfterNumActivations
