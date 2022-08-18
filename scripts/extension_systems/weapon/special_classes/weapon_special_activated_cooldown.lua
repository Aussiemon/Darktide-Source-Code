local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecialActivatedCooldown = class("WeaponSpecialActivatedCooldown")

WeaponSpecialActivatedCooldown.init = function (self, weapon_special_context, weapon_special_init_data)
	self._input_extension = weapon_special_context.input_extension
	local tweak_data = weapon_special_init_data.tweak_data
	self._tweak_data = tweak_data
	self._inventory_slot_component = weapon_special_init_data.inventory_slot_component
end

WeaponSpecialActivatedCooldown.update = function (self, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local tweak_data = self._tweak_data

	if inventory_slot_component.special_active then
		self:_update_active(dt, t, inventory_slot_component, tweak_data)
	else
		self:_update_activation(dt, t, inventory_slot_component, tweak_data)
	end
end

WeaponSpecialActivatedCooldown.on_action_start = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialActivatedCooldown.on_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialActivatedCooldown.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialActivatedCooldown._update_active = function (self, dt, t, inventory_slot_component, tweak_data)
	local active_to = inventory_slot_component.special_active_start_t + tweak_data.active_time

	if t > active_to then
		inventory_slot_component.special_active = false
		inventory_slot_component.num_special_activations = 0
	elseif self._input_extension:get("weapon_extra_pressed") then
		inventory_slot_component.special_active = false
		inventory_slot_component.num_special_activations = 0
	end
end

WeaponSpecialActivatedCooldown._update_activation = function (self, dt, t, inventory_slot_component, tweak_data)
	local on_cooldown = t < inventory_slot_component.special_active_start_t + tweak_data.cooldown_time

	if on_cooldown then
		return
	end

	if self._input_extension:get("weapon_extra_pressed") then
		inventory_slot_component.special_active = true
		inventory_slot_component.special_active_start_t = t
	end
end

WeaponSpecialActivatedCooldown.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction)
	return
end

implements(WeaponSpecialActivatedCooldown, WeaponSpecialInterface)

return WeaponSpecialActivatedCooldown
