-- chunkname: @scripts/extension_systems/interaction/interactions/ammunition_interaction.lua

require("scripts/extension_systems/interaction/interactions/pickup_interaction")

local Ammo = require("scripts/utilities/ammo")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local Pickups = require("scripts/settings/pickup/pickups")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Vo = require("scripts/utilities/vo")
local buff_proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSettings.special_rules
local AmmunitionInteraction = class("AmmunitionInteraction", "PickupInteraction")
local _can_interact, _can_refill_grenades, _can_refill_weapon_special_charges

AmmunitionInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server then
		local target_unit = unit_data_component.target_unit

		if result == "success" then
			local pickup_name = Unit.get_data(target_unit, "pickup_type")
			local pickup_data = Pickups.by_name[pickup_name]

			self:_add_ammo(interactor_unit, pickup_data)
			self:_trigger_sound(interactor_unit, pickup_data)
			self:_use_charge(target_unit, interactor_unit)
		end
	end
end

AmmunitionInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local can_interact = _can_interact(interactor_unit, interactee_unit)

	return can_interact and AmmunitionInteraction.super.interactor_condition_func(self, interactor_unit, interactee_unit)
end

AmmunitionInteraction.hud_block_text = function (self, interactor_unit, interactee_unit)
	local can_interact = _can_interact(interactor_unit, interactee_unit)

	if not can_interact then
		if Ammo.uses_ammo(interactor_unit) then
			return "loc_action_interaction_inactive_ammo_full"
		else
			return "loc_action_interaction_inactive_no_ammo"
		end
	end

	return AmmunitionInteraction.super.hud_block_text(self, interactor_unit, interactee_unit)
end

AmmunitionInteraction._add_ammo = function (self, interactor_unit, pickup_data)
	local unit_data_ext = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(interactor_unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
	local ammo_modifier = Managers.state.difficulty:get_ammo_modifier()

	pickup_data.modifier = ammo_modifier

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_ext:write_component(slot_name)

		if inventory_slot_component.max_ammunition_reserve > 0 then
			local ammo_reserve = inventory_slot_component.current_ammunition_reserve
			local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
			local ammo_clip = Ammo.current_ammo_in_clips(inventory_slot_component)
			local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)
			local pickup_amount = pickup_data.ammo_amount_func(max_ammo_reserve, max_ammo_clip, pickup_data)
			local missing_clip = max_ammo_clip - ammo_clip
			local new_ammo_amount = math.min(ammo_reserve + pickup_amount, max_ammo_reserve + missing_clip)

			inventory_slot_component.current_ammunition_reserve = new_ammo_amount

			local missing_player_ammo = max_ammo_reserve - ammo_reserve

			if missing_player_ammo < pickup_amount * DialogueSettings.ammo_hog_pickup_share and not pickup_data.ammo_crate then
				Vo.ammo_hog_event(interactor_unit, inventory_slot_component, pickup_data)
			end

			local buff_extension = ScriptUnit.has_extension(interactor_unit, "buff_system")

			if buff_extension then
				local param_table = buff_extension:request_proc_event_param_table()

				if param_table then
					param_table.pickup_amount = pickup_amount
					param_table.pickup_name = pickup_data.name
					param_table.new_ammo_amount = new_ammo_amount

					buff_extension:add_proc_event(buff_proc_events.on_ammo_pickup, param_table)
				end
			end
		end

		local can_refill_weapon_special_charges = _can_refill_weapon_special_charges(interactor_unit, slot_name)

		if can_refill_weapon_special_charges then
			inventory_slot_component.num_special_charges = inventory_slot_component.max_num_special_charges
		end
	end

	local can_refill_grenades, _ = _can_refill_grenades(interactor_unit, pickup_data)
	local ability_extension = ScriptUnit.has_extension(interactor_unit, "ability_system")

	if can_refill_grenades and ability_extension then
		local max_grenade_charges = ability_extension:max_ability_charges("grenade_ability")
		local num_charges = pickup_data.ammo_amount_func(max_grenade_charges, 0, pickup_data)

		num_charges = math.clamp(num_charges, 0, max_grenade_charges)

		ability_extension:restore_ability_charge("grenade_ability", num_charges)
	end
end

function _can_interact(interactor_unit, interactee_unit)
	local ammo_full = Ammo.ammo_is_full(interactor_unit)

	if ammo_full then
		local pickup_name = Unit.get_data(interactee_unit, "pickup_type")
		local pickup_data = Pickups.by_name[pickup_name]
		local can_refill, missing_grenades = _can_refill_grenades(interactor_unit, pickup_data)

		if can_refill and missing_grenades then
			ammo_full = false
		end
	end

	return not ammo_full
end

function _can_refill_grenades(interactor_unit, pickup_data)
	local ability_extension = ScriptUnit.has_extension(interactor_unit, "ability_system")
	local talent_extension = ScriptUnit.has_extension(interactor_unit, "talent_system")
	local has_grenades = ability_extension and ability_extension:ability_is_equipped("grenade_ability")

	if not has_grenades then
		return false, false
	end

	local max_grenade_charges = ability_extension:max_ability_charges("grenade_ability")
	local remaining_grenade_charges = ability_extension:remaining_ability_charges("grenade_ability")
	local has_missing_charges = remaining_grenade_charges < max_grenade_charges
	local disable_grenade_pickups = talent_extension and talent_extension:has_special_rule(special_rules.disable_grenade_pickups)
	local ammo_pickups_refills_grenades = talent_extension and talent_extension:has_special_rule(special_rules.ammo_pickups_refills_grenades)

	if disable_grenade_pickups and ammo_pickups_refills_grenades then
		return true, has_missing_charges
	elseif disable_grenade_pickups then
		return false, false
	end

	if pickup_data and pickup_data.ammo_crate then
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[interactor_unit]
		local player_units = side.player_units
		local buff_keywords = BuffSettings.keywords

		for _, player_unit in pairs(player_units) do
			local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

			if buff_extension then
				local improved_keyword = buff_extension:has_keyword(buff_keywords.improved_ammo_pickups)

				if improved_keyword then
					return true, has_missing_charges
				end
			end
		end
	end

	return false, false
end

function _can_refill_weapon_special_charges(interactor_unit, slot_name)
	local weapon_extension = ScriptUnit.has_extension(interactor_unit, "weapon_system")
	local ammo_replenishes_num_special_charges = weapon_extension and weapon_extension:has_special_rule(slot_name, special_rules.ammo_pickups_replenishes_num_special_charges)

	return ammo_replenishes_num_special_charges
end

return AmmunitionInteraction
