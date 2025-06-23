-- chunkname: @scripts/extension_systems/weapon/special_classes/weapon_special_block_charges.lua

local Breed = require("scripts/utilities/breed")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecialBlockCharges = class("WeaponSpecialBlockCharges")

WeaponSpecialBlockCharges.UPDATE_WHEN_UNWIELDED = true

WeaponSpecialBlockCharges.init = function (self, context, init_data)
	self._input_extension = context.input_extension
	self._weapon_extension = context.weapon_extension
	self._animation_extension = context.animation_extension
	self._inventory_slot_component = init_data.inventory_slot_component
	self._tweak_data = init_data.tweak_data
	self._player_unit = context.player_unit
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")

	local unit_data_extension = ScriptUnit.extension(self._player_unit, "unit_data_system")

	self._inventory_component = unit_data_extension:read_component("inventory")
end

WeaponSpecialBlockCharges.on_wieldable_slot_equipped = function (self)
	return
end

WeaponSpecialBlockCharges.fixed_update = function (self, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local special_charge_remove_at_t = inventory_slot_component.special_charge_remove_at_t
	local num_special_charges = inventory_slot_component.num_special_charges
	local tweak_data = self._tweak_data
	local max_charges = tweak_data.max_charges

	if special_charge_remove_at_t <= t and num_special_charges < max_charges then
		local passive_num_charges_to_add = tweak_data.passive_num_charges_to_add
		local passive_charge_add_interval = tweak_data.passive_charge_add_interval

		inventory_slot_component.num_special_charges = math.min(inventory_slot_component.num_special_charges + passive_num_charges_to_add, max_charges)
		inventory_slot_component.special_charge_remove_at_t = t + passive_charge_add_interval
	end

	WeaponSpecial.update_active(t, self._tweak_data, inventory_slot_component, self._buff_extension, self._input_extension, self._weapon_extension)
end

WeaponSpecialBlockCharges.on_special_activation = function (self, t)
	return
end

WeaponSpecialBlockCharges.on_special_deactivation = function (self, t)
	return
end

WeaponSpecialBlockCharges.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialBlockCharges.on_sweep_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialBlockCharges.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, damage, result, damage_efficiency, stagger_result, hit_position, attack_direction, abort_attack, optional_origin_slot)
	return
end

WeaponSpecialBlockCharges.blocked_attack = function (self, attacking_unit, block_cost, block_broken, is_perfect_block)
	local wielded_slot = self._inventory_component.wielded_slot
	local is_wielded = wielded_slot == "slot_primary"

	if not is_wielded then
		return
	end

	local tweak_data = self._tweak_data
	local inventory_slot_component = self._inventory_slot_component
	local attacking_breed_or_nil = Breed.unit_breed_or_nil(attacking_unit)
	local max_charges = tweak_data.max_charges
	local num_charges_to_add_per_breed = tweak_data.num_charges_to_add_per_breed
	local default_num_charges_to_add = tweak_data.default_num_charges_to_add
	local num_charges_to_add = attacking_breed_or_nil and num_charges_to_add_per_breed[attacking_breed_or_nil.name] or default_num_charges_to_add
	local new_charges = math.min(inventory_slot_component.num_special_charges + num_charges_to_add, max_charges)

	inventory_slot_component.num_special_charges = new_charges
end

WeaponSpecialBlockCharges.on_exit_damage_window = function (self, t, num_hit_enemies, aborted)
	return
end

implements(WeaponSpecialBlockCharges, WeaponSpecialInterface)

return WeaponSpecialBlockCharges
