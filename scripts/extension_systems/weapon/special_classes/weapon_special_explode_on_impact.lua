require("scripts/extension_systems/weapon/special_classes/weapon_special_self_disorientation")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local attack_types = AttackSettings.attack_types
local WeaponSpecialExplodeOnImpact = class("WeaponSpecialExplodeOnImpact")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level

WeaponSpecialExplodeOnImpact.init = function (self, context, init_data)
	local player_unit = context.player_unit
	self._player_unit = player_unit
	self._is_server = context.is_server
	self._world = context.world
	self._physics_world = context.physics_world
	self._input_extension = context.input_extension
	self._tweak_data = init_data.tweak_data
	self._weapon_template = init_data.weapon_template
	local unit_data_extension = context.unit_data_extension
	self._unit_data_extension = unit_data_extension
	self._locomotion_push_component = unit_data_extension:write_component("locomotion_push")
	self._inventory_slot_component = init_data.inventory_slot_component
	self._buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	self._num_hit_enemies = 0
end

WeaponSpecialExplodeOnImpact.update = function (self, dt, t)
	if self._num_hit_enemies <= 0 then
		WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)
	end
end

WeaponSpecialExplodeOnImpact.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, abort_attack, optional_origin_slot)
	self._num_hit_enemies = num_hit_enemies
	local special_active = self._inventory_slot_component.special_active
	local player_position = POSITION_LOOKUP[self._player_unit] + Vector3(0, 0, 0.75)
	local explosion_direction = 0.5 * Vector3.normalize(player_position - hit_position)

	if target_is_alive and special_active and self._is_server and num_hit_enemies == 1 then
		local explosion_template = self._tweak_data.explosion_template

		Explosion.create_explosion(self._world, self._physics_world, hit_position + explosion_direction, attack_direction, self._player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion, false, false, weapon.item, optional_origin_slot)
	end
end

WeaponSpecialExplodeOnImpact.on_action_start = function (self, t, num_hit_enemies)
	self._num_hit_enemies = 0
end

WeaponSpecialExplodeOnImpact.on_action_finish = function (self, t, num_hit_enemies)
	if num_hit_enemies and num_hit_enemies > 0 then
		local inventory_slot_component = self._inventory_slot_component
		inventory_slot_component.special_active = false
		inventory_slot_component.num_special_activations = 0
	end

	self._num_hit_enemies = 0
end

WeaponSpecialExplodeOnImpact.on_exit_damage_window = function (self, t, num_hit_enemies)
	if num_hit_enemies and num_hit_enemies > 0 then
		local inventory_slot_component = self._inventory_slot_component
		inventory_slot_component.special_active = false
		inventory_slot_component.num_special_activations = 0
	end

	self._num_hit_enemies = 0
end

implements(WeaponSpecialExplodeOnImpact, WeaponSpecialInterface)

return WeaponSpecialExplodeOnImpact
