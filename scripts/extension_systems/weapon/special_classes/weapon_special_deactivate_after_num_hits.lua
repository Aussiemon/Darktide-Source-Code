local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialDeactivateAfterNumHits = class("WeaponSpecialDeactivateAfterNumHits")

WeaponSpecialDeactivateAfterNumHits.init = function (self, context, init_data)
	self._input_extension = context.input_extension
	self._inventory_slot_component = init_data.inventory_slot_component
	self._tweak_data = init_data.tweak_data
	self._player_unit = context.player_unit
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
end

WeaponSpecialDeactivateAfterNumHits.update = function (self, dt, t)
	WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)
end

WeaponSpecialDeactivateAfterNumHits.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction)
	local max_hits = self._tweak_data.num_hits

	if max_hits <= num_hit_enemies then
		self._inventory_slot_component.special_active = false
		self._inventory_slot_component.num_special_activations = 0
	end
end

WeaponSpecialDeactivateAfterNumHits.on_action_start = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialDeactivateAfterNumHits.on_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialDeactivateAfterNumHits.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

implements(WeaponSpecialDeactivateAfterNumHits, WeaponSpecialInterface)

return WeaponSpecialDeactivateAfterNumHits
