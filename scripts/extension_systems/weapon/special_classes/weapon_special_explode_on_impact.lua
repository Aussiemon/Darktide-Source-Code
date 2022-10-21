require("scripts/extension_systems/weapon/special_classes/weapon_special_self_disorientation")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local attack_types = AttackSettings.attack_types
local WeaponSpecialExplodeOnImpact = class("WeaponSpecialExplodeOnImpact", "WeaponSpecialSelfDisorientation")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level

WeaponSpecialExplodeOnImpact.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, optional_origin_slot)
	local special_active = self._inventory_slot_component.special_active

	if target_is_alive and special_active and self._is_server then
		local explosion_template = self._tweak_data.explosion_template

		Explosion.create_explosion(self._world, self._physics_world, hit_position, attack_direction, self._player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion, false, false, weapon.item, optional_origin_slot)
	end

	WeaponSpecialExplodeOnImpact.super.process_hit(self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction)
end

implements(WeaponSpecialExplodeOnImpact, WeaponSpecialInterface)

return WeaponSpecialExplodeOnImpact
