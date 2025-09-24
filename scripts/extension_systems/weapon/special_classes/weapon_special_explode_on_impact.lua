-- chunkname: @scripts/extension_systems/weapon/special_classes/weapon_special_explode_on_impact.lua

local Armor = require("scripts/utilities/attack/armor")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
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
	self._weapon_extension = context.weapon_extension

	local unit_data_extension = context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._locomotion_push_component = unit_data_extension:write_component("locomotion_push")
	self._inventory_slot_component = init_data.inventory_slot_component
	self._buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	self._num_hit_enemies = 0
end

WeaponSpecialExplodeOnImpact.on_wieldable_slot_equipped = function (self)
	return
end

WeaponSpecialExplodeOnImpact.fixed_update = function (self, dt, t)
	if self._num_hit_enemies <= 0 then
		WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension, self._weapon_extension)
	end
end

local extra_explosion_armor_types = {
	[armor_types.armored] = true,
	[armor_types.super_armor] = true,
}

WeaponSpecialExplodeOnImpact.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, damage, result, damage_efficiency, stagger_result, hit_position, attack_direction, abort_attack, optional_origin_slot)
	self._num_hit_enemies = num_hit_enemies

	local inventory_slot_component = self._inventory_slot_component
	local special_active = inventory_slot_component.special_active
	local num_special_charges = inventory_slot_component.num_special_charges

	if not target_is_alive or not special_active then
		return
	end

	local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local target_breed_or_nil = target_unit_data_extension and target_unit_data_extension:breed()
	local armor_type = target_breed_or_nil and Armor.armor_type(target_unit, target_breed_or_nil)
	local first_target = num_hit_enemies == 1
	local num_explosions = first_target and 1 or 0
	local buff_extension = self._buff_extension
	local has_extra_explosion_on_hit_armor_keyword = buff_extension:has_keyword("weapon_special_extra_explosion_on_hit_armor")

	if not self._extra_explosion_triggered and has_extra_explosion_on_hit_armor_keyword and armor_type and extra_explosion_armor_types[armor_type] then
		num_explosions = num_explosions + 1
		self._extra_explosion_triggered = true
	end

	if num_explosions == 0 then
		return
	end

	local player_position = POSITION_LOOKUP[self._player_unit] + Vector3(0, 0, 0.75)
	local explosion_direction = 0.5 * Vector3.normalize(player_position - hit_position)
	local tweak_data = action_settings.weapon_special_tweak_data or self._tweak_data
	local explosion_template = tweak_data.explosion_template

	for i = 1, num_explosions do
		Explosion.create_explosion(self._world, self._physics_world, hit_position + explosion_direction, attack_direction, self._player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion, false, false, weapon.item, optional_origin_slot, nil, nil, nil, true)
	end
end

WeaponSpecialExplodeOnImpact.blocked_attack = function (self, attacking_unit, block_cost, block_broken, is_perfect_block)
	return
end

WeaponSpecialExplodeOnImpact.on_special_activation = function (self, t, num_hit_enemies)
	self._num_hit_enemies = 0
	self._extra_explosion_triggered = false

	local inventory_slot_component = self._inventory_slot_component

	inventory_slot_component.num_special_charges = 0
end

WeaponSpecialExplodeOnImpact.on_special_deactivation = function (self, t)
	return
end

WeaponSpecialExplodeOnImpact.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialExplodeOnImpact.on_sweep_action_finish = function (self, t, num_hit_enemies)
	if num_hit_enemies and num_hit_enemies > 0 then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "max_activations")
	end

	self._num_hit_enemies = 0
end

WeaponSpecialExplodeOnImpact.on_exit_damage_window = function (self, t, num_hit_enemies)
	if num_hit_enemies and num_hit_enemies > 0 then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "max_activations")
	end

	self._num_hit_enemies = 0
end

implements(WeaponSpecialExplodeOnImpact, WeaponSpecialInterface)

return WeaponSpecialExplodeOnImpact
