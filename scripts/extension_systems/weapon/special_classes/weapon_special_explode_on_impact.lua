require("scripts/extension_systems/weapon/special_classes/weapon_special_self_disorientation")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local Armor = require("scripts/utilities/attack/armor")
local Armor = require("scripts/utilities/attack/armor")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local attack_types = AttackSettings.attack_types
local armor_types = ArmorSettings.types
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

local extra_explosion_armortype = {
	[armor_types.armored] = true,
	[armor_types.super_armor] = true
}

WeaponSpecialExplodeOnImpact.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction, abort_attack, optional_origin_slot)
	self._num_hit_enemies = num_hit_enemies
	local inventory_slot_component = self._inventory_slot_component
	local special_active = inventory_slot_component.special_active
	local num_special_activations = inventory_slot_component.num_special_activations
	local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local target_breed_or_nil = target_unit_data_extension and target_unit_data_extension:breed()
	local armor_type = target_breed_or_nil and Armor.armor_type(target_unit, target_breed_or_nil)
	local first_target = num_hit_enemies == 1
	local buff_extension = self._buff_extension
	local stat_buffs = buff_extension:stat_buffs()
	local extra_explosions = stat_buffs.weapon_special_max_activations or 0
	local extra_explosion = num_special_activations < 1 + extra_explosions and armor_type and extra_explosion_armortype[armor_type]
	local should_explode = target_is_alive and special_active and (first_target or extra_explosion)

	if should_explode then
		local player_position = POSITION_LOOKUP[self._player_unit] + Vector3(0, 0, 0.75)
		local explosion_direction = 0.5 * Vector3.normalize(player_position - hit_position)
		local tweak_data = action_settings.weapon_special_tweak_data or self._tweak_data
		local explosion_template = tweak_data.explosion_template

		Explosion.create_explosion(self._world, self._physics_world, hit_position + explosion_direction, attack_direction, self._player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion, false, false, weapon.item, optional_origin_slot, nil, nil, nil, true)

		inventory_slot_component.num_special_activations = num_special_activations + 1
	end
end

WeaponSpecialExplodeOnImpact.on_special_activation = function (self, t, num_hit_enemies)
	self._num_hit_enemies = 0
	local inventory_slot_component = self._inventory_slot_component
	inventory_slot_component.num_special_activations = 0
end

WeaponSpecialExplodeOnImpact.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialExplodeOnImpact.on_sweep_action_finish = function (self, t, num_hit_enemies)
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
