require("scripts/extension_systems/interaction/interactions/base_interaction")

local DamageSettings = require("scripts/settings/damage/damage_settings")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local Health = require("scripts/utilities/health")
local Vo = require("scripts/utilities/vo")
local HealthStationInteraction = class("HealthStationInteraction", "BaseInteraction")

HealthStationInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local health_extension = ScriptUnit.extension(interactor_unit, "health_system")
	local total_damage_taken = health_extension:damage_taken()
	local health_station_extension = ScriptUnit.has_extension(interactee_unit, "health_station_system")
	local charge_amount = health_station_extension:charge_amount()
	local has_charges = charge_amount > 0
	local is_damaged = total_damage_taken > 0

	return has_charges and is_damaged and not self:_interactor_disabled(interactor_unit)
end

HealthStationInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, interactable_actor_node_index)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local block_text = interactee_extension:block_text()

	if block_text then
		return block_text
	end

	local health_extension = ScriptUnit.extension(interactor_unit, "health_system")
	local total_damage_taken = health_extension:damage_taken()

	if total_damage_taken <= 0 then
		return "loc_health_station_full_health"
	end

	return nil
end

HealthStationInteraction.start = function (self, world, interactor_unit, unit_data_component, t, is_server)
	if is_server then
		local target_unit = unit_data_component.target_unit
		local health_station_extension = ScriptUnit.extension(target_unit, "health_station_system")

		health_station_extension:start_healing()
	end
end

HealthStationInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	local success = result == "success"
	local health_extension = ScriptUnit.extension(interactor_unit, "health_system")
	local current_health_percent = health_extension:current_health_percent()

	if interactor_is_server then
		local target_unit = unit_data_component.target_unit
		local health_station_extension = ScriptUnit.extension(target_unit, "health_station_system")

		if success then
			local permanent_health_to_recover = health_station_extension:health_per_charge()
			local health_to_recover = health_station_extension:health_per_charge()

			if permanent_health_to_recover == 0 then
				permanent_health_to_recover = health_extension:permanent_damage_taken()
			end

			local permanent_heal_type = DamageSettings.heal_types.blessing_health_station

			Health.add(interactor_unit, permanent_health_to_recover, permanent_heal_type)

			if health_to_recover == 0 then
				health_to_recover = health_extension:damage_taken()
			end

			local heal_type = DamageSettings.heal_types.healing_station
			local health_added = Health.add(interactor_unit, health_to_recover, heal_type)

			if health_added > 0 then
				Health.play_fx(interactor_unit)
			end
		end

		health_station_extension:stop_healing(success)
	end

	if success then
		local target_unit = unit_data_component.target_unit
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(interactor_unit)

		if DialogueSettings.health_hog_health_before_healing < current_health_percent then
			Vo.health_hog_event(interactor_unit)
		end

		if not player.remote then
			Unit.flow_event(target_unit, "lua_heal_success_local")
		end
	end
end

HealthStationInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	local health_station_extension = ScriptUnit.has_extension(interactee_unit, "health_station_system")
	local charge_amount = health_station_extension:charge_amount()

	if charge_amount == 0 and health_station_extension:battery_in_slot() then
		return false
	end

	return not self:_interactor_disabled(interactor_unit)
end

return HealthStationInteraction
