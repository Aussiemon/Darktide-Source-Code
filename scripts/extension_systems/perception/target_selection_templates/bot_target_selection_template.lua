-- chunkname: @scripts/extension_systems/perception/target_selection_templates/bot_target_selection_template.lua

local BotTargetSelection = require("scripts/utilities/bot_target_selection")
local Breed = require("scripts/utilities/breed")
local target_selection_template = {}
local _calculate_score, _calculate_common_score, _calculate_melee_score, _calculate_ranged_score, _is_valid_target, _get_debug_info

target_selection_template.bot_default = function (unit, unit_position, side, perception_component, behavior_component, breed, target_units, t, threat_units, bot_group, target_selection_debug_info_or_nil)
	local melee_gestalt = behavior_component.melee_gestalt
	local ranged_gestalt = behavior_component.ranged_gestalt
	local best_melee_score, best_melee_target, best_melee_target_distance_sq = -math.huge, nil, math.huge
	local best_ranged_score, best_ranged_target, best_ranged_target_distance_sq = -math.huge, nil, math.huge
	local best_priority_score, best_priority_target = -math.huge
	local best_urgent_score, best_urgent_target = -math.huge
	local best_opportunity_score, best_opportunity_target = -math.huge
	local aggroed_minion_target_units = side.aggroed_minion_target_units
	local target_ally = perception_component.target_ally
	local current_target_enemy = perception_component.target_enemy

	current_target_enemy = HEALTH_ALIVE[current_target_enemy] and current_target_enemy or nil

	local vector3_distance_squared = Vector3.distance_squared
	local POSITION_LOOKUP = POSITION_LOOKUP
	local should_fully_reevaluate = false

	if not current_target_enemy or t > perception_component.target_enemy_reevaluation_t then
		should_fully_reevaluate = true
	end

	local new_target_enemy, new_target_enemy_distance_sq, new_target_enemy_type = nil, math.huge, "none"

	if should_fully_reevaluate then
		local num_target_units = #target_units

		for i = 1, num_target_units do
			local target_unit = target_units[i]
			local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
			local target_breed = target_unit_data_extension:breed()
			local is_valid_target = _is_valid_target(target_unit, target_breed, aggroed_minion_target_units)

			if is_valid_target then
				local target_position = POSITION_LOOKUP[target_unit]
				local target_distance_sq = vector3_distance_squared(unit_position, target_position)
				local melee_score, ranged_score, is_urgent_target, is_priority_target, is_opportunity_target = _calculate_score(unit, target_unit, target_breed, target_distance_sq, melee_gestalt, ranged_gestalt, t, bot_group, current_target_enemy, target_ally, threat_units, debug_info_or_nil)

				if best_melee_score < melee_score then
					best_melee_score, best_melee_target, best_melee_target_distance_sq = melee_score, target_unit, target_distance_sq
				end

				if best_ranged_score < ranged_score then
					best_ranged_score, best_ranged_target, best_ranged_target_distance_sq = ranged_score, target_unit, target_distance_sq
				end

				local best_score = math.max(melee_score, ranged_score)

				if is_urgent_target and best_urgent_score < best_score then
					best_urgent_score = best_score
					best_urgent_target = target_unit
				end

				if is_priority_target and best_priority_score < best_score then
					best_priority_score = best_score
					best_priority_target = target_unit
				end

				if is_opportunity_target and best_opportunity_score < best_score then
					best_opportunity_score = best_score
					best_opportunity_target = target_unit
				end
			end
		end

		if best_melee_target or best_ranged_target then
			if best_ranged_score < best_melee_score then
				new_target_enemy = best_melee_target
				new_target_enemy_distance_sq = best_melee_target_distance_sq
				new_target_enemy_type = "melee"
			else
				new_target_enemy = best_ranged_target
				new_target_enemy_distance_sq = best_ranged_target_distance_sq
				new_target_enemy_type = "ranged"
			end
		end

		perception_component.target_enemy_reevaluation_t = t + 0.3
	elseif current_target_enemy then
		local target_unit = current_target_enemy
		local target_position = POSITION_LOOKUP[target_unit]
		local target_distance_sq = vector3_distance_squared(unit_position, target_position)
		local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
		local target_breed = target_unit_data_extension:breed()
		local melee_score, ranged_score, _, _, _ = _calculate_score(unit, target_unit, target_breed, target_distance_sq, melee_gestalt, ranged_gestalt, t, bot_group, current_target_enemy, target_ally, threat_units, debug_info_or_nil)

		new_target_enemy_type = ranged_score < melee_score and "melee" or "ranged"
		new_target_enemy = current_target_enemy
		new_target_enemy_distance_sq = target_distance_sq
	end

	if perception_component.target_enemy or new_target_enemy then
		perception_component.target_enemy = new_target_enemy
	end

	if new_target_enemy then
		perception_component.target_enemy_distance = math.sqrt(new_target_enemy_distance_sq)
		perception_component.target_enemy_type = new_target_enemy_type
	end

	if perception_component.urgent_target_enemy or best_urgent_target then
		perception_component.urgent_target_enemy = best_urgent_target
	end

	if perception_component.priority_target_enemy or best_priority_target then
		perception_component.priority_target_enemy = best_priority_target
	end

	if perception_component.opportunity_target_enemy or best_opportunity_target then
		perception_component.opportunity_target_enemy = best_opportunity_target
	end
end

function _calculate_score(unit, target_unit, target_breed, target_distance_sq, melee_gestalt, ranged_gestalt, t, bot_group, current_target_enemy, target_ally, threat_units, debug_info_or_nil)
	local common_score, is_urgent_target, is_priority_target, is_opportunity_target = _calculate_common_score(unit, target_unit, target_breed, t, bot_group, current_target_enemy, debug_info_or_nil)
	local melee_score = common_score + _calculate_melee_score(unit, target_unit, melee_gestalt, target_breed, target_distance_sq, target_ally, debug_info_or_nil)
	local ranged_score = common_score + _calculate_ranged_score(unit, target_unit, ranged_gestalt, target_breed, target_distance_sq, threat_units, debug_info_or_nil)

	return melee_score, ranged_score, is_urgent_target, is_priority_target, is_opportunity_target
end

function _calculate_common_score(unit, target_unit, target_breed, t, bot_group, current_target_enemy, debug_info_or_nil)
	local score = 0
	local opportunity_weight, is_opportunity_target = BotTargetSelection.opportunity_weight(unit, target_unit, target_breed, t)

	score = score + opportunity_weight

	local priority_weight, is_priority_target = BotTargetSelection.priority_weight(target_unit, bot_group)

	score = score + priority_weight

	local monster_weight, is_urgent_target = BotTargetSelection.monster_weight(unit, target_unit, target_breed, t)

	score = score + monster_weight

	local current_target_weight = BotTargetSelection.current_target_weight(target_unit, current_target_enemy)

	score = score + current_target_weight

	return score, is_urgent_target, is_priority_target, is_opportunity_target
end

function _calculate_melee_score(unit, target_unit, melee_gestalt, target_breed, target_distance_sq, target_ally, debug_info_or_nil)
	local score = 0
	local gestalt_weight = BotTargetSelection.gestalt_weight(melee_gestalt, target_breed)

	score = score + gestalt_weight

	local slot_weight = BotTargetSelection.slot_weight(unit, target_unit, target_distance_sq, target_breed, target_ally)

	score = score + slot_weight

	local distance_weight = BotTargetSelection.melee_distance_weight(target_distance_sq)

	score = score + distance_weight

	return score
end

function _calculate_ranged_score(unit, target_unit, ranged_gestalt, target_breed, target_distance_sq, threat_units, debug_info_or_nil)
	local score = 0
	local gestalt_weight = BotTargetSelection.gestalt_weight(ranged_gestalt, target_breed)

	score = score + gestalt_weight

	local distance_weight = BotTargetSelection.ranged_distance_weight(target_distance_sq)

	score = score + distance_weight

	local los_weight = BotTargetSelection.line_of_sight_weight(unit, target_unit)

	score = score + los_weight

	return score
end

function _is_valid_target(target_unit, target_breed, aggroed_minion_target_units)
	return not target_breed.not_bot_target and (aggroed_minion_target_units[target_unit] or Breed.is_player(target_breed))
end

return target_selection_template
