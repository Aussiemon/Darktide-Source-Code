-- chunkname: @scripts/extension_systems/interaction/interactions/health_interaction.lua

require("scripts/extension_systems/interaction/interactions/pickup_interaction")

local DamageSettings = require("scripts/settings/damage/damage_settings")
local Health = require("scripts/utilities/health")
local Pickups = require("scripts/settings/pickup/pickups")
local HealthInteraction = class("HealthInteraction", "PickupInteraction")

HealthInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server then
		local target_unit = unit_data_component.target_unit

		if result == "success" then
			self:_heal(interactor_unit, target_unit)
			self:_use_charge(target_unit, interactor_unit)
		end
	end
end

HealthInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local health_extension = ScriptUnit.extension(interactor_unit, "health_system")
	local damage_taken = health_extension:damage_taken()
	local is_damaged = damage_taken > 0

	return is_damaged and HealthInteraction.super.interactor_condition_func(self, interactor_unit, interactee_unit)
end

HealthInteraction._heal = function (self, interactor_unit, target_unit)
	local health_extension = ScriptUnit.extension(interactor_unit, "health_system")
	local pickup_name = Unit.get_data(target_unit, "pickup_type")
	local pickup_data = Pickups.by_name[pickup_name]
	local max_health = health_extension:max_health()
	local damage_taken = health_extension:damage_taken()
	local pickup_health_amount = pickup_data.health_amount_func(max_health, pickup_data)
	local new_health = math.min(pickup_health_amount, damage_taken)
	local heal_type = DamageSettings.heal_types.medkit
	local health_added = Health.add(interactor_unit, new_health, heal_type)

	if health_added > 0 then
		Health.play_fx(interactor_unit)
	end
end

return HealthInteraction
