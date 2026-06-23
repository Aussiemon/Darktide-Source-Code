-- chunkname: @scripts/extension_systems/weapon/special_classes/weapon_special_hit_charges.lua

local WeaponSpecial = require("scripts/utilities/weapon_special")
local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local WeaponSpecialHitCharges = class("WeaponSpecialHitCharges")

WeaponSpecialHitCharges.UPDATE_WHEN_UNWIELDED = true

WeaponSpecialHitCharges.init = function (self, context, init_data)
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

WeaponSpecialHitCharges.on_wieldable_slot_equipped = function (self)
	return
end

WeaponSpecialHitCharges.fixed_update = function (self, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local special_charge_remove_at_t = inventory_slot_component.special_charge_remove_at_t
	local num_special_charges = inventory_slot_component.num_special_charges
	local tweak_data = self._tweak_data
	local max_charges = tweak_data.max_charges

	if special_charge_remove_at_t <= t and num_special_charges < max_charges and not inventory_slot_component.special_active then
		local passive_num_charges_to_add = tweak_data.passive_num_charges_to_add
		local passive_charge_add_interval = tweak_data.passive_charge_add_interval

		inventory_slot_component.num_special_charges = math.min(inventory_slot_component.num_special_charges + passive_num_charges_to_add, max_charges)
		inventory_slot_component.special_charge_remove_at_t = t + passive_charge_add_interval
	end

	WeaponSpecial.update_active(t, self._tweak_data, inventory_slot_component, self._buff_extension, self._input_extension, self._weapon_extension)
end

WeaponSpecialHitCharges.on_special_activation = function (self, t)
	return
end

WeaponSpecialHitCharges.on_special_deactivation = function (self, t)
	return
end

WeaponSpecialHitCharges.on_sweep_action_start = function (self, t)
	return
end

WeaponSpecialHitCharges.on_sweep_action_finish = function (self, t, aborted)
	local inventory_slot_component = self._inventory_slot_component
	local tweak_data = self._tweak_data
	local num_special_charges = inventory_slot_component.num_special_charges
	local num_charges_to_consume_on_sweep = tweak_data.num_charges_to_consume_on_sweep

	if inventory_slot_component.special_active and num_special_charges < num_charges_to_consume_on_sweep then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "not_enough_charges")

		local delay = tweak_data.deactivation_animation_delay or 0
		local deactivation_animation_on_abort = tweak_data.deactivation_animation_on_abort

		self._time_to_play_deactivation_animation = (not aborted or deactivation_animation_on_abort) and delay or nil
	end
end

WeaponSpecialHitCharges.on_weapon_shout_action_finish = function (self, t, aborted)
	local inventory_slot_component = self._inventory_slot_component
	local tweak_data = self._tweak_data
	local num_charges_to_consume_on_sweep = tweak_data.num_charges_to_consume_on_sweep

	if inventory_slot_component.special_active and num_charges_to_consume_on_sweep > inventory_slot_component.num_special_charges then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "not_enough_charges")
	end
end

WeaponSpecialHitCharges.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, damage, result, damage_efficiency, stagger_result, hit_position, attack_direction, abort_attack, optional_origin_slot)
	local wielded_slot = self._inventory_component.wielded_slot
	local is_wielded = wielded_slot == "slot_primary"

	if not is_wielded then
		return
	end

	local tweak_data = self._tweak_data
	local inventory_slot_component = self._inventory_slot_component
	local max_charges = tweak_data.max_charges
	local hit_num_charges_to_add = tweak_data.hit_num_charges_to_add
	local num_charges_to_add = hit_num_charges_to_add
	local is_weapon_special_active = inventory_slot_component.special_active

	if not is_weapon_special_active and target_is_alive then
		local new_charges = math.min(inventory_slot_component.num_special_charges + num_charges_to_add, max_charges)

		inventory_slot_component.num_special_charges = new_charges
	end
end

WeaponSpecialHitCharges.blocked_attack = function (self, attacking_unit, block_cost, block_broken, is_perfect_block)
	return
end

WeaponSpecialHitCharges.on_exit_damage_window = function (self, t, num_hit_enemies, aborted)
	local tweak_data = self._tweak_data
	local num_charges_to_consume_on_sweep = tweak_data and tweak_data.num_charges_to_consume_on_sweep or 0
	local inventory_slot_component = self._inventory_slot_component
	local is_weapon_special_active = inventory_slot_component.special_active

	if num_charges_to_consume_on_sweep > 0 and is_weapon_special_active and num_hit_enemies > 0 then
		local num_special_charges = inventory_slot_component.num_special_charges

		inventory_slot_component.num_special_charges = math.max(num_special_charges - num_charges_to_consume_on_sweep, 0)
	end
end

implements(WeaponSpecialHitCharges, WeaponSpecialInterface)

return WeaponSpecialHitCharges
