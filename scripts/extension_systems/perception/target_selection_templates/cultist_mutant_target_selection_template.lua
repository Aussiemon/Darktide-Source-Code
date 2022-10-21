local AttackIntensity = require("scripts/utilities/attack_intensity")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionTargetSelection = require("scripts/utilities/minion_target_selection")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")

local function _calculate_score(breed, unit, target_unit, distance_sq, is_new_target, threat_units, debug_target_weighting_or_nil, line_of_sight_lookup)
	local target_selection_weights = breed.target_selection_weights
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data_extension:breed()
	local score = 0
	local distance_weight, inverse_radius = MinionTargetSelection.distance_weight(target_selection_weights, distance_sq, breed)
	score = score + distance_weight
	local occupied_slots_weight = MinionTargetSelection.occupied_slots_weight(target_selection_weights, target_unit, target_breed, is_new_target, inverse_radius)
	score = score + occupied_slots_weight
	local threat_weight = MinionTargetSelection.threat_weight(target_selection_weights, target_unit, threat_units)
	score = score + threat_weight
	local targeted_by_monster_weight = MinionTargetSelection.targeted_by_monster_weight(target_selection_weights, target_unit, unit)
	score = score + targeted_by_monster_weight
	local disabled_weight = MinionTargetSelection.disabled_weight(target_selection_weights, target_unit, target_breed)
	score = score + disabled_weight
	local line_of_sight_weight = MinionTargetSelection.line_of_sight_weight(target_selection_weights, target_unit, line_of_sight_lookup)
	score = score + line_of_sight_weight
	local weight_multiplier = MinionTargetSelection.weight_multiplier(target_unit)
	score = score * weight_multiplier

	return math.max(score, 0)
end

local DEFAULT_STICKINESS_DISTANCE = 0.5
local target_selection_template = {
	cultist_mutant = function (unit, side, perception_component, breed, target_units, line_of_sight_lookup, t, threat_units, force_new_target_attempt, force_new_target_attempt_config_or_nil, debug_target_weighting_or_nil)
		local current_target_unit = perception_component.target_unit
		local position = POSITION_LOOKUP[unit]
		local best_score, best_target_unit, closest_distance_sq, closest_z_distance = nil
		local Vector3_distance_squared = Vector3.distance_squared

		if target_units[current_target_unit] then
			local target_unit_data_extension = ScriptUnit.extension(current_target_unit, "unit_data_system")
			local character_state_component = target_unit_data_extension:read_component("character_state")
			local disabled_character_state_component = target_unit_data_extension:read_component("disabled_character_state")
			local _, mutant_charging_unit = PlayerUnitStatus.is_mutant_charged(disabled_character_state_component)
			local is_catapulted = PlayerUnitStatus.is_catapulted(character_state_component)
			local is_disabled = not is_catapulted and PlayerUnitStatus.is_disabled(character_state_component)
			local _ = nil

			if not is_disabled or mutant_charging_unit == unit then
				local stickiness = breed.target_stickiness_distance or DEFAULT_STICKINESS_DISTANCE
				local target_position = POSITION_LOOKUP[current_target_unit]
				local distance_sq = Vector3_distance_squared(position, target_position)
				local z_distance = math.abs(position.z - target_position.z)
				closest_z_distance = z_distance
				closest_distance_sq = distance_sq
				best_target_unit = current_target_unit

				if force_new_target_attempt then
					best_score = -math.huge
				else
					local is_new_target = false
					best_score = _calculate_score(breed, unit, current_target_unit, distance_sq - stickiness, is_new_target, threat_units, debug_target_weighting_or_nil, line_of_sight_lookup)
				end
			else
				closest_z_distance = math.huge
				closest_distance_sq = math.huge
				best_target_unit = nil
				best_score = -math.huge
			end
		else
			closest_z_distance = math.huge
			closest_distance_sq = math.huge
			best_target_unit = nil
			best_score = -math.huge
		end

		local lock_target = perception_component.lock_target

		if not lock_target then
			local num_target_units = #target_units

			for i = 1, num_target_units do
				local target_unit = target_units[i]

				if target_unit ~= current_target_unit then
					local can_be_disabled = AttackIntensity.player_can_be_attacked(target_unit, "disabling")
					local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
					local character_state_component = target_unit_data_extension:read_component("character_state")
					local is_disabled, _ = PlayerUnitStatus.is_disabled(character_state_component)

					if can_be_disabled and not is_disabled then
						local target_position = POSITION_LOOKUP[target_unit]
						local distance_sq = Vector3_distance_squared(position, target_position)
						local is_new_target = true
						local score = _calculate_score(breed, unit, target_unit, distance_sq, is_new_target, threat_units, debug_target_weighting_or_nil, line_of_sight_lookup)

						if best_score < score then
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

		if best_target_unit then
			local has_line_of_sight = line_of_sight_lookup[best_target_unit]
			perception_component.has_line_of_sight = has_line_of_sight
			perception_component.target_distance = math.sqrt(closest_distance_sq)
			perception_component.target_distance_z = closest_z_distance
			perception_component.target_speed_away = MinionMovement.target_speed_away(unit, best_target_unit)
		end

		return best_target_unit
	end
}

return target_selection_template
