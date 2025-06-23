-- chunkname: @scripts/utilities/minion_target_selection.lua

local AttackIntensity = require("scripts/utilities/attack_intensity")
local Breed = require("scripts/utilities/breed")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local MinionTargetSelection = {}
local DEFAULT_TARGETED_BY_MONSTER_WEIGHT = -5

MinionTargetSelection.targeted_by_monster_weight = function (target_selection_weights, target_unit, attacker_unit)
	local monster_attacker_unit = AttackIntensity.monster_attacker(target_unit)

	if monster_attacker_unit and monster_attacker_unit ~= attacker_unit then
		local targeted_by_monster_weight = target_selection_weights.targeted_by_monster or DEFAULT_TARGETED_BY_MONSTER_WEIGHT

		return targeted_by_monster_weight
	end

	return 0
end

local DEFAULT_TARGET_DISABLED_WEIGHT = -2
local DEFAULT_DISABLING_TYPE_WEIGHTS = {
	grabbed = -8000,
	consumed = -8000
}

MinionTargetSelection.disabled_weight = function (target_selection_weights, target_unit, target_breed)
	if not Breed.is_player(target_breed) then
		return 0
	end

	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local character_state_component = target_unit_data_extension:read_component("character_state")
	local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

	if not is_disabled then
		return 0
	end

	local disabled_character_state_component = target_unit_data_extension:read_component("disabled_character_state")
	local disabling_type = disabled_character_state_component.disabling_type
	local selection_disabling_type = target_selection_weights.disabling_type
	local disabling_type_weight = selection_disabling_type and selection_disabling_type[disabling_type] or DEFAULT_DISABLING_TYPE_WEIGHTS[disabling_type] or 0
	local disabled_weight = (target_selection_weights.disabled or DEFAULT_TARGET_DISABLED_WEIGHT) + disabling_type_weight

	return disabled_weight
end

local DEFAULT_STICKINESS_WEIGHT = 100

MinionTargetSelection.stickiness_weight = function (target_selection_weights, is_new_target, perception_component, t)
	if not is_new_target then
		local stickiness_duration = target_selection_weights.stickiness_duration
		local target_changed_t = perception_component.target_changed_t

		if stickiness_duration > t - target_changed_t then
			local stickiness_weight = target_selection_weights.stickiness_bonus or DEFAULT_STICKINESS_WEIGHT

			return stickiness_weight
		end
	end

	return 0
end

local DEFAULT_DISTANCE_WEIGHT = 1

MinionTargetSelection.distance_weight = function (target_selection_weights, distance_sq, attacker_breed, optional_use_quadratic_falloff)
	local distance_weight
	local max_distance = target_selection_weights.max_distance or MinionTargetSelection.detection_radius(attacker_breed)
	local max_distance_sq = max_distance * max_distance
	local inverse_radius = math.clamp(1 - distance_sq / max_distance_sq, 0, 1)
	local weight = target_selection_weights.distance_to_target or DEFAULT_DISTANCE_WEIGHT

	if optional_use_quadratic_falloff then
		distance_weight = inverse_radius * inverse_radius * weight
	else
		distance_weight = inverse_radius * weight
	end

	local near_distance = target_selection_weights.near_distance

	if near_distance then
		local near_distance_sq = near_distance * near_distance

		if distance_sq <= near_distance_sq then
			local near_distance_bonus = target_selection_weights.near_distance_bonus

			distance_weight = distance_weight + near_distance_bonus
		end
	end

	return distance_weight, inverse_radius
end

MinionTargetSelection.coherency_weight = function (target_selection_weights, target_unit)
	local coherency_extension = ScriptUnit.has_extension(target_unit, "coherency_system")

	if not coherency_extension then
		return 0
	end

	local inverse_coherency_weight = target_selection_weights.inverse_coherency_weight
	local num_units_in_coherency = 4 - coherency_extension:num_units_in_coherency()
	local weight = inverse_coherency_weight * num_units_in_coherency

	return weight
end

local DEFAULT_THREAT_WEIGHT_MULTIPLIER = 1

MinionTargetSelection.threat_weight = function (target_selection_weights, target_unit, threat_units)
	local threat_weight = 0

	if threat_units[target_unit] then
		local threat = threat_units[target_unit]
		local threat_multiplier = target_selection_weights.threat_multiplier or DEFAULT_THREAT_WEIGHT_MULTIPLIER

		threat_weight = threat * threat_multiplier
	end

	return threat_weight
end

MinionTargetSelection.occupied_slots_weight = function (target_selection_weights, target_unit, target_breed, is_new_target, optional_inverse_radius)
	local occupied_slot_weight = target_selection_weights.occupied_slots

	if occupied_slot_weight and is_new_target then
		local total_occupied_slots_weight = 0

		if Breed.is_player(target_breed) then
			local slot_extension = ScriptUnit.extension(target_unit, "slot_system")
			local num_occupied_slots = slot_extension.num_occupied_slots

			total_occupied_slots_weight = num_occupied_slots * occupied_slot_weight
		elseif is_new_target and target_breed.count_num_enemies_targeting then
			-- Nothing
		end

		if optional_inverse_radius then
			total_occupied_slots_weight = total_occupied_slots_weight * (1 - optional_inverse_radius)
		end

		return total_occupied_slots_weight
	end

	return 0
end

MinionTargetSelection.attack_not_allowed_weight = function (target_selection_weights, target_unit, target_breed, attack_type)
	local attack_not_allowed_weight = target_selection_weights.attack_not_allowed

	if attack_not_allowed_weight and Breed.is_player(target_breed) then
		local attack_allowed = AttackIntensity.player_can_be_attacked(target_unit, attack_type)

		if not attack_allowed then
			return attack_not_allowed_weight
		end
	end

	return 0
end

MinionTargetSelection.line_of_sight_weight = function (target_selection_weights, target_unit, line_of_sight_lookup)
	local line_of_sight_weight = target_selection_weights.line_of_sight_weight

	if line_of_sight_weight and line_of_sight_lookup[target_unit] then
		return line_of_sight_weight
	end

	return 0
end

MinionTargetSelection.combat_vector_main_aggro_weight = function (target_selection_weights, target_unit)
	local combat_vector_main_aggro_weight = target_selection_weights.combat_vector_main_aggro_weight

	if combat_vector_main_aggro_weight then
		local combat_vector_system = Managers.state.extension:system("combat_vector_system")
		local main_aggro_scores = combat_vector_system:get_main_aggro_scores()
		local aggro_score = main_aggro_scores[target_unit]

		if aggro_score then
			local total_weight = aggro_score * combat_vector_main_aggro_weight

			return total_weight
		end
	end

	return 0
end

MinionTargetSelection.archetype_weight = function (target_selection_weights, target_unit, target_breed)
	if Breed.is_player(target_breed) then
		local unit_data = ScriptUnit.extension(target_unit, "unit_data_system")
		local archetype_name = unit_data:archetype_name()
		local archetype_weights = target_selection_weights.archetypes
		local archetype_weight = archetype_weights[archetype_name] or 0

		return archetype_weight
	end

	return 0
end

MinionTargetSelection.weight_multiplier = function (target_unit)
	local multiplier = 1
	local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if buff_extension then
		local stat_buffs = buff_extension:stat_buffs()
		local threat_weight_multiplier = stat_buffs.threat_weight_multiplier

		multiplier = multiplier * threat_weight_multiplier
	end

	return multiplier
end

MinionTargetSelection.taunt_weight_multiplier = function (target_selection_weights, target_unit, taunter_unit_or_nil)
	local multiplier = 1

	if target_unit == taunter_unit_or_nil then
		multiplier = target_selection_weights.taunt_weight_multiplier
	end

	return multiplier
end

MinionTargetSelection.knocked_down_weight = function (target_selection_weights, target_unit_data_extension, target_breed)
	if target_selection_weights.knocked_down_weight and Breed.is_player(target_breed) then
		local character_state_component = target_unit_data_extension:read_component("character_state")
		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

		if is_knocked_down then
			local knocked_down_weight = target_selection_weights.knocked_down_weight

			return knocked_down_weight
		end
	end

	return 0
end

MinionTargetSelection.ledge_hanging_weight = function (target_selection_weights, target_unit_data_extension, target_breed)
	local ledge_hanging_weight = target_selection_weights.ledge_hanging_weight

	if ledge_hanging_weight and Breed.is_player(target_breed) then
		local character_state_component = target_unit_data_extension:read_component("character_state")
		local is_ledge_hanging = PlayerUnitStatus.is_ledge_hanging(character_state_component)

		if is_ledge_hanging then
			return ledge_hanging_weight
		end
	end

	return 0
end

local DARKNESS_LOS_MODIFIER_NAME = "mutator_darkness_los"
local VENTILATION_PURGE_LOS_MODIFIER_NAME = "mutator_ventilation_purge_los"
local CIRCUMSTANCE_DETECTION_RADIUS_MODIFIERS = {
	mutator_ventilation_purge_los = 0.7,
	mutator_darkness_los = 0.5
}

MinionTargetSelection.detection_radius = function (breed)
	local detection_radius = breed.detection_radius
	local mutator_manager = Managers.state.mutator
	local los_modifier = mutator_manager:mutator(DARKNESS_LOS_MODIFIER_NAME) and DARKNESS_LOS_MODIFIER_NAME or mutator_manager:mutator(VENTILATION_PURGE_LOS_MODIFIER_NAME) and VENTILATION_PURGE_LOS_MODIFIER_NAME

	if los_modifier then
		return detection_radius * CIRCUMSTANCE_DETECTION_RADIUS_MODIFIERS[los_modifier]
	end

	return detection_radius
end

return MinionTargetSelection
