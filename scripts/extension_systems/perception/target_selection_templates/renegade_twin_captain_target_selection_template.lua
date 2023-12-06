local Breed = require("scripts/utilities/breed")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionTargetSelection = require("scripts/utilities/minion_target_selection")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local aggro_states = PerceptionSettings.aggro_states

local function _calculate_score(breed, unit, target_unit, distance_sq, is_new_target, threat_units, perception_component, t, debug_target_weighting_or_nil)
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
	local disabled_weight = MinionTargetSelection.disabled_weight(target_selection_weights, target_unit, target_breed)
	score = score + disabled_weight
	local targeted_by_monster_weight = MinionTargetSelection.targeted_by_monster_weight(target_selection_weights, target_unit, unit)
	score = score + targeted_by_monster_weight
	local stickiness_weight = MinionTargetSelection.stickiness_weight(target_selection_weights, is_new_target, perception_component, t)
	score = score + stickiness_weight
	local weight_multiplier = MinionTargetSelection.weight_multiplier(target_unit)
	score = score * weight_multiplier

	return math.max(score, 0)
end

local DEFAULT_STICKINESS_DISTANCE = 1
local target_selection_template = {}
local EXTRA_SHOOT_DISTANCE_SQ = 225

target_selection_template.renegade_twin_captain = function (unit, side, perception_component, buff_extension, breed, target_units, line_of_sight_lookup, t, threat_units, force_new_target_attempt, force_new_target_attempt_config_or_nil, debug_target_weighting_or_nil)
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
			local is_new_target = false
			best_score = _calculate_score(breed, unit, current_target_unit, distance_sq - stickiness, is_new_target, threat_units, perception_component, t, debug_target_weighting_or_nil)
		end
	else
		closest_z_distance = math.huge
		closest_distance_sq = math.huge
		best_target_unit = nil
		best_score = -math.huge
	end

	local lock_target = perception_component.lock_target

	if not lock_target then
		local taunter_unit = buff_extension:owner_of_buff_with_id("taunted")

		if target_units[taunter_unit] then
			local target_position = POSITION_LOOKUP[taunter_unit]
			local distance_to_target_sq = vector3_distance_squared(position, target_position)
			local z_distance = math.abs(position.z - target_position.z)
			closest_z_distance = z_distance
			closest_distance_sq = distance_to_target_sq
			best_target_unit = taunter_unit
		else
			local vector3_normalize = Vector3.normalize
			local vector3_angle = Vector3.angle
			local aggro_state = perception_component.aggro_state
			local rotation = Unit.world_rotation(unit, 1)
			local forward_direction = Quaternion.forward(rotation)
			local blackboard = BLACKBOARDS[unit]
			local behavior_component = blackboard.behavior

			for i = 1, #target_units do
				local target_unit = target_units[i]
				local target_position = POSITION_LOOKUP[target_unit]
				local distance_sq = vector3_distance_squared(position, target_position)
				local target_direction = vector3_normalize(target_position - position)
				local angle = distance_sq > 0.1 and Vector3.length(forward_direction) > 0.01 and vector3_angle(target_direction, forward_direction) or math.huge
				local is_valid_target = _is_valid_target(unit, target_unit, behavior_component, distance_sq, angle, force_new_target_attempt_config_or_nil)

				if is_valid_target and target_unit ~= current_target_unit then
					local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
					local target_breed = unit_data_extension:breed()
					local is_shooting = false

					if Breed.is_player(target_breed) then
						local shooting_status = unit_data_extension:read_component("shooting_status")
						is_shooting = shooting_status.shooting or not shooting_status.shooting and t <= shooting_status.shooting_end_time + 1
					end

					local distance_to_target_sq = vector3_distance_squared(position, target_position)
					local check_distance_sq = is_shooting and distance_to_target_sq - EXTRA_SHOOT_DISTANCE_SQ or distance_to_target_sq

					if aggro_state == aggro_states.aggroed or check_distance_sq < detection_radius_sq then
						local is_new_target = true
						local score = _calculate_score(breed, unit, target_unit, distance_to_target_sq, is_new_target, threat_units, perception_component, t, debug_target_weighting_or_nil)

						if best_score < score then
							local has_line_of_sight = line_of_sight_lookup[target_unit]

							if aggro_state == aggro_states.aggroed or has_line_of_sight then
								local z_distance = math.abs(position.z - target_position.z)
								closest_z_distance = z_distance
								closest_distance_sq = distance_to_target_sq
								best_target_unit = target_unit
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

	return true
end

return target_selection_template
