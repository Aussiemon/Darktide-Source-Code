-- chunkname: @scripts/utilities/attack/stagger_calculation.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local PowerLevel = require("scripts/utilities/attack/power_level")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local rending_stagger_strength_modifier = StaggerSettings.rending_stagger_strength_modifier
local stagger_strength_output = PowerLevelSettings.stagger_strength_output
local StaggerCalculation = {}
local _calculate_stagger_strength, _stagger_reduction, _get_stagger_type, _calculate_extents, _calculate_stagger_duration_scale, _calculate_stagger_length_scale, _calculate_stagger_buffs, _calculate_stagger_reduction_buffs

StaggerCalculation.calculate = function (damage_profile, target_settings, lerp_values, power_level, charge_level, breed, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, stagger_reduction_override_or_nil, stagger_count, attack_type, armor_type, optional_stagger_strength_multiplier, stagger_strength_pool, target_stat_buffs, attacker_stat_buffs, hit_shield, is_burning, optional_mutator_stagger_overrides, attacker_unit_or_nil, target_unit_or_nil)
	local is_finesse_hit = hit_weakspot

	if target_settings.power_level_multiplier then
		local power_level_lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "targets", 1, "power_level_multiplier")
		local power_level_multiplier = DamageProfile.lerp_damage_profile_entry(target_settings.power_level_multiplier, power_level_lerp_value)

		power_level = power_level * power_level_multiplier
	end

	local stagger_strength, stagger_power_level = _calculate_stagger_strength(damage_profile, target_settings, power_level, charge_level, attack_type, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, breed, stagger_count, armor_type, lerp_values, optional_stagger_strength_multiplier, target_stat_buffs, attacker_stat_buffs, attacker_unit_or_nil, target_unit_or_nil)
	local stagger_reduction = _stagger_reduction(damage_profile, breed, is_finesse_hit, stagger_reduction_override_or_nil, attack_type, attacker_stat_buffs, hit_weakspot, is_burning)
	local armor_damage_modifier = DamageProfile.armor_damage_modifier("impact", damage_profile, target_settings, lerp_values, armor_type, is_critical_strike, dropoff_scalar)

	if stagger_reduction > stagger_strength + stagger_strength_pool then
		return nil, nil, nil, nil, stagger_strength * armor_damage_modifier
	end

	stagger_strength = stagger_strength * armor_damage_modifier

	local current_hit_stagger_strength = stagger_strength
	local sum_stagger_strength = stagger_strength + stagger_strength_pool - 0.5 * stagger_reduction
	local stagger_resistance = breed.stagger_resistance or StaggerSettings.default_stagger_resistance
	local stagger_type, stagger_threshold = _get_stagger_type(sum_stagger_strength, damage_profile, breed, stagger_resistance, hit_shield, optional_mutator_stagger_overrides, hit_weakspot)

	if damage_profile.no_stagger_breed_tag then
		local exclude_this = damage_profile.no_stagger_breed_tag
		local breed_tags = breed.tags

		if breed_tags and breed_tags[exclude_this] then
			stagger_type = nil
		end
	end

	if not stagger_type then
		return nil, nil, nil, nil, stagger_strength * armor_damage_modifier
	end

	local duration_scale, length_scale = _calculate_extents(sum_stagger_strength, stagger_threshold, stagger_resistance)

	if damage_profile.duration_scale_bonus then
		duration_scale = duration_scale + damage_profile.duration_scale_bonus
	end

	return stagger_type, duration_scale, length_scale, stagger_strength, current_hit_stagger_strength
end

function _calculate_stagger_strength(damage_profile, target_settings, power_level, charge_level, attack_type, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, breed, stagger_count, armor_type, lerp_values, optional_stagger_strength_multiplier, target_stat_buffs, attacker_stat_buffs, attacker_unit_or_nil, target_unit_or_nil)
	local stagger_table = stagger_strength_output[armor_type]
	local min, max = stagger_table.min, stagger_table.max
	local stagger_strength_range = max - min
	local charged_power_level = PowerLevel.scale_by_charge_level(power_level, charge_level, damage_profile.charge_level_scaler)
	local stagger_power_level, scaled_power_level = DamageProfile.power_distribution_from_power_level(charged_power_level, "impact", damage_profile, target_settings, is_critical_strike, dropoff_scalar, armor_type, lerp_values, attacker_stat_buffs, attack_type, attacker_unit_or_nil, target_unit_or_nil)
	local stagger_buff_modifier = _calculate_stagger_buffs(attack_type, target_stat_buffs, attacker_stat_buffs, armor_type, hit_weakspot, is_critical_strike)

	stagger_power_level = stagger_power_level * stagger_buff_modifier

	local percentage = PowerLevel.power_level_percentage(stagger_power_level)
	local stagger_strength = min + stagger_strength_range * percentage

	if breed.reverse_stagger_count then
		stagger_strength = stagger_strength / math.clamp(1 + stagger_count * 0.25, 1, 4)
	else
		stagger_strength = stagger_strength * math.clamp((1 + stagger_count) / 1.5, 1, 2.5)
	end

	if optional_stagger_strength_multiplier then
		local additional_stagger_strength = stagger_strength * optional_stagger_strength_multiplier

		stagger_strength = stagger_strength + additional_stagger_strength
	end

	return stagger_strength, scaled_power_level
end

function _stagger_reduction(damage_profile, breed, is_finesse_hit, stagger_reduction_override_or_nil, attack_type, attacker_stat_buffs, hit_weakspot, is_burning)
	if damage_profile.ignore_stagger_reduction then
		if breed.weakspot_stagger_reduction and hit_weakspot and breed.weakspot_stagger_reduction < 0 then
			return breed.weakspot_stagger_reduction
		end

		return 0
	end

	local stagger_reduction = stagger_reduction_override_or_nil or attack_type == attack_types.ranged and breed.stagger_reduction_ranged or breed.stagger_reduction

	if not stagger_reduction then
		return 0
	end

	if breed.weakspot_stagger_reduction and hit_weakspot then
		return breed.weakspot_stagger_reduction
	end

	if damage_profile.is_push or is_finesse_hit then
		stagger_reduction = stagger_reduction * 0.5
	end

	local stagger_reduction_buff_modifier = _calculate_stagger_reduction_buffs(attacker_stat_buffs, hit_weakspot, is_burning)

	stagger_reduction = stagger_reduction * stagger_reduction_buff_modifier

	return stagger_reduction
end

local stagger_categories = StaggerSettings.stagger_categories

function _get_stagger_type(stagger_strength, damage_profile, breed, stagger_resistance, hit_shield, optional_mutator_stagger_overrides, hit_weakspot)
	local stagger_category = hit_shield and damage_profile.shield_stagger_category or damage_profile.stagger_category
	local stagger_list = stagger_categories[stagger_category]
	local chosen_stagger_type
	local chosen_stagger_threshold = 0
	local default_stagger_thresholds = StaggerSettings.default_stagger_thresholds
	local threshold_overrides = optional_mutator_stagger_overrides and optional_mutator_stagger_overrides.stagger_thresholds and optional_mutator_stagger_overrides.stagger_thresholds[breed.name]
	local stagger_thresholds = threshold_overrides or breed.stagger_thresholds or default_stagger_thresholds
	local num_stagger_types = #stagger_list

	for i = 1, num_stagger_types do
		local stagger_type = stagger_list[i]
		local stagger_threshold = stagger_thresholds[stagger_type] or default_stagger_thresholds[stagger_type]

		if stagger_threshold >= 0 then
			local stagger_resistance_modifier = hit_weakspot and damage_profile.weakspot_stagger_resistance_modifier or damage_profile.stagger_resistance_modifier or 1

			stagger_threshold = stagger_threshold * (stagger_resistance * stagger_resistance_modifier)

			if chosen_stagger_threshold < stagger_threshold and stagger_threshold < stagger_strength then
				chosen_stagger_type = stagger_type

				if damage_profile.stagger_override and not hit_shield then
					chosen_stagger_type = damage_profile.stagger_override
				end

				chosen_stagger_threshold = stagger_threshold
			end
		end
	end

	return chosen_stagger_type, chosen_stagger_threshold
end

function _calculate_extents(stagger_strength, stagger_threshold, stagger_resistance)
	local excessive_force = (stagger_strength - stagger_threshold) / stagger_resistance
	local max_excessive_force = StaggerSettings.max_excessive_force
	local impact_modifier = math.min(excessive_force / max_excessive_force, 1)
	local duration_scale = _calculate_stagger_duration_scale(impact_modifier)
	local length_scale = _calculate_stagger_length_scale(impact_modifier)

	return duration_scale, length_scale
end

function _calculate_stagger_duration_scale(impact_modifier)
	local stagger_duration_scale = StaggerSettings.stagger_duration_scale
	local min = stagger_duration_scale[1]
	local max = stagger_duration_scale[2]
	local random_duration_mod = math.random() * 0.5 - 0.25
	local duration_scale = math.lerp(min, max, random_duration_mod + impact_modifier)

	return duration_scale
end

function _calculate_stagger_length_scale(impact_modifier)
	local stagger_length_scale = StaggerSettings.stagger_length_scale
	local min = stagger_length_scale[1]
	local max = stagger_length_scale[2]
	local length_scale = math.lerp(min, max, impact_modifier)

	return length_scale
end

function _calculate_stagger_buffs(attack_type, target_stat_buffs, attacker_stat_buffs, armor_type, hit_weakspot, is_critical_strike)
	local impact_modifier = attacker_stat_buffs.impact_modifier or 1
	local target_impact_modifier = target_stat_buffs.impact_modifier or 1
	local melee_impact_modifier = attack_type == attack_types.melee and attacker_stat_buffs.melee_impact_modifier or 1
	local push_impact_modifier = attack_type == attack_types.push and attacker_stat_buffs.push_impact_modifier or 1
	local ranged_impact_modifier = attack_type == attack_types.ranged and attacker_stat_buffs.ranged_impact_modifier or 1
	local explosion_impact_modifier = attack_type == attack_types.explosion and attacker_stat_buffs.explosion_impact_modifier or 1
	local shout_impact_modifier = attack_type == attack_types.shout and attacker_stat_buffs.shout_impact_modifier or 1
	local melee_weakspot_modifier = attack_type == attack_types.melee and hit_weakspot and attacker_stat_buffs.melee_weakspot_impact_modifier or 1
	local super_armor_impact_on_crit = armor_type == armor_types.super_armor and is_critical_strike and attacker_stat_buffs.super_armor_impact_on_crit or 1
	local modifier = impact_modifier + target_impact_modifier + melee_impact_modifier + ranged_impact_modifier + explosion_impact_modifier + shout_impact_modifier + melee_weakspot_modifier + super_armor_impact_on_crit + push_impact_modifier - 7

	return modifier
end

function _calculate_stagger_reduction_buffs(attacker_stat_buffs, hit_weakspot, is_burning)
	local weakspot_modifier = hit_weakspot and attacker_stat_buffs.stagger_weakspot_reduction_modifier or 1
	local burning_modifier = is_burning and attacker_stat_buffs.stagger_burning_reduction_modifier or 1
	local modifier = weakspot_modifier * burning_modifier

	return modifier
end

return StaggerCalculation
