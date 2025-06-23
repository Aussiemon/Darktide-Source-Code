-- chunkname: @scripts/extension_systems/interaction/interactions/health_station_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local DamageSettings = require("scripts/settings/damage/damage_settings")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local Health = require("scripts/utilities/health")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
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

HealthStationInteraction.hud_block_text = function (self, interactor_unit, interactee_unit)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local block_text = interactee_extension:block_text(interactor_unit)

	if block_text then
		return block_text
	end

	local health_extension = ScriptUnit.extension(interactor_unit, "health_system")
	local total_damage_taken = health_extension:damage_taken()

	if total_damage_taken <= 0 then
		return "loc_health_station_full_health"
	end

	return HealthStationInteraction.super.hud_block_text(self, interactor_unit, interactee_unit)
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
	local current_health = health_extension:current_health()
	local corruption_damage = health_extension:permanent_damage_taken()

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
			else
				success = false
			end
		end

		health_station_extension:stop_healing(success)
	end

	if success then
		if current_health_percent > DialogueSettings.health_hog_health_before_healing then
			Vo.health_hog_event(interactor_unit)
		end

		local fx_extension = ScriptUnit.extension(interactor_unit, "fx_system")

		fx_extension:trigger_exclusive_wwise_event("wwise/events/ui/play_hud_health_station_2d", nil, true)

		if interactor_is_server then
			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local player = player_unit_spawn_manager:owner(interactor_unit)

			if player then
				local station_unit = unit_data_component.target_unit
				local unit_id = Managers.state.unit_spawner:level_index(station_unit)
				local furthest_travel_percentage = Managers.state.main_path:furthest_travel_percentage(1)
				local max_health = health_extension:max_health()
				local healed_amount = max_health - current_health
				local players = Managers.player:players()
				local num_grims = 0

				for _, check_player in pairs(players) do
					local player_unit = check_player.player_unit

					if ALIVE[player_unit] then
						local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
						local has_grim = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(visual_loadout_extension, "slot_pocketable", "grimoire")

						if has_grim then
							num_grims = num_grims + 1
						end
					end
				end

				local data = {
					health_before_healing = current_health,
					max_health = max_health,
					healed = healed_amount,
					corruption_damage = corruption_damage,
					num_grims = num_grims,
					total_main_path_percent = furthest_travel_percentage,
					id = unit_id
				}

				Managers.telemetry_events:player_used_health_station(player, data)
			end
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
