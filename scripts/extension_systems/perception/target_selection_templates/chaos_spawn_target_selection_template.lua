﻿-- chunkname: @scripts/extension_systems/perception/target_selection_templates/chaos_spawn_target_selection_template.lua

local Breed = require("scripts/utilities/breed")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionTargetSelection = require("scripts/utilities/minion_target_selection")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local aggro_states = PerceptionSettings.aggro_states

local function _calculate_score(breed, unit, target_unit, distance_sq, is_new_target, taunter_unit_or_nil, threat_units, t, perception_component, debug_target_weighting_or_nil)
	local target_selection_weights = breed.target_selection_weights
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data_extension:breed()
	local score = 0
	local use_quadratic_falloff = true
	local distance_weight, inverse_radius = MinionTargetSelection.distance_weight(target_selection_weights, distance_sq, breed, use_quadratic_falloff)

	score = score + distance_weight

	local occupied_slots_weight = MinionTargetSelection.occupied_slots_weight(target_selection_weights, target_unit, target_breed, is_new_target, inverse_radius)

	score = score + occupied_slots_weight

	local threat_weight = MinionTargetSelection.threat_weight(target_selection_weights, target_unit, threat_units)

	score = score + threat_weight

	local stickiness_weight = MinionTargetSelection.stickiness_weight(target_selection_weights, is_new_target, perception_component, t)

	score = score + stickiness_weight

	local targeted_by_monster_weight = MinionTargetSelection.targeted_by_monster_weight(target_selection_weights, target_unit, unit)

	score = score + targeted_by_monster_weight

	local disabled_weight = MinionTargetSelection.disabled_weight(target_selection_weights, target_unit, target_breed)

	score = score + disabled_weight

	local ledge_hanging_weight = MinionTargetSelection.ledge_hanging_weight(target_selection_weights, target_unit_data_extension, target_breed)

	score = score + ledge_hanging_weight

	local weight_multiplier = MinionTargetSelection.weight_multiplier(target_unit)

	score = score * weight_multiplier

	local taunt_weight_multiplier = MinionTargetSelection.taunt_weight_multiplier(target_selection_weights, target_unit, taunter_unit_or_nil)

	score = score * taunt_weight_multiplier

	return math.max(score, 0)
end

local target_selection_template = {}
local EXTRA_SHOOT_DISTANCE_SQ = 625

target_selection_template.chaos_spawn = function (unit, side, perception_component, buff_extension, breed, target_units, line_of_sight_lookup, t, threat_units, force_new_target_attempt, force_new_target_attempt_config_or_nil, debug_target_weighting_or_nil)
	local current_target_unit = perception_component.target_unit
	local position = POSITION_LOOKUP[unit]
	local taunter_unit = buff_extension:owner_of_buff_with_id("taunted")
	local best_score, best_target_unit, closest_distance_sq, closest_z_distance
	local vector3_distance_squared = Vector3.distance_squared
	local detection_radius = MinionTargetSelection.detection_radius(breed)
	local detection_radius_sq = detection_radius^2

	if target_units[current_target_unit] then
		local target_position = POSITION_LOOKUP[current_target_unit]
		local distance_sq = vector3_distance_squared(position, target_position)
		local z_distance = math.abs(position.z - target_position.z)

		best_target_unit, closest_distance_sq, closest_z_distance = current_target_unit, distance_sq, z_distance

		if force_new_target_attempt then
			best_score = -math.huge
		else
			local is_new_target = false

			best_score = _calculate_score(breed, unit, current_target_unit, distance_sq, is_new_target, taunter_unit, threat_units, t, perception_component, debug_target_weighting_or_nil)
		end
	else
		best_target_unit, closest_distance_sq, closest_z_distance = nil, math.huge, math.huge
		best_score = -math.huge
	end

	local lock_target = perception_component.lock_target

	if not lock_target then
		local aggro_state = perception_component.aggro_state

		for i = 1, #target_units do
			local target_unit = target_units[i]

			if target_unit ~= current_target_unit then
				local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
				local target_breed = unit_data_extension:breed()
				local is_shooting = false

				if Breed.is_player(target_breed) then
					local shooting_status = unit_data_extension:read_component("shooting_status")

					is_shooting = shooting_status.shooting or not shooting_status.shooting and t <= shooting_status.shooting_end_time + 1
				end

				local can_be_disabled = AttackIntensity.player_can_be_attacked(target_unit, "disabling")
				local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
				local character_state_component = target_unit_data_extension:read_component("character_state")
				local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

				if can_be_disabled and not is_disabled then
					local target_position = POSITION_LOOKUP[target_unit]
					local distance_to_target_sq = vector3_distance_squared(position, target_position)
					local check_distance_sq = is_shooting and distance_to_target_sq - EXTRA_SHOOT_DISTANCE_SQ or distance_to_target_sq

					if aggro_state == aggro_states.aggroed or check_distance_sq < detection_radius_sq then
						local is_new_target = true
						local score = _calculate_score(breed, unit, target_unit, distance_to_target_sq, is_new_target, taunter_unit, threat_units, t, perception_component, debug_target_weighting_or_nil)

						if best_score < score then
							local has_line_of_sight = line_of_sight_lookup[target_unit]

							if aggro_state == aggro_states.aggroed or has_line_of_sight then
								local z_distance = math.abs(position.z - target_position.z)

								best_target_unit, closest_distance_sq, closest_z_distance = target_unit, distance_to_target_sq, z_distance
								best_score = score
							end
						end
					end
				end
			end
		end
	end

	if best_target_unit then
		local has_line_of_sight = line_of_sight_lookup[best_target_unit]

		perception_component.has_line_of_sight = has_line_of_sight
		perception_component.target_distance = math.sqrt(closest_distance_sq)
		perception_component.target_distance_z = closest_z_distance
		perception_component.target_speed_away = MinionMovement.target_speed_away(unit, best_target_unit)
	end

	return best_target_unit
end

return target_selection_template
