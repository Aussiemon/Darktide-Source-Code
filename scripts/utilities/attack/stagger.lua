local Armor = require("scripts/utilities/attack/armor")
local AttackingUnitResolver = require("scripts/utilities/attack/attacking_unit_resolver")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local BreedActions = require("scripts/settings/breed/breed_actions")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local Herding = require("scripts/utilities/herding")
local MinionState = require("scripts/utilities/minion_state")
local StaggerCalculation = require("scripts/utilities/attack/stagger_calculation")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Stagger = {}
local _apply_action_controlled_stagger, _get_breed, _get_action_data_overrides, _apply_stagger, _get_stagger_duration_modifier, _get_stagger_count, _should_trigger_stagger, _get_system_overrides = nil
local EMPTY_STAT_BUFFS = {}
local DEFAULT_ACCUMULATIVE_MULTIPLIER = 0.5

Stagger.apply_stagger = function (unit, damage_profile, damage_profile_lerp_values, target_settings, attacking_unit, power_level, charge_level, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, attack_direction, attack_type, attack_result, herding_template_or_nil, hit_shield)
	local breed = _get_breed(unit)
	local blackboard = BLACKBOARDS[unit]
	local stagger_component = Blackboard.write_component(blackboard, "stagger")

	if stagger_component.controlled_stagger then
		return false
	end

	local stagger_direction = attack_direction

	if herding_template_or_nil then
		stagger_direction = Herding.modify_stagger_direction(herding_template_or_nil, attack_direction, attacking_unit, unit)
	end

	local stagger_strength_multiplier = stagger_component.stagger_strength_multiplier
	local stagger_count = _get_stagger_count(unit, breed)
	local armor_type = Armor.armor_type(unit, breed)
	local t = Managers.time:time("gameplay")
	local decay_time = breed.stagger_pool_decay_time or StaggerSettings.stagger_pool_decay_time
	local decay_delay = breed.stagger_pool_decay_delay or StaggerSettings.stagger_pool_decay_delay
	local stagger_strength_pool = stagger_component.stagger_strength_pool
	local stagger_pool_last_modified = stagger_component.stagger_pool_last_modified
	local time_since_last = t - stagger_pool_last_modified
	time_since_last = math.max(0, time_since_last - decay_delay)
	local stagger_pool_decay_multiplier = (decay_time - math.min(decay_time, time_since_last)) / decay_time
	stagger_strength_pool = stagger_strength_pool * stagger_pool_decay_multiplier
	stagger_component.stagger_pool_last_modified = t
	local target_buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local target_stat_buffs = target_buff_extension and target_buff_extension:stat_buffs() or EMPTY_STAT_BUFFS
	local attacking_unit_owner_unit = AttackingUnitResolver.resolve(attacking_unit)
	local attacker_buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system") or attacking_unit_owner_unit and ScriptUnit.has_extension(attacking_unit_owner_unit, "buff_system")
	local attacker_stat_buffs = attacker_buff_extension and attacker_buff_extension:stat_buffs() or EMPTY_STAT_BUFFS
	local is_burning = MinionState.is_burning(unit)
	local stagger_reduction_override_or_nil, action_controlled_stagger = _get_action_data_overrides(unit, blackboard, breed, damage_profile, attacking_unit)
	local mutator_stagger_overrides = Managers.state.mutator:mutator("mutator_higher_stagger_thresholds")
	mutator_stagger_overrides = mutator_stagger_overrides and mutator_stagger_overrides:stagger_overrides()
	local stagger_type, duration_scale, length_scale, stagger_strength, current_hit_stagger_strength = StaggerCalculation.calculate(damage_profile, target_settings, damage_profile_lerp_values, power_level, charge_level, breed, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, stagger_reduction_override_or_nil, stagger_count, attack_type, armor_type, stagger_strength_multiplier, stagger_strength_pool, target_stat_buffs, attacker_stat_buffs, hit_shield, is_burning, mutator_stagger_overrides)
	local accumulative_multiplier = damage_profile.accumulative_stagger_strength_multiplier or DEFAULT_ACCUMULATIVE_MULTIPLIER

	if type(accumulative_multiplier) == "table" then
		local lerp_value = DamageProfile.lerp_value_from_path(damage_profile_lerp_values, "accumulative_stagger_strength_multiplier")
		accumulative_multiplier = DamageProfile.lerp_damage_profile_entry(accumulative_multiplier, lerp_value)
	end

	if breed.ignore_stagger_accumulation or breed.only_accumulate_stagger_on_weakspot and not hit_weakspot then
		accumulative_multiplier = 0
	elseif breed.accumulative_stagger_multiplier then
		accumulative_multiplier = accumulative_multiplier * breed.accumulative_stagger_multiplier
	end

	stagger_type, duration_scale, length_scale = _get_system_overrides(unit, damage_profile, stagger_type, duration_scale, length_scale, stagger_strength, attack_result, attack_type)

	if stagger_type then
		stagger_component.stagger_strength_pool = 0

		if not damage_profile.sticky_attack and action_controlled_stagger then
			_apply_action_controlled_stagger(unit, stagger_type, stagger_direction)
		else
			_apply_stagger(unit, attacking_unit, breed, stagger_type, stagger_direction, duration_scale, length_scale, damage_profile, damage_profile_lerp_values, attacker_stat_buffs)
		end
	else
		stagger_component.stagger_strength_pool = stagger_strength_pool + current_hit_stagger_strength * accumulative_multiplier
	end

	local applied_stagger = not not stagger_type

	return applied_stagger, stagger_type
end

Stagger.can_stagger = function (unit)
	local unit_data_ext = ScriptUnit.has_extension(unit, "unit_data_system")

	if not unit_data_ext then
		return false
	end

	local breed = unit_data_ext:breed()

	if not Breed.is_minion(breed) then
		return false
	end

	local owned_by_death_manager = unit_data_ext:is_owned_by_death_manager()

	if owned_by_death_manager then
		return false
	end

	local behavior_ext = ScriptUnit.extension(unit, "behavior_system")
	local _, action_data_or_nil = behavior_ext:running_action()

	if action_data_or_nil and action_data_or_nil.stagger_immune then
		return false
	end

	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

	if toughness_extension and toughness_extension:is_stagger_immune() then
		return false
	end

	return true
end

Stagger.force_stagger = function (unit, stagger_type, attack_direction, duration, length_scale, immune_time)
	local t = Managers.time:time("gameplay")
	local blackboard = BLACKBOARDS[unit]
	local stagger_component = Blackboard.write_component(blackboard, "stagger")
	stagger_component.immune_time = t + (immune_time or 0)
	stagger_component.type = stagger_type

	stagger_component.direction:store(attack_direction)

	stagger_component.duration = duration
	stagger_component.length = length_scale or 1
	stagger_component.num_triggered_staggers = stagger_component.num_triggered_staggers + 1
end

function _get_breed(unit)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")

	return unit_data_ext:breed()
end

function _get_system_overrides(unit, damage_profile, stagger_type, duration_scale, length_scale, stagger_strength, attack_result, attack_type)
	local shield_extension = ScriptUnit.has_extension(unit, "shield_system")

	if shield_extension then
		stagger_type, duration_scale, length_scale = shield_extension:apply_stagger(unit, damage_profile, stagger_strength, attack_result, stagger_type, duration_scale, length_scale, attack_type)
	end

	return stagger_type, duration_scale, length_scale
end

local RUNNING_STAGGER_DEFAULT_MIN_DISTANCE = 5
local CONTROLLED_STAGGER_IGNORED_STAGGER_TYPES = {
	explosion = true,
	blinding = true,
	electrocuted = true,
	sticky = true
}

function _get_action_data_overrides(unit, blackboard, breed, damage_profile, attacking_unit)
	local stagger_reduction, action_controlled_stagger = nil
	local stagger_type = damage_profile.stagger_category
	local behavior_ext = ScriptUnit.has_extension(unit, "behavior_system")

	if behavior_ext then
		local _, action_data_or_nil = behavior_ext:running_action()

		if action_data_or_nil then
			local action_data = action_data_or_nil
			local stagger_type_reduction = action_data.stagger_type_reduction and action_data.stagger_type_reduction[stagger_type]
			local stagger_base_reduction = action_data.stagger_reduction
			stagger_reduction = stagger_type_reduction or stagger_base_reduction

			if action_data.controlled_stagger then
				local stagger_component = blackboard.stagger
				local controlled_stagger_finished = stagger_component.controlled_stagger_finished

				if controlled_stagger_finished then
					return
				end

				local locomotion_extension = ScriptUnit.has_extension(unit, "locomotion_system")

				if not locomotion_extension then
					return
				end

				if CONTROLLED_STAGGER_IGNORED_STAGGER_TYPES[stagger_type] then
					return
				end

				local min_distance = action_data.controlled_stagger_min_distance or RUNNING_STAGGER_DEFAULT_MIN_DISTANCE
				local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
				local distance_to_destination = navigation_extension:distance_to_destination()

				if distance_to_destination < min_distance then
					return stagger_reduction, false
				end

				local within_speed_threshold = true
				local min_speed = action_data.controlled_stagger_min_speed

				if min_speed then
					local current_velocity = locomotion_extension:current_velocity()
					local move_speed = Vector3.length(current_velocity)
					within_speed_threshold = min_speed <= move_speed
				end

				local within_distance_threshold = true
				local max_distance = action_data.controlled_stagger_max_distance

				if max_distance and HEALTH_ALIVE[attacking_unit] then
					local distance = Vector3.distance(POSITION_LOOKUP[unit], POSITION_LOOKUP[attacking_unit])
					within_distance_threshold = max_distance <= distance
				end

				local not_in_ignored_combat_range = true
				local ignored_combat_range = action_data.controlled_stagger_ignored_combat_range

				if ignored_combat_range then
					local behavior_component = blackboard.behavior
					local combat_range = behavior_component.combat_range
					not_in_ignored_combat_range = combat_range ~= ignored_combat_range
				end

				action_controlled_stagger = within_distance_threshold and within_speed_threshold and not_in_ignored_combat_range
			end
		end
	end

	return stagger_reduction, action_controlled_stagger
end

function _get_stagger_count(unit, breed)
	local stagger_count = 0

	if Breed.is_minion(breed) then
		local blackboard = BLACKBOARDS[unit]
		local stagger_component = blackboard.stagger
		stagger_count = stagger_component.count
	end

	return stagger_count
end

function _should_trigger_stagger(t, stagger_component, new_stagger_type)
	local should_trigger_stagger = true
	local immune_time = stagger_component.immune_time

	if immune_time then
		local stagger_impact_comparison = StaggerSettings.stagger_impact_comparison
		local current_stagger_type = stagger_component.type
		local current_stagger_impact = stagger_impact_comparison[current_stagger_type]
		local new_stagger_impact = stagger_impact_comparison[new_stagger_type]

		if current_stagger_impact then
			if new_stagger_impact <= current_stagger_impact then
				should_trigger_stagger = immune_time < t
			end
		else
			should_trigger_stagger = immune_time < t
		end
	end

	return should_trigger_stagger
end

function _get_stagger_duration_modifier(lerp_values, damage_profile)
	local modifier = damage_profile.stagger_duration_modifier or 0

	if type(modifier) == "table" then
		local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "stagger_duration_modifier")
		modifier = DamageProfile.lerp_damage_profile_entry(modifier, lerp_value)
	end

	return modifier
end

function _apply_stagger(unit, attacker_unit, breed, stagger_type, attack_direction, duration_scale, length_scale, damage_profile, lerp_values, attacker_stat_buffs)
	local blackboard = BLACKBOARDS[unit]
	local stagger_component = Blackboard.write_component(blackboard, "stagger")
	local t = Managers.time:time("gameplay")
	local should_trigger_stagger = _should_trigger_stagger(t, stagger_component, stagger_type)

	if should_trigger_stagger then
		local stagger_durations = breed.stagger_durations
		local duration = stagger_durations[stagger_type]
		local stagger_duration_modifier = _get_stagger_duration_modifier(lerp_values, damage_profile)
		local stagger_duration_multiplier = attacker_stat_buffs.stagger_duration_multiplier

		if damage_profile.opt_in_stagger_duration_multiplier then
			stagger_duration_multiplier = attacker_stat_buffs.opt_in_stagger_duration_multiplier
		end

		stagger_duration_multiplier = stagger_duration_multiplier or 1
		duration = duration * stagger_duration_multiplier + stagger_duration_modifier
		local stagger_immune_times = breed.stagger_immune_times
		local immune_time = stagger_immune_times[stagger_type]

		if damage_profile.no_immune_time then
			immune_time = nil
		end

		stagger_component.immune_time = t + (immune_time or 0)
		stagger_component.type = stagger_type

		stagger_component.direction:store(attack_direction)

		stagger_component.duration = duration * duration_scale
		stagger_component.length = length_scale
		stagger_component.num_triggered_staggers = stagger_component.num_triggered_staggers + 1
		stagger_component.attacker_unit = attacker_unit
	end

	stagger_component.count = stagger_component.count + 1
end

function _apply_action_controlled_stagger(unit, stagger_type, attack_direction)
	local blackboard = BLACKBOARDS[unit]
	local stagger_component = Blackboard.write_component(blackboard, "stagger")
	stagger_component.controlled_stagger = true

	stagger_component.direction:store(attack_direction)
end

return Stagger
