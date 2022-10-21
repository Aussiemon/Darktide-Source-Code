local Breed = require("scripts/utilities/breed")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionTargetSelection = require("scripts/utilities/minion_target_selection")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local _is_valid_target = nil

local function _calculate_score(breed, unit, target_unit, distance_sq, is_new_target, threat_units, t, perception_component, debug_target_weighting_or_nil)
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
	local weight_multiplier = MinionTargetSelection.weight_multiplier(target_unit)
	score = score * weight_multiplier

	return math.max(score, 0)
end

local target_selection_template = {
	renegade_captain = function (unit, side, perception_component, breed, target_units, line_of_sight_lookup, t, threat_units, force_new_target_attempt, force_new_target_attempt_config_or_nil, debug_target_weighting_or_nil)
		local current_target_unit = perception_component.target_unit
		local position = POSITION_LOOKUP[unit]
		local best_score, best_target_unit, closest_distance_sq, closest_z_distance = nil
		local vector3_distance_squared = Vector3.distance_squared
		local blackboard = BLACKBOARDS[unit]
		local behavior_component = blackboard.behavior
		local valid_enemy_player_units = side.valid_enemy_player_units

		if target_units[current_target_unit] and valid_enemy_player_units[current_target_unit] then
			local is_valid_target = _is_valid_target(unit, current_target_unit, behavior_component, nil, nil, nil)

			if is_valid_target then
				local target_position = POSITION_LOOKUP[current_target_unit]
				local distance_sq = vector3_distance_squared(position, target_position)
				local z_distance = math.abs(position.z - target_position.z)
				closest_z_distance = z_distance
				closest_distance_sq = distance_sq
				best_target_unit = current_target_unit

				if force_new_target_attempt then
					best_score = -math.huge
				else
					local is_new_target = false
					best_score = _calculate_score(breed, unit, current_target_unit, distance_sq, is_new_target, threat_units, t, perception_component, debug_target_weighting_or_nil)
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
			local rotation = Unit.world_rotation(unit, 1)
			local forward_direction = Quaternion.forward(rotation)
			local vector3_normalize = Vector3.normalize
			local vector3_angle = Vector3.angle

			for i = 1, #target_units do
				local target_unit = target_units[i]

				if target_unit ~= current_target_unit then
					local target_position = POSITION_LOOKUP[target_unit]
					local distance_sq = vector3_distance_squared(position, target_position)
					local target_direction = vector3_normalize(target_position - position)
					local angle = distance_sq > 0 and vector3_angle(target_direction, forward_direction) or math.huge
					local is_valid_target = _is_valid_target(unit, target_unit, behavior_component, distance_sq, angle, force_new_target_attempt_config_or_nil)

					if is_valid_target then
						local is_new_target = true
						local score = _calculate_score(breed, unit, target_unit, distance_sq, is_new_target, threat_units, t, perception_component, debug_target_weighting_or_nil)

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

function _is_valid_target(attacking_unit, target_unit, attacking_unit_behavior_component, target_distance_sq, angle_to_target, force_new_target_attempt_config_or_nil)
	if force_new_target_attempt_config_or_nil then
		local max_distance_sq = force_new_target_attempt_config_or_nil.max_distance^2

		if target_distance_sq > max_distance_sq then
			return false
		end

		local max_angel = force_new_target_attempt_config_or_nil.max_angle

		if max_angel < angle_to_target then
			return false
		end
	end

	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data_extension:breed()

	if not Breed.is_player(target_breed) then
		return false
	end

	local disabled_character_state_component = target_unit_data_extension:read_component("disabled_character_state")
	local character_state_component = target_unit_data_extension:read_component("character_state")
	local _, netting_unit = PlayerUnitStatus.is_netted(disabled_character_state_component)
	local _, requires_help = PlayerUnitStatus.is_disabled(character_state_component)
	local is_dragging = attacking_unit_behavior_component.is_dragging
	local is_netting_unit = netting_unit == attacking_unit

	return not requires_help or is_netting_unit and is_dragging
end

return target_selection_template
