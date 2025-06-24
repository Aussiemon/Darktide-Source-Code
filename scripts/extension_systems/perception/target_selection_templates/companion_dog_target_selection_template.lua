-- chunkname: @scripts/extension_systems/perception/target_selection_templates/companion_dog_target_selection_template.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionTargetSelection = require("scripts/utilities/minion_target_selection")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local CompanionDogSettings = require("scripts/utilities/companion/companion_dog_settings")

local function _calculate_score(breed, unit, target_unit, distance_sq, is_new_target, threat_units, debug_target_weighting_or_nil)
	return 0
end

local function _is_target_aggroed(target_unit)
	local target_blackboard = BLACKBOARDS[target_unit]

	return target_blackboard.perception.aggro_state == PerceptionSettings.aggro_states.aggroed
end

local function _calculate_distances(target_unit, companion_position, owner_unit_position)
	local target_unit_position = POSITION_LOOKUP[target_unit]
	local distance_sq_companion_target = Vector3.distance_squared(companion_position, target_unit_position)
	local distance_sq_owner_target = Vector3.distance_squared(owner_unit_position, target_unit_position)
	local distance_sq = distance_sq_companion_target + distance_sq_owner_target
	local delta_z = math.abs((target_unit_position - owner_unit_position).z)

	return distance_sq_companion_target, distance_sq_owner_target, distance_sq, delta_z
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

local FAR_DISTANCE = 16
local RANGED_FOCUS_FAR_DISTANCE = 45
local CLOSE_DISTANCE = 6
local RANGED_FOCUS_CLOSE_DISTANCE = 15
local targeting_owner_weight = 3
local special_weight = 2
local elite_weight = 2
local elite_focus_weight = 10
local special_focus_weight = 12
local melee_focus_weight = 10
local ranged_focus_weight = 10
local close_melee_weight = 3
local dot_check = 0.5
local in_dot_weight = 5
local player_radius, dog_radius = FAR_DISTANCE, FAR_DISTANCE * 1.25
local player_clossness_weight, dog_clossness_weight = 1.5, 0.5
local dangerous_target_weight = 1
local maxPenalty = 10

local function _get_token(target)
	local unit_data_extension = ScriptUnit.has_extension(target, "unit_data_system")

	if not unit_data_extension then
		return
	end

	local possible_unit_breed = unit_data_extension:breed()
	local companion_pounce_setting = possible_unit_breed.companion_pounce_setting

	return companion_pounce_setting.required_token
end

local function _check_for_token(unit, target, optional_assign_token)
	local required_token = _get_token(target)

	if required_token then
		local required_token_name = required_token.name
		local token_extension = ScriptUnit.has_extension(target, "token_system")

		if token_extension then
			if token_extension:is_token_free_or_mine(unit, required_token_name) then
				if optional_assign_token then
					token_extension:assign_token(unit, required_token_name)
				end

				return true
			else
				return not required_token.free_target_on_assigned_token
			end
		end
	end

	return true
end

local function _free_token(unit, target)
	local required_token = _get_token(target)

	if required_token then
		local required_token_name = required_token.name
		local token_extension = ScriptUnit.has_extension(target, "token_system")

		if token_extension and token_extension:is_token_free_or_mine(unit, required_token_name) then
			token_extension:free_token(required_token_name)
		end
	end
end

local target_selection_template = {}

target_selection_template.companion_dog = function (unit, side, perception_component, buff_extension, breed, target_units, line_of_sight_lookup, t, threat_units, force_new_target_attempt, force_new_target_attempt_config_or_nil, debug_target_weighting_or_nil)
	local target_unit = perception_component.target_unit
	local companion_blackboard = BLACKBOARDS[unit]
	local companion_position = POSITION_LOOKUP[unit]
	local owner_unit = companion_blackboard.behavior.owner_unit
	local owner_unit_position = POSITION_LOOKUP[owner_unit]
	local talent_extension = ScriptUnit.extension(owner_unit, "talent_system")
	local melee_focus = talent_extension:has_special_rule("adamant_companion_melee_focus")
	local ranged_focus = talent_extension:has_special_rule("adamant_companion_ranged_focus")
	local elite_focus = talent_extension:has_special_rule("adamant_companion_elite_focus")
	local companion_pounce_component = Blackboard.write_component(companion_blackboard, "pounce")
	local disabling_unit
	local owner_unit_data_extension = ScriptUnit.has_extension(owner_unit, "unit_data_system")

	if not owner_unit_data_extension then
		return nil
	end

	local character_state_component = owner_unit_data_extension:read_component("character_state")
	local entered_t = character_state_component and character_state_component.entered_t or 0
	local target_disable_cooldown_t = entered_t + CompanionDogSettings.initial_target_disable_cooldown
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

	local distance_sq_companion_target, distance_sq_owner_target, distance_sq = math.huge, math.huge, math.huge

	if disabling_unit then
		distance_sq_companion_target, distance_sq_owner_target, distance_sq = _calculate_distances(disabling_unit, companion_position, owner_unit_position)

		if disabling_unit ~= target_unit then
			companion_pounce_component.use_fast_jump = false

			_free_token(unit, target_unit)
		end

		_set_up_selected_target(unit, disabling_unit, companion_position, line_of_sight_lookup, perception_component, distance_sq_companion_target)

		return disabling_unit
	end

	local companion_whistle_component = Blackboard.write_component(companion_blackboard, "whistle")
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")
	local tagged_unit, tag = smart_tag_system:unit_tagged_by_player_unit(owner_unit)
	local tag_template = tag and tag:template()
	local tag_type = tag_template and tag_template.marker_type
	local companion_whistle_target

	if tag_type == "unit_threat_adamant" then
		local invalid_target = false
		local unit_data_extension = ScriptUnit.has_extension(tagged_unit, "unit_data_system")
		local breed = unit_data_extension and unit_data_extension:breed()
		local daemonhost = breed and breed.tags.witch

		if daemonhost then
			local daemonhost_blackboard = BLACKBOARDS[tagged_unit]
			local daemonhost_perception_component = daemonhost_blackboard.perception
			local is_aggroed = daemonhost_perception_component.aggro_state == "aggroed"

			invalid_target = not is_aggroed
		end

		if not invalid_target then
			companion_whistle_component.current_target = tagged_unit
			companion_whistle_target = tagged_unit
		end
	end

	if companion_whistle_target then
		local optional_assign_token = false

		if HEALTH_ALIVE[companion_whistle_target] and _check_for_token(unit, companion_whistle_target, optional_assign_token) then
			distance_sq_companion_target = _calculate_distances(companion_whistle_target, companion_position, owner_unit_position)

			if companion_whistle_target ~= target_unit then
				companion_pounce_component.use_fast_jump = false

				_free_token(unit, target_unit)
			end

			_set_up_selected_target(unit, companion_whistle_target, companion_position, line_of_sight_lookup, perception_component, distance_sq_companion_target)

			return companion_whistle_target
		else
			companion_whistle_component = Blackboard.write_component(companion_blackboard, "whistle")
			companion_whistle_component.current_target = nil
		end
	end

	local pounce_target = companion_blackboard.pounce.pounce_target
	local owner_attack_intensity_extension = ScriptUnit.has_extension(owner_unit, "attack_intensity_system")
	local in_combat = pounce_target or not owner_attack_intensity_extension or owner_attack_intensity_extension:in_combat_for_companion()

	if not in_combat then
		_free_token(unit, target_unit)

		return
	end

	local target_changed_t = perception_component.target_changed_t
	local select_target_cooldown = breed.select_target_cooldown

	if target_unit and HEALTH_ALIVE[target_unit] and t <= target_changed_t + select_target_cooldown then
		return target_unit
	end

	local lock_target = perception_component.lock_target
	local close_distane = ranged_focus and RANGED_FOCUS_CLOSE_DISTANCE or CLOSE_DISTANCE

	if not lock_target and not pounce_target then
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
						local optional_assign_token = false

						if not _check_for_token(unit, possible_unit, optional_assign_token) then
							break
						end

						local tags = possible_unit_breed.tags
						local check_dist_sq_companion_target, check_dist_sq_owner_target, _, delta_z = _calculate_distances(possible_unit, companion_position, owner_unit_position)
						local close = check_dist_sq_owner_target < close_distane
						local distance_owner = math.sqrt(check_dist_sq_owner_target)
						local distCompanion = math.sqrt(check_dist_sq_companion_target)
						local player_distance = math.min(distance_owner, player_radius) / player_radius
						local dog_distance = math.min(distCompanion, dog_radius) / dog_radius
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
							local is_ranged = tags.far or possible_unit_breed.ranged

							if is_special then
								threatVal = threatVal + special_weight
							end

							if is_elite then
								threatVal = threatVal + elite_weight
							end

							if is_melee and close then
								threatVal = threatVal + close_melee_weight
							end

							if is_melee and melee_focus then
								threatVal = threatVal + melee_focus_weight
							end

							if is_ranged and ranged_focus then
								threatVal = threatVal + ranged_focus_weight
							end

							if is_elite and elite_focus then
								threatVal = threatVal + elite_focus_weight
							end

							if is_special and elite_focus then
								threatVal = threatVal + special_focus_weight
							end
						end

						local possible_unit_position = POSITION_LOOKUP[possible_unit]
						local direction_to_possible_unit = Vector3.normalize(possible_unit_position - owner_unit_position)
						local dot = Vector3.dot(direction_to_possible_unit, owner_look_direction)
						local normalized_angle_target_owner = math.clamp((dot - dot_check) / (1 - dot_check), 0, 1)
						local baseScore = player_clossness_weight * (1 - player_distance) + dog_clossness_weight * (1 - dog_distance) + targeting_owner_weight * player_focus + dangerous_target_weight * threatVal + in_dot_weight * normalized_angle_target_owner

						baseScore = baseScore / math.max(delta_z, 1)

						local penalty = 0
						local far_distance = ranged_focus and RANGED_FOCUS_FAR_DISTANCE or FAR_DISTANCE

						if far_distance < distance_owner then
							penalty = math.huge
						elseif close_distane < distance_owner then
							local t_calculated = (distance_owner - close_distane) / (far_distance - close_distane)

							penalty = maxPenalty * (t_calculated * t_calculated)
						end

						finalScore = baseScore - penalty

						if chosen_unit_weight < finalScore then
							local perception_extension = ScriptUnit.has_extension(possible_unit, "perception_system")
							local has_line_of_sight = perception_extension and perception_extension:immediate_line_of_sight_check(owner_unit)

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
			if chosen_unit ~= target_unit then
				companion_pounce_component.use_fast_jump = false

				_free_token(unit, target_unit)
			end

			distance_sq_companion_target, distance_sq_owner_target, distance_sq = _calculate_distances(chosen_unit, companion_position, owner_unit_position)

			_set_up_selected_target(unit, chosen_unit, companion_position, line_of_sight_lookup, perception_component, distance_sq_companion_target)

			return chosen_unit
		end

		if target_unit and HEALTH_ALIVE[target_unit] then
			local required_token = _get_token(target_unit)
			local optional_assign_token = false

			if not _check_for_token(unit, target_unit, optional_assign_token) and required_token.free_target_on_assigned_token then
				target_unit = nil
			else
				distance_sq_companion_target = _calculate_distances(target_unit, companion_position, owner_unit_position)

				_set_up_selected_target(unit, target_unit, companion_position, line_of_sight_lookup, perception_component, distance_sq_companion_target)
			end
		end
	end

	return HEALTH_ALIVE[target_unit] and target_unit
end

return target_selection_template
