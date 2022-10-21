local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialDeactivateAfterDuration = class("WeaponSpecialDeactivateAfterDuration")

WeaponSpecialDeactivateAfterDuration.init = function (self, context, init_data)
	self._input_extension = context.input_extension
	self._inventory_slot_component = init_data.inventory_slot_component
	self._tweak_data = init_data.tweak_data
	self._player_unit = context.player_unit
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
end

WeaponSpecialDeactivateAfterDuration.update = function (self, dt, t)
	WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)
end

WeaponSpecialDeactivateAfterDuration.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, optional_origin_slot)
	return
end

WeaponSpecialDeactivateAfterDuration.on_action_start = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialDeactivateAfterDuration.on_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialDeactivateAfterDuration.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

implements(WeaponSpecialDeactivateAfterDuration, WeaponSpecialInterface)

return WeaponSpecialDeactivateAfterDuration
