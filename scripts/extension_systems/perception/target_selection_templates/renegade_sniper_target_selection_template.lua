local MinionMovement = require("scripts/utilities/minion_movement")
local MinionTargetSelection = require("scripts/utilities/minion_target_selection")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local aggro_states = PerceptionSettings.aggro_states

local function _calculate_score(breed, unit, target_unit, distance_sq, is_new_target, line_of_sight_lookup, debug_target_weighting_or_nil)
	local target_selection_weights = breed.target_selection_weights
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data_extension:breed()
	local score = 0
	local use_quadratic_falloff = true
	local distance_weight, inverse_radius = MinionTargetSelection.distance_weight(target_selection_weights, distance_sq, breed, use_quadratic_falloff)
	score = score + distance_weight
	local occupied_slots_weight = MinionTargetSelection.occupied_slots_weight(target_selection_weights, target_unit, target_breed, is_new_target, inverse_radius)
	score = score + occupied_slots_weight
	local disabled_weight = MinionTargetSelection.disabled_weight(target_selection_weights, target_unit, target_breed)
	score = score + disabled_weight
	local targeted_by_monster_weight = MinionTargetSelection.targeted_by_monster_weight(target_selection_weights, target_unit, unit)
	score = score + targeted_by_monster_weight
	local attack_type = "ranged"
	local attack_not_allowed_weight = MinionTargetSelection.attack_not_allowed_weight(target_selection_weights, target_unit, target_breed, attack_type)
	score = score + attack_not_allowed_weight
	local line_of_sight_weight = MinionTargetSelection.line_of_sight_weight(target_selection_weights, target_unit, line_of_sight_lookup)
	score = score + line_of_sight_weight
	local combat_vector_main_aggro_weight = MinionTargetSelection.combat_vector_main_aggro_weight(target_selection_weights, target_unit)
	score = score + combat_vector_main_aggro_weight
	local knocked_down_weight = MinionTargetSelection.knocked_down_weight(target_selection_weights, target_unit_data_extension, target_breed)
	score = score + knocked_down_weight
	local weight_multiplier = MinionTargetSelection.weight_multiplier(target_unit)
	score = score * weight_multiplier

	return math.max(score, 0)
end

local DEFAULT_STICKINESS_DISTANCE = 1
local target_selection_template = {
	sniper = function (unit, side, perception_component, breed, target_units, line_of_sight_lookup, t, threat_units, force_new_target_attempt, force_new_target_attempt_config_or_nil, debug_target_weighting_or_nil, last_los_positions)
		local current_target_unit = perception_component.target_unit
		local position = POSITION_LOOKUP[unit]
		local best_score, best_target_unit, closest_distance_sq, closest_z_distance = nil
		local detection_radius = MinionTargetSelection.detection_radius(breed)
		local detection_radius_sq = detection_radius^2
		local vector3_distance_squared = Vector3.distance_squared

		if target_units[current_target_unit] then
			local stickiness = breed.target_stickiness_distance or DEFAULT_STICKINESS_DISTANCE
			local target_position = POSITION_LOOKUP[current_target_unit]
			local distance_sq = vector3_distance_squared(position, target_position)
			local z_distance = math.abs(position.z - target_position.z)
			closest_z_distance = z_distance
			closest_distance_sq = distance_sq
			best_target_unit = current_target_unit

			if force_new_target_attempt then
				best_score = -math.huge
			else
				best_score = _calculate_score(breed, unit, current_target_unit, distance_sq - stickiness, false, line_of_sight_lookup, debug_target_weighting_or_nil)
			end
		else
			closest_z_distance = math.huge
			closest_distance_sq = math.huge
			best_target_unit = nil
			best_score = -math.huge
		end

		local lock_target = perception_component.lock_target

		if not lock_target then
			local aggro_state = perception_component.aggro_state

			for i = 1, #target_units do
				local target_unit = target_units[i]

				if target_unit ~= current_target_unit then
					local target_position = POSITION_LOOKUP[target_unit]
					local distance_sq = vector3_distance_squared(position, target_position)

					if aggro_state == aggro_states.aggroed or distance_sq < detection_radius_sq then
						local score = _calculate_score(breed, unit, target_unit, distance_sq, true, line_of_sight_lookup, debug_target_weighting_or_nil)

						if best_score < score then
							local has_line_of_sight = line_of_sight_lookup[target_unit]

							if not current_target_unit and aggro_state == aggro_states.aggroed or has_line_of_sight then
								local z_distance = math.abs(position.z - target_position.z)
								closest_z_distance = z_distance
								closest_distance_sq = distance_sq
								best_target_unit = target_unit
								best_score = score
							end
						end
					end
				end
			end
		end

		if best_target_unit then
			local has_line_of_sight = line_of_sight_lookup[best_target_unit]
			perception_component.has_line_of_sight = has_line_of_sight
			local last_los_position = last_los_positions[best_target_unit]
			local target_position = POSITION_LOOKUP[best_target_unit]

			if last_los_position then
				local last_los_distance = Vector3.distance(last_los_position:unbox(), target_position)
				perception_component.has_good_last_los_position = last_los_distance <= breed.good_last_los_distance
			else
				perception_component.has_good_last_los_position = false
			end

			perception_component.target_distance = math.sqrt(closest_distance_sq)
			perception_component.target_distance_z = closest_z_distance
			perception_component.target_speed_away = MinionMovement.target_speed_away(unit, best_target_unit)
		end

		return best_target_unit
	end
}

return target_selection_template
