-- chunkname: @scripts/extension_systems/perception/target_selection_templates/companion_servo_skull_target_selection_template.lua

local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local non_aggressive_level_names = {
	om_basic_combat_01 = true,
	tg_shooting_range = true,
}

local function _is_target_aggroed(target_unit)
	local target_blackboard = BLACKBOARDS[target_unit]

	return target_blackboard.perception.aggro_state == PerceptionSettings.aggro_states.aggroed
end

local function _calculate_distances(target_unit, companion_position, owner_unit_position)
	local target_unit_position = POSITION_LOOKUP[target_unit]
	local distance_sq_owner_target = Vector3.distance_squared(owner_unit_position, target_unit_position)
	local delta_z = math.abs((target_unit_position - owner_unit_position).z)

	return distance_sq_owner_target, delta_z
end

local function _set_up_selected_target(unit, target_unit, companion_position, line_of_sight_lookup, perception_component, distance_sq_companion_target)
	local has_line_of_sight = line_of_sight_lookup[target_unit]

	perception_component.has_line_of_sight = has_line_of_sight

	local target_position = POSITION_LOOKUP[target_unit]
	local z_distance = math.abs(companion_position.z - target_position.z)

	perception_component.target_distance = math.sqrt(distance_sq_companion_target)
	perception_component.target_distance_z = z_distance
	perception_component.target_speed_away = MinionMovement.target_speed_away(unit, target_unit)
end

local FAR_DISTANCE = 20
local FAR_DISTANCE_NO_COMBAT = 10
local CLOSE_DISTANCE = 8
local CLOSE_DISTANCE_NO_COMBAT = 4
local targeting_owner_weight = 3
local special_weight = 2
local elite_weight = 2
local close_melee_weight = 3
local dot_check = 0.5
local in_dot_weight = 5
local player_radius = FAR_DISTANCE
local player_clossness_weight = 1.5
local dangerous_target_weight = 1
local maxPenalty = 10
local target_selection_template = {}

target_selection_template.companion_servo_skull = function (unit, side, perception_component, buff_extension, breed, target_units, line_of_sight_lookup, t, threat_units, force_new_target_attempt, force_new_target_attempt_config_or_nil, debug_target_weighting_or_nil)
	local is_in_hub = Managers.state.game_mode:is_social_hub() or Managers.state.game_mode:is_prologue_hub()

	if is_in_hub then
		return nil
	end

	local target_unit = perception_component.target_unit
	local companion_blackboard = BLACKBOARDS[unit]
	local owner_unit = companion_blackboard.behavior.owner_unit
	local companion_position = POSITION_LOOKUP[unit]
	local owner_unit_position = POSITION_LOOKUP[owner_unit]
	local disabling_unit
	local owner_unit_data_extension = ScriptUnit.has_extension(owner_unit, "unit_data_system")

	if not owner_unit_data_extension then
		return nil
	end

	local character_state_component = owner_unit_data_extension:read_component("character_state")
	local entered_t = character_state_component and character_state_component.entered_t or 0
	local target_disable_cooldown_t = entered_t + CompanionServoSkullSettings.initial_target_disable_cooldown
	local disabled_character_state = owner_unit_data_extension:read_component("disabled_character_state")

	if PlayerUnitStatus.is_pounced(disabled_character_state) and target_disable_cooldown_t < t then
		disabling_unit = disabled_character_state.disabling_unit
	elseif PlayerUnitStatus.is_warp_grabbed(disabled_character_state) and target_disable_cooldown_t < t then
		disabling_unit = disabled_character_state.disabling_unit
	elseif PlayerUnitStatus.is_mutant_charged(disabled_character_state) and target_disable_cooldown_t < t then
		disabling_unit = disabled_character_state.disabling_unit
	elseif PlayerUnitStatus.is_consumed(disabled_character_state) and target_disable_cooldown_t < t then
		disabling_unit = disabled_character_state.disabling_unit
	elseif PlayerUnitStatus.is_grabbed(disabled_character_state) and target_disable_cooldown_t < t then
		disabling_unit = disabled_character_state.disabling_unit
	end

	local distance_sq_owner_target = math.huge, math.huge, math.huge

	if disabling_unit then
		distance_sq_owner_target = _calculate_distances(disabling_unit, companion_position, owner_unit_position)

		_set_up_selected_target(unit, disabling_unit, companion_position, line_of_sight_lookup, perception_component, distance_sq_owner_target)

		return disabling_unit
	end

	local companion_whistle_component = companion_blackboard.whistle
	local companion_whistle_target = companion_whistle_component.current_target

	if companion_whistle_target and HEALTH_ALIVE[companion_whistle_target] then
		local has_line_of_sight = line_of_sight_lookup[companion_whistle_target]

		if has_line_of_sight then
			distance_sq_owner_target = _calculate_distances(companion_whistle_target, companion_position, owner_unit_position)

			_set_up_selected_target(unit, companion_whistle_target, companion_position, line_of_sight_lookup, perception_component, distance_sq_owner_target)

			return companion_whistle_target
		end
	end

	local mission_name = Managers.state.mission:mission_name()

	if non_aggressive_level_names[mission_name] then
		local training_ground_force_companion_in_combat_state = buff_extension and buff_extension:has_keyword("training_ground_force_companion_in_combat_state")

		if not training_ground_force_companion_in_combat_state then
			return nil
		end
	end

	local owner_attack_intensity_extension = ScriptUnit.has_extension(owner_unit, "attack_intensity_system")
	local in_combat = not owner_attack_intensity_extension or owner_attack_intensity_extension:in_combat_for_companion(buff_extension)
	local target_changed_t = perception_component.target_changed_t
	local select_target_cooldown = breed.select_target_cooldown

	if HEALTH_ALIVE[target_unit] and t <= target_changed_t + select_target_cooldown then
		local has_line_of_sight = line_of_sight_lookup[target_unit]

		if has_line_of_sight then
			distance_sq_owner_target = _calculate_distances(target_unit, companion_position, owner_unit_position)

			_set_up_selected_target(unit, target_unit, companion_position, line_of_sight_lookup, perception_component, distance_sq_owner_target)

			return target_unit
		end
	end

	local lock_target = perception_component.lock_target
	local close_distance = in_combat and CLOSE_DISTANCE or CLOSE_DISTANCE_NO_COMBAT

	if not lock_target or lock_target and not HEALTH_ALIVE[target_unit] then
		local first_person_component = owner_unit_data_extension:read_component("first_person")
		local owner_rotation = first_person_component.rotation
		local owner_look_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(owner_rotation)))
		local chosen_unit
		local chosen_unit_weight = -math.huge

		for i = 1, #target_units do
			repeat
				local finalScore = 0
				local possible_unit = target_units[i]
				local is_aggroed = _is_target_aggroed(possible_unit)
				local is_alive = HEALTH_ALIVE[possible_unit]

				if is_aggroed and is_alive then
					local unit_data_extension = ScriptUnit.has_extension(possible_unit, "unit_data_system")
					local possible_unit_breed = unit_data_extension:breed()
					local ignore_target_selection = possible_unit_breed.companion_pounce_setting.ignore_target_selection

					if not ignore_target_selection then
						local tags = possible_unit_breed.tags
						local check_dist_sq_owner_target, delta_z = _calculate_distances(possible_unit, companion_position, owner_unit_position)
						local close = check_dist_sq_owner_target < close_distance
						local distance_owner = math.sqrt(check_dist_sq_owner_target)
						local player_distance = math.min(distance_owner, player_radius) / player_radius
						local possible_unit_blackboard = BLACKBOARDS[possible_unit]
						local possible_unit_perception_component = possible_unit_blackboard.perception
						local possible_unit_target_unit = possible_unit_perception_component.target_unit
						local targeting_owner = possible_unit_target_unit == owner_unit
						local player_focus = targeting_owner and 1 or 0
						local threatVal = 1

						if tags then
							local is_special = tags.special
							local is_elite = tags.elite
							local is_melee = tags.melee

							if is_special then
								threatVal = threatVal + special_weight
							end

							if is_elite then
								threatVal = threatVal + elite_weight
							end

							if is_melee and close then
								threatVal = threatVal + close_melee_weight
							end
						end

						local possible_unit_position = POSITION_LOOKUP[possible_unit]
						local direction_to_possible_unit = Vector3.normalize(possible_unit_position - owner_unit_position)
						local dot = Vector3.dot(direction_to_possible_unit, owner_look_direction)
						local normalized_angle_target_owner = math.clamp((dot - dot_check) / (1 - dot_check), 0, 1)
						local baseScore = player_clossness_weight * (1 - player_distance) + targeting_owner_weight * player_focus + dangerous_target_weight * threatVal + in_dot_weight * normalized_angle_target_owner

						baseScore = baseScore / math.max(delta_z, 1)

						local penalty = 0
						local far_distance = in_combat and FAR_DISTANCE or FAR_DISTANCE_NO_COMBAT

						if far_distance < distance_owner then
							penalty = math.huge
						elseif close_distance < distance_owner then
							local t_calculated = (distance_owner - close_distance) / (far_distance - close_distance)

							penalty = maxPenalty * (t_calculated * t_calculated)
						end

						finalScore = baseScore - penalty

						if chosen_unit_weight < finalScore then
							local has_line_of_sight = line_of_sight_lookup[possible_unit]

							if has_line_of_sight then
								chosen_unit = possible_unit
								chosen_unit_weight = finalScore
							end
						end
					end
				end
			until true
		end

		if chosen_unit then
			distance_sq_owner_target = _calculate_distances(chosen_unit, companion_position, owner_unit_position)

			_set_up_selected_target(unit, chosen_unit, companion_position, line_of_sight_lookup, perception_component, distance_sq_owner_target)

			return chosen_unit
		end

		if target_unit and HEALTH_ALIVE[target_unit] then
			local has_line_of_sight = line_of_sight_lookup[target_unit]

			if has_line_of_sight then
				distance_sq_owner_target = _calculate_distances(target_unit, companion_position, owner_unit_position)

				_set_up_selected_target(unit, target_unit, companion_position, line_of_sight_lookup, perception_component, distance_sq_owner_target)
			else
				return nil
			end
		end
	elseif HEALTH_ALIVE[target_unit] then
		local has_line_of_sight = line_of_sight_lookup[target_unit]

		if has_line_of_sight then
			distance_sq_owner_target = _calculate_distances(target_unit, companion_position, owner_unit_position)

			_set_up_selected_target(unit, target_unit, companion_position, line_of_sight_lookup, perception_component, distance_sq_owner_target)
		else
			return nil
		end
	end

	return HEALTH_ALIVE[target_unit] and target_unit
end

return target_selection_template
