-- chunkname: @scripts/extension_systems/interaction/interactions/grenade_interaction.lua

require("scripts/extension_systems/interaction/interactions/pickup_interaction")

local Pickups = require("scripts/settings/pickup/pickups")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local GrenadeInteraction = class("GrenadeInteraction", "PickupInteraction")
local ABILITY_TYPE = "grenade_ability"
local special_rules = SpecialRulesSetting.special_rules
local _grenades_disabled

GrenadeInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server then
		local target_unit = unit_data_component.target_unit

		if result == "success" then
			local ability_extension = ScriptUnit.has_extension(interactor_unit, "ability_system")
			local pickup_name = Unit.get_data(target_unit, "pickup_type")
			local pickup_data = Pickups.by_name[pickup_name]
			local charges_restored = pickup_data.charges_restored

			ability_extension:restore_ability_charge(ABILITY_TYPE, charges_restored)
			self:_trigger_sound(interactor_unit, pickup_data)
			self:_use_charge(target_unit, interactor_unit)
		end
	end
end

GrenadeInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local ability_extension = ScriptUnit.has_extension(interactor_unit, "ability_system")

	if not ability_extension then
		return false
	end

	local ability_equipped = ability_extension:ability_is_equipped(ABILITY_TYPE)

	if not ability_equipped then
		return false
	end

	if _grenades_disabled(interactor_unit) then
		return false
	end

	local max_grenade_charges = ability_extension:max_ability_charges(ABILITY_TYPE)
	local remaining_grenade_charges = ability_extension:remaining_ability_charges(ABILITY_TYPE)
	local full_charges = max_grenade_charges <= remaining_grenade_charges

	return not full_charges and GrenadeInteraction.super.interactor_condition_func(self, interactor_unit, interactee_unit)
end

GrenadeInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, interactable_actor_node_index)
	local ability_extension = ScriptUnit.has_extension(interactor_unit, "ability_system")

	if not ability_extension then
		return "loc_action_interaction_inactive_no_grenades"
	end

	if _grenades_disabled(interactor_unit) then
		return "loc_action_interaction_inactive_no_grenades"
	end

	local ability_equipped = ability_extension:ability_is_equipped(ABILITY_TYPE)

	if not ability_equipped then
		return "loc_action_interaction_inactive_no_grenades"
	end

	local max_grenade_charges = ability_extension:max_ability_charges(ABILITY_TYPE)

	if max_grenade_charges <= 0 then
		return "loc_action_interaction_inactive_no_grenades"
	end

	local remaining_grenade_charges = ability_extension:remaining_ability_charges(ABILITY_TYPE)
	local full_charges = max_grenade_charges <= remaining_grenade_charges

	if full_charges then
		return "loc_action_interaction_inactive_grenades_full"
	end

	return GrenadeInteraction.super.hud_block_text(self, interactor_unit, interactee_unit, interactable_actor_node_index)
end

function _grenades_disabled(interactor_unit)
	local talent_extension = ScriptUnit.has_extension(interactor_unit, "talent_system")

	if talent_extension then
		return talent_extension:has_special_rule(special_rules.disable_grenade_pickups)
	end

	return false
end

return GrenadeInteraction
