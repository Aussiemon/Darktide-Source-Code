local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local attack_types = AttackSettings.attack_types
local WeaponSpecialExplodeOnImpact = class("WeaponSpecialExplodeOnImpact")
local DEFAULT_POWER_LEVEL = 500

WeaponSpecialExplodeOnImpact.init = function (self, context, init_data)
	local player_unit = context.player_unit
	self._player_unit = player_unit
	self._is_server = context.is_server
	self._world = context.world
	self._physics_world = context.physics_world
	self._input_extension = context.input_extension
	self._tweak_data = init_data.tweak_data
	self._inventory_slot_component = init_data.inventory_slot_component
	self._buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	self._exploding_time = nil
	self._have_exploded = nil
	self._have_added_buff = nil
end

WeaponSpecialExplodeOnImpact.update = function (self, dt, t)
	WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)
end

WeaponSpecialExplodeOnImpact.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction)
	if not self._is_server then
		return
	end

	if not self._inventory_slot_component.special_active then
		return
	end

	if not target_is_alive then
		return
	end

	local explosion_template = self._tweak_data.explosion_template

	Explosion.create_explosion(self._world, self._physics_world, hit_position, attack_direction, self._player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion, nil, weapon.item)

	self._inventory_slot_component.special_active = false
	self._inventory_slot_component.num_special_activations = 0
end

WeaponSpecialExplodeOnImpact.on_action_start = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialExplodeOnImpact.on_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialExplodeOnImpact.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

implements(WeaponSpecialExplodeOnImpact, WeaponSpecialInterface)

return WeaponSpecialExplodeOnImpact
