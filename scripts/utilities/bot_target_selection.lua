-- chunkname: @scripts/utilities/bot_target_selection.lua

local BotGestaltTargetSelectionWeights = require("scripts/settings/bot/bot_gestalt_target_selection_weights")
local BotSettings = require("scripts/settings/bot/bot_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local breed_types = BreedSettings.types
local breed_type_player = breed_types.player
local BotTargetSelection = {}

BotTargetSelection.gestalt_weight = function (gestalt, target_breed)
	local weights = BotGestaltTargetSelectionWeights[gestalt]

	return weights[target_breed.name]
end

local DEFAULT_SLOT_WEIGHT = 1
local ALLY_SLOT_MULTIPLIER = 0.8

BotTargetSelection.slot_weight = function (unit, target_unit, target_distance_sq, target_breed, target_ally)
	if not target_breed.slot_template then
		return 0
	end

	local target_user_slot_extension = ScriptUnit.extension(target_unit, "slot_system")
	local slot = target_user_slot_extension.slot

	if not slot then
		return 0
	end

	local slot_target_unit = slot.target_unit
	local my_slot = slot_target_unit == unit
	local ally_slot = slot_target_unit == target_ally

	if not my_slot and not ally_slot then
		return 0
	end

	local ally_multiplier = ally_slot and ALLY_SLOT_MULTIPLIER or 1

	return DEFAULT_SLOT_WEIGHT * ally_multiplier
end

local DEFAULT_THREAT_WEIGHT_MULTIPLIER = 1

BotTargetSelection.threat_weight = function (target_unit, threat_units)
	local threat_weight = 0

	if threat_units[target_unit] then
		local threat = threat_units[target_unit]
		local threat_multiplier = DEFAULT_THREAT_WEIGHT_MULTIPLIER

		threat_weight = threat * threat_multiplier
	end

	return threat_weight
end

local DEFAULT_OPPORTUNITY_WEIGHT = 1
local OPPORTUNITY_TARGET_REACTION_TIMES = BotSettings.opportunity_target_reaction_times

BotTargetSelection.opportunity_weight = function (unit, target_unit, target_breed, t)
	local tags = target_breed.tags
	local is_opportunity_target = tags and tags.special or target_breed.breed_type == breed_type_player

	if not is_opportunity_target then
		return 0, false
	end

	local legacy_v2_proximity_extension = ScriptUnit.has_extension(target_unit, "legacy_v2_proximity_system")

	if legacy_v2_proximity_extension then
		if not legacy_v2_proximity_extension.has_been_seen then
			return 0, false
		end

		local react_at = legacy_v2_proximity_extension.bot_reaction_times[unit]

		if not react_at then
			legacy_v2_proximity_extension.bot_reaction_times[unit] = t + BotTargetSelection.reaction_time(true, OPPORTUNITY_TARGET_REACTION_TIMES, nil, nil)

			return 0, false
		elseif t < react_at then
			return 0, false
		end
	end

	local opportunity_weight = DEFAULT_OPPORTUNITY_WEIGHT

	return opportunity_weight, true
end

local DEFAULT_PRIORITY_WEIGHT = 4
local TIME_UNTIL_MAX_PRIORITY_WEIGHT = 2

BotTargetSelection.priority_weight = function (target_unit, bot_group)
	local is_priority_target = bot_group.priority_targets[target_unit] ~= nil

	if not is_priority_target then
		return 0, false
	end

	local priority_duration = bot_group.priority_targets_duration[target_unit]
	local i = math.ilerp(0, TIME_UNTIL_MAX_PRIORITY_WEIGHT, priority_duration)
	local priority_weight = DEFAULT_PRIORITY_WEIGHT

	return priority_weight * i, true
end

local DEFAULT_MONSTER_WEIGHT = 2
local MONSTER_MIN_REACTION_TIME, MONSTER_MAX_REACTION_TIME = 0.2, 0.65

BotTargetSelection.monster_weight = function (unit, target_unit, target_breed, t)
	local tags = target_breed.tags

	if not tags.monster then
		return 0, false
	end

	local perception_extension = ScriptUnit.extension(unit, "perception_system")
	local _, num_enemies_in_proximity = perception_extension:enemies_in_proximity()

	if num_enemies_in_proximity and num_enemies_in_proximity > 0 then
		return 0, false
	end

	local legacy_v2_proximity_extension = ScriptUnit.has_extension(target_unit, "legacy_v2_proximity_system")

	if legacy_v2_proximity_extension then
		if not legacy_v2_proximity_extension.has_been_seen then
			return 0, false
		end

		local react_at = legacy_v2_proximity_extension.bot_reaction_times[unit]

		if not react_at then
			legacy_v2_proximity_extension.bot_reaction_times[unit] = t + BotTargetSelection.reaction_time(false, nil, MONSTER_MIN_REACTION_TIME, MONSTER_MAX_REACTION_TIME)

			return 0, false
		elseif t < react_at then
			return 0, false
		end
	end

	local monster_weight = DEFAULT_MONSTER_WEIGHT

	return monster_weight, false
end

local DEFAULT_CURRENT_TARGET_WEIGHT = 0.2

BotTargetSelection.current_target_weight = function (target_unit, current_target_enemy)
	if target_unit ~= current_target_enemy then
		return 0
	end

	local current_target_weight = DEFAULT_CURRENT_TARGET_WEIGHT

	return current_target_weight
end

local DEFAULT_MELEE_DISTANCE_WEIGHT = 3
local MELEE_DISTANCE_NO_WEIGHT, MELEE_DISTANCE_MAX_WEIGHT = 8, 3
local MELEE_DISTANCE_NO_WEIGHT_SQ, MELEE_DISTANCE_MAX_WEIGHT_SQ = MELEE_DISTANCE_NO_WEIGHT^2, MELEE_DISTANCE_MAX_WEIGHT^2

BotTargetSelection.melee_distance_weight = function (target_distance_sq)
	local i = math.ilerp(MELEE_DISTANCE_NO_WEIGHT_SQ, MELEE_DISTANCE_MAX_WEIGHT_SQ, target_distance_sq)
	local melee_distance_weight = DEFAULT_MELEE_DISTANCE_WEIGHT

	return melee_distance_weight * i
end

local DEFAULT_RANGED_DISTANCE_WEIGHT = 1
local RANGED_DISTANCE_NO_WEIGHT, RANGED_DISTANCE_MAX_WEIGHT = 4, 6
local RANGED_DISTANCE_NO_WEIGHT_SQ, RANGED_DISTANCE_MAX_WEIGHT_SQ = RANGED_DISTANCE_NO_WEIGHT^2, RANGED_DISTANCE_MAX_WEIGHT^2

BotTargetSelection.ranged_distance_weight = function (target_distance_sq)
	local i = math.ilerp(RANGED_DISTANCE_NO_WEIGHT_SQ, RANGED_DISTANCE_MAX_WEIGHT_SQ, target_distance_sq)
	local ranged_distance_weight = DEFAULT_RANGED_DISTANCE_WEIGHT

	return ranged_distance_weight * i
end

local DEFAULT_LINE_OF_SIGHT_WEIGHT = 1

BotTargetSelection.line_of_sight_weight = function (unit, target_unit)
	local perception_extension = ScriptUnit.extension(target_unit, "perception_system")

	if not perception_extension:has_line_of_sight(unit) then
		return 0
	end

	local line_of_sight_weight = DEFAULT_LINE_OF_SIGHT_WEIGHT

	return line_of_sight_weight
end

BotTargetSelection.reaction_time = function (use_difficulty_reaction_times, difficulty_reaction_times, default_min, default_max)
	local min_reaction_time, max_reaction_time

	if use_difficulty_reaction_times then
		local difficulty = "normal"
		local reaction_times = difficulty_reaction_times[difficulty]

		min_reaction_time, max_reaction_time = reaction_times.min, reaction_times.max
	else
		min_reaction_time, max_reaction_time = default_min, default_max
	end

	return math.random(min_reaction_time, max_reaction_time)
end

BotTargetSelection.allowed_ranged_target = function (bot_blackboard, target_unit)
	local behavior_component = bot_blackboard.behavior
	local ranged_gestalt = behavior_component.ranged_gestalt
	local weights = BotGestaltTargetSelectionWeights[ranged_gestalt]
	local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local breed_name = unit_data_extension:breed_name()
	local weight = weights[breed_name]

	if weight == -math.huge then
		return false
	else
		return true
	end
end

return BotTargetSelection
