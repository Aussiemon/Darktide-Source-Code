-- chunkname: @scripts/extension_systems/weapon/special_classes/weapon_special_kill_count_charges.lua

local Breed = require("scripts/utilities/breed")
local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecialKillCountCharges = class("WeaponSpecialKillCountCharges")

WeaponSpecialKillCountCharges.UPDATE_WHEN_UNWIELDED = true

local default_breed_tag_charges = {
	captain = 10,
	elite = 2,
	monster = 10,
	ogryn = 2,
	special = 2,
}
local default_num_charges_to_add = 1

WeaponSpecialKillCountCharges.init = function (self, context, init_data)
	self._input_extension = context.input_extension
	self._weapon_extension = context.weapon_extension
	self._animation_extension = context.animation_extension
	self._inventory_slot_component = init_data.inventory_slot_component
	self._tweak_data = init_data.tweak_data
	self._player_unit = context.player_unit
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	self._warp_charge_component = context.warp_charge_component
	self._breed_tag_charges = self._tweak_data.breed_tag_charges or default_breed_tag_charges

	local unit_data_extension = ScriptUnit.extension(self._player_unit, "unit_data_system")

	self._inventory_component = unit_data_extension:read_component("inventory")
	self._default_num_charges_to_add = self._tweak_data.default_num_charges_to_add or default_num_charges_to_add
	self._last_hits = {}
end

WeaponSpecialKillCountCharges.on_wieldable_slot_equipped = function (self)
	if not self._initial_wield and self._tweak_data.initial_charges then
		self._inventory_slot_component.num_special_charges = self._tweak_data.initial_charges or 0
		self._initial_wield = true
	end
end

WeaponSpecialKillCountCharges.fixed_update = function (self, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local tweak_data = self._tweak_data
	local num_special_charges = inventory_slot_component.num_special_charges
	local special_charge_remove_at_t = inventory_slot_component.special_charge_remove_at_t

	if tweak_data.charge_remove_time and special_charge_remove_at_t <= t and num_special_charges > 0 then
		local num_charges_to_remove = tweak_data.num_charges_to_remove

		inventory_slot_component.num_special_charges = math.max(inventory_slot_component.num_special_charges - num_charges_to_remove, 0)
		inventory_slot_component.special_charge_remove_at_t = t + tweak_data.charge_remove_time
	end

	WeaponSpecial.update_active(t, self._tweak_data, inventory_slot_component, self._buff_extension, self._input_extension, self._weapon_extension)

	for key, value in pairs(self._last_hits) do
		if not key or not ALIVE[key] or value < t then
			self._last_hits[key] = nil
		elseif not HEALTH_ALIVE[key] then
			self:_add_charge(t, key)

			self._last_hits[key] = nil
		end
	end
end

WeaponSpecialKillCountCharges.on_special_activation = function (self, t)
	local charge_template = self._weapon_extension:charge_template()

	if charge_template then
		WarpCharge.increase_immediate(t, nil, self._warp_charge_component, charge_template, self._player_unit)
	end
end

WeaponSpecialKillCountCharges.on_special_deactivation = function (self, t)
	return
end

WeaponSpecialKillCountCharges.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialKillCountCharges.on_sweep_action_finish = function (self, t, num_hit_enemies)
	return
end

local EMPTY_TABLE = {}

WeaponSpecialKillCountCharges.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, damage, result, damage_efficiency, stagger_result, hit_position, attack_direction, abort_attack, optional_origin_slot)
	if target_is_alive then
		if result == "died" then
			self:_add_charge(t, target_unit)

			self._last_hits[target_unit] = nil
		else
			local killsteal_safety_time = 1

			self._last_hits[target_unit] = t + killsteal_safety_time
		end
	end
end

WeaponSpecialKillCountCharges.blocked_attack = function (self, attacking_unit, block_cost, block_broken, is_perfect_block)
	return
end

WeaponSpecialKillCountCharges._add_charge = function (self, t, target_unit)
	local wielded_slot = self._inventory_component.wielded_slot
	local is_wielded = wielded_slot == "slot_primary"

	if not is_wielded then
		return
	end

	local inventory_slot_component = self._inventory_slot_component
	local tweak_data = self._tweak_data
	local num_charges_to_add = 0
	local target_breed_or_nil = Breed.unit_breed_or_nil(target_unit)

	if target_breed_or_nil and Breed.is_character(target_breed_or_nil) then
		local breed_tags = target_breed_or_nil.tags or EMPTY_TABLE

		for tag, value in pairs(self._breed_tag_charges) do
			if breed_tags[tag] then
				num_charges_to_add = num_charges_to_add + value
			end
		end

		num_charges_to_add = math.max(self._default_num_charges_to_add, num_charges_to_add)
	end

	local new_charges = math.min(inventory_slot_component.num_special_charges + num_charges_to_add, tweak_data.max_charges)

	inventory_slot_component.num_special_charges = new_charges

	if tweak_data.charge_remove_time then
		inventory_slot_component.special_charge_remove_at_t = t + tweak_data.charge_remove_time
	end
end

WeaponSpecialKillCountCharges.on_exit_damage_window = function (self, t, num_hit_enemies, aborted)
	return
end

implements(WeaponSpecialKillCountCharges, WeaponSpecialInterface)

return WeaponSpecialKillCountCharges
