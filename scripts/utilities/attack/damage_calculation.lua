local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local PowerLevel = require("scripts/utilities/attack/power_level")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Weakspot = require("scripts/utilities/attack/weakspot")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local WeakspotSettings = require("scripts/settings/damage/weakspot_settings")
local armor_damage_modifier_to_damage_efficiency = AttackSettings.armor_damage_modifier_to_damage_efficiency
local attack_types = AttackSettings.attack_types
local damage_efficiencies = AttackSettings.damage_efficiencies
local damage_types = DamageSettings.damage_types
local far_range = DamageSettings.ranged_far
local close_range = DamageSettings.ranged_close
local damage_output = PowerLevelSettings.damage_output
local stagger_strength_output = PowerLevelSettings.stagger_strength_output
local keywords = BuffSettings.keywords
local melee_attack_strengths = AttackSettings.melee_attack_strength
local DamageCalculation = {}
local _apply_damage_type_buffs_to_damage, _apply_armor_type_buffs_to_damage, _backstab_damage, _base_damage, _damage_multiplier_from_breed, _rending_multiplier, _base_rending_damage, _boost_curve_multiplier, _calculate_damage_buff, _finesse_boost_damage, _hit_zone_damage_multiplier, _rending_damage, _power_level_scaled_damage = nil
local EMPTY_STAT_BUFFS = {}

DamageCalculation.calculate = function (damage_profile, target_settings, lerp_values, hit_zone_name, power_level, charge_level, breed_or_nil, attacker_breed_or_nil, is_critical_strike, hit_weakspot, hit_shield, is_backstab, is_flanking, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, target_buff_extension, armor_penetrating, target_toughness_extension, armor_type, target_stagger_count, num_triggered_staggers, is_attacked_unit_suppressed, distance, target_unit, auto_completed_action)
	attacker_stat_buffs = attacker_stat_buffs or EMPTY_STAT_BUFFS
	target_stat_buffs = target_stat_buffs or EMPTY_STAT_BUFFS
	local blackboard = BLACKBOARDS[target_unit]

	if target_settings.power_level_multiplier then
		local power_level_lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "targets", 1, "power_level_multiplier")
		local power_level_multiplier = DamageProfile.lerp_damage_profile_entry(target_settings.power_level_multiplier, power_level_lerp_value)
		power_level = power_level * power_level_multiplier
	end

	local base_damage, base_buff_damage, attack_power_level = _base_damage(damage_profile, target_settings, power_level, charge_level, armor_type, is_critical_strike, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, target_buff_extension, lerp_values, num_triggered_staggers, is_attacked_unit_suppressed, breed_or_nil, attacker_breed_or_nil, distance, auto_completed_action, blackboard, target_stagger_count)
	local rending_multiplier, is_rending = _rending_multiplier(attacker_stat_buffs, target_stat_buffs, is_backstab, is_flanking, is_critical_strike)
	local damage = base_damage + base_buff_damage
	local backstab_damage = _backstab_damage(base_damage, attacker_stat_buffs, is_backstab)
	local flanking_damage = _flanking_damage(base_damage, attacker_stat_buffs, is_flanking)
	local rending_damage = 0
	local finesse_boost_damage = 0
	local base_rending_damage = _base_rending_damage(damage_profile, target_settings, power_level, charge_level, armor_type, is_critical_strike, dropoff_scalar, attack_type, attacker_stat_buffs, lerp_values, attacker_stat_buffs)
	local boost_curve = target_settings.boost_curve or PowerLevelSettings.boost_curves.default
	local is_finesse_hit = is_critical_strike or hit_weakspot

	if is_finesse_hit then
		finesse_boost_damage = _finesse_boost_damage(damage, base_rending_damage, rending_damage, damage_profile, target_settings, breed_or_nil, hit_zone_name, armor_type, is_critical_strike, hit_weakspot, boost_curve, attack_type, attacker_stat_buffs, target_stagger_count, lerp_values, target_buff_extension)
	end

	damage = damage + finesse_boost_damage + backstab_damage + flanking_damage
	local armor_damage_modifier = DamageProfile.armor_damage_modifier("attack", damage_profile, target_settings, lerp_values, armor_type, is_critical_strike, dropoff_scalar, armor_penetrating, charge_level)
	local armor_damage_reduced = damage * armor_damage_modifier
	local armor_damage_damage_diff = damage - armor_damage_reduced
	rending_damage = math.max(0, armor_damage_damage_diff * rending_multiplier)
	local rended_reduction = armor_damage_damage_diff - rending_damage
	damage = damage - rended_reduction
	local hit_zone_damage_multiplier = _hit_zone_damage_multiplier(breed_or_nil, hit_zone_name, attack_type, damage_profile.ignore_hitzone_multiplier)
	damage = damage * hit_zone_damage_multiplier
	damage = _apply_armor_type_buffs_to_damage(damage, armor_type, attacker_stat_buffs, target_toughness_extension)
	damage = _apply_armor_type_buffs_to_damage(damage, armor_type, target_stat_buffs, target_toughness_extension)
	local is_push = damage_profile.is_push or armor_type ~= "super_armor" and armor_damage_modifier == 0
	local damage_efficiency = is_push and "push" or hit_shield and damage <= 0 and damage_efficiencies.negated or armor_damage_modifier_to_damage_efficiency(armor_damage_modifier, armor_type)

	return damage, damage_efficiency, base_damage, base_buff_damage, rending_damage, finesse_boost_damage, backstab_damage, flanking_damage, armor_damage_modifier, hit_zone_damage_multiplier
end

DamageCalculation.base_ui_damage = function (damage_profile, target_settings, power_level, charge_level, dropoff_scalar, lerp_values)
	local scaled_power_level = PowerLevel.scale_by_charge_level(power_level, charge_level, damage_profile.charge_level_scaler)
	local is_critical_strike = false
	local armor_type = ArmorSettings.types.unarmored
	local dmg_table = damage_output[armor_type]
	local dmg_min = dmg_table.min
	local dmg_max = dmg_table.max
	local dmg_range = dmg_max - dmg_min
	local attack_power_level = DamageProfile.power_distribution_from_power_level(scaled_power_level, "attack", damage_profile, target_settings, is_critical_strike, dropoff_scalar, armor_type, lerp_values)
	local base_attack = dmg_min + dmg_range * PowerLevel.power_level_percentage(attack_power_level)
	local imp_table = stagger_strength_output[armor_type]
	local imp_min = imp_table.min
	local imp_max = imp_table.max
	local imp_range = imp_max - imp_min
	local impact_power_level = DamageProfile.power_distribution_from_power_level(scaled_power_level, "impact", damage_profile, target_settings, is_critical_strike, dropoff_scalar, armor_type, lerp_values)
	local base_impact = imp_min + imp_range * PowerLevel.power_level_percentage(impact_power_level)

	return base_attack, base_impact
end

DamageCalculation.ui_finesse_multiplier = function (damage_profile, target_settings, armor_type, hit_weakspot, is_critical_strike, lerp_values)
	local weakspot_type = WeakspotSettings.types.headshot
	local finesse_boost_amount = 0
	local use_finesse_boost = not damage_profile.no_finesse_boost and hit_weakspot

	if use_finesse_boost then
		local boost_table = target_settings.finesse_boost
		finesse_boost_amount = finesse_boost_amount + (boost_table and boost_table[armor_type] or PowerLevelSettings.default_finesse_boost_amount[armor_type])
		finesse_boost_amount = WeakspotSettings.finesse_boost_modifers[weakspot_type](finesse_boost_amount)
	end

	local use_crit_boost = not damage_profile.no_crit_boost and is_critical_strike

	if use_crit_boost then
		local crit_boost_amount = damage_profile.crit_boost or PowerLevelSettings.default_crit_boost_amount
		finesse_boost_amount = finesse_boost_amount + crit_boost_amount
	end

	if finesse_boost_amount > 0 then
		local boost_curve = target_settings.boost_curve or PowerLevelSettings.boost_curves.default
		finesse_boost_amount = math.min(finesse_boost_amount, 1)
		local boost_curve_multiplier_finesse = DamageProfile.boost_curve_multiplier(target_settings, "boost_curve_multiplier_finesse", lerp_values)
		local finesse_boost_multiplier = _boost_curve_multiplier(boost_curve, finesse_boost_amount) * boost_curve_multiplier_finesse

		return finesse_boost_multiplier + 1
	end

	return 1
end

function _apply_damage_type_buffs_to_damage(damage, attack_type, stat_buffs)
	if attack_type == attack_types.melee then
		local melee_damage_stat_buff = stat_buffs.melee_damage or 1
		damage = damage * melee_damage_stat_buff
	end

	return damage
end

function _apply_armor_type_buffs_to_damage(base_damage, armor_type, stat_buffs, target_toughness_extension)
	local damage = base_damage

	if stat_buffs then
		if armor_type == "unarmored" and stat_buffs.unarmored_damage then
			damage = damage * stat_buffs.unarmored_damage
		elseif armor_type == "armored" and stat_buffs.armored_damage then
			damage = damage * stat_buffs.armored_damage
		elseif armor_type == "resistant" and stat_buffs.resistant_damage then
			damage = damage * stat_buffs.resistant_damage
		elseif armor_type == "berserker" and stat_buffs.berserker_damage then
			damage = damage * stat_buffs.berserker_damage
		elseif armor_type == "super_armor" and stat_buffs.super_armor_damage then
			damage = damage * stat_buffs.super_armor_damage
		elseif armor_type == "disgustingly_resilient" and stat_buffs.disgustingly_resilient_damage then
			damage = damage * stat_buffs.disgustingly_resilient_damage
		end
	end

	return damage
end

function _boost_curve_multiplier(curve, percent)
	local num_points = #curve
	local curve_t = (num_points - 1) * percent
	local curve_index = math.floor(curve_t) + 1
	local p0 = curve[curve_index]
	local p1 = curve[math.min(curve_index + 1, num_points)]
	local local_t = curve_t - math.floor(curve_t)

	return p0 * (1 - local_t) + p1 * local_t
end

function _power_level_scaled_damage(damage_profile, target_settings, power_level, charge_level, armor_type, is_critical_strike, dropoff_scalar, lerp_values, stat_buffs_or_nil, attack_type_or_nil)
	local dmg_table = damage_output[armor_type]
	local dmg_min = dmg_table.min
	local dmg_max = dmg_table.max
	local dmg_range = dmg_max - dmg_min
	local charge_power_level = PowerLevel.scale_by_charge_level(power_level, charge_level, damage_profile.charge_level_scaler)
	local attack_power_level, scaled_power_level = DamageProfile.power_distribution_from_power_level(charge_power_level, "attack", damage_profile, target_settings, is_critical_strike, dropoff_scalar, armor_type, lerp_values, stat_buffs_or_nil, attack_type_or_nil)
	local percentage = PowerLevel.power_level_percentage(attack_power_level)

	return dmg_min + dmg_range * percentage, scaled_power_level
end

function _calculate_damage_buff(damage_profile, target_settings, power_level, charge_level, armor_type, is_critical_strike, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, target_buff_extension, lerp_values, num_triggered_staggers, is_attacked_unit_suppressed, attacked_breed_or_nil, attacker_breed_or_nil, distance, auto_completed_action, blackboard, stagger_count)
	local is_player = Breed.is_player(attacked_breed_or_nil)
	local damage_type = damage_profile.damage_type
	local damage_stat_buffs = 1
	local damage_stat_buff = (attacker_stat_buffs.damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + damage_stat_buff
	local close_damage_buff = attacker_stat_buffs.damage_near or 1
	local far_damage_buff = attacker_stat_buffs.damage_far or 1
	distance = distance or 0
	local distance_scalar = math.clamp((distance - close_range) / (far_range - close_range), 0, 1)
	local distance_damage_buff = (distance_scalar and math.lerp(close_damage_buff, far_damage_buff, math.sqrt(distance_scalar)) or 1) - 1
	damage_stat_buffs = damage_stat_buffs + distance_damage_buff
	local is_melee_attack = attack_type == attack_types.melee
	local melee_damage_stat_buff = (is_melee_attack and attacker_stat_buffs.melee_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + melee_damage_stat_buff
	local is_heavy_melee_attack = is_melee_attack and damage_profile.melee_attack_strength == melee_attack_strengths.heavy
	local melee_heavy_damage_stat_buff = (is_heavy_melee_attack and attacker_stat_buffs.melee_heavy_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + melee_heavy_damage_stat_buff
	local is_fully_charged_heavy_attack = auto_completed_action and is_heavy_melee_attack
	local fully_charged_heavy_attack_damage_stat_buff = (is_fully_charged_heavy_attack and attacker_stat_buffs.melee_fully_charged_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + fully_charged_heavy_attack_damage_stat_buff
	local is_ranged_attack = attack_type == attack_types.ranged
	local ranged_damage_stat_buff = (is_ranged_attack and attacker_stat_buffs.ranged_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + ranged_damage_stat_buff
	local fully_charged = charge_level == 1
	local fully_charged_stat_buff = (fully_charged and attacker_stat_buffs.fully_charged_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + fully_charged_stat_buff
	local stagger_count_stat_buff = ((attacker_stat_buffs.stagger_count_damage or 1) - 1) * stagger_count
	damage_stat_buffs = damage_stat_buffs + stagger_count_stat_buff
	local is_target_elite = attacked_breed_or_nil and attacked_breed_or_nil.tags and attacked_breed_or_nil.tags.elite
	local vs_elites_damage_stat_buff = (is_target_elite and attacker_stat_buffs.damage_vs_elites or 1) - 1
	damage_stat_buffs = damage_stat_buffs + vs_elites_damage_stat_buff
	local is_target_special = attacked_breed_or_nil and attacked_breed_or_nil.tags and attacked_breed_or_nil.tags.special
	local damage_vs_specials_stat_buff = (is_target_special and attacker_stat_buffs.damage_vs_specials or 1) - 1
	damage_stat_buffs = damage_stat_buffs + damage_vs_specials_stat_buff
	local is_target_stunned = target_buff_extension and target_buff_extension:has_keyword(keywords.electrocuted)
	local damage_vs_stunned_stat_buff = (is_target_stunned and attacker_stat_buffs.damage_vs_stunned or 1) - 1
	damage_stat_buffs = damage_stat_buffs + damage_vs_stunned_stat_buff
	local is_horde = attacked_breed_or_nil and attacked_breed_or_nil.tags and attacked_breed_or_nil.tags.horde
	local vs_horde_buff = (is_horde and attacker_stat_buffs.damage_vs_horde or 1) - 1
	damage_stat_buffs = damage_stat_buffs + vs_horde_buff
	local target_is_ogryn = attacked_breed_or_nil and attacked_breed_or_nil.tags and attacked_breed_or_nil.tags.ogryn
	local damage_vs_ogryn_stat_buff = (target_is_ogryn and attacker_stat_buffs.damage_vs_ogryn or 1) - 1
	damage_stat_buffs = damage_stat_buffs + damage_vs_ogryn_stat_buff
	local target_is_ogryn_or_monster = attacked_breed_or_nil and attacked_breed_or_nil.tags and (attacked_breed_or_nil.tags.ogryn or attacked_breed_or_nil.tags.monster)
	local damage_vs_ogryn_and_monsters_stat_buff = (target_is_ogryn_or_monster and attacker_stat_buffs.damage_vs_ogryn_and_monsters or 1) - 1
	damage_stat_buffs = damage_stat_buffs + damage_vs_ogryn_and_monsters_stat_buff
	local target_unaggroed = nil

	if blackboard and not is_player then
		local perception_component = blackboard.perception
		local aggro_state = perception_component.aggro_state
		local is_unaggroed = aggro_state ~= "aggroed"
		target_unaggroed = is_unaggroed
	end

	local damage_vs_unaggroed_stat_buff = (target_unaggroed and attacker_stat_buffs.damage_vs_unaggroed or 1) - 1
	damage_stat_buffs = damage_stat_buffs + damage_vs_unaggroed_stat_buff
	local suppresed_damage_stat_buff = (is_attacked_unit_suppressed and attacker_stat_buffs.damage_vs_suppressed or 1) - 1
	damage_stat_buffs = damage_stat_buffs + suppresed_damage_stat_buff
	local target_is_staggered = num_triggered_staggers > 0
	local damage_vs_staggered_stat_buff = (target_is_staggered and attacker_stat_buffs.damage_vs_staggered or 1) - 1
	local target_damage_vs_staggered_stat_buff = (target_is_staggered and target_stat_buffs.damage_vs_staggered or 1) - 1
	damage_stat_buffs = damage_stat_buffs + damage_vs_staggered_stat_buff + target_damage_vs_staggered_stat_buff
	local is_force_weapon = damage_profile.force_weapon_damage
	local force_weapon_damage_stat_buff = (is_force_weapon and attacker_stat_buffs.force_weapon_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + force_weapon_damage_stat_buff
	local force_staff_single_target = damage_type == damage_types.force_staff_single_target
	local force_staff_single_target_damage_stat_buff = (force_staff_single_target and attacker_stat_buffs.force_staff_single_target_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + force_staff_single_target_damage_stat_buff
	local is_shout_attack = attack_type == attack_types.shout
	local shout_damage_stat_buff = (is_shout_attack and attacker_stat_buffs.shout_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + shout_damage_stat_buff
	local is_smite_attack = damage_type == damage_types.smite
	local smite_damage_stat_buff = (is_smite_attack and attacker_stat_buffs.smite_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + smite_damage_stat_buff
	local is_warp_attack = damage_type == damage_types.warp
	local warp_damage_stat_buff = (is_warp_attack and attacker_stat_buffs.warp_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + warp_damage_stat_buff
	local finesse_ability_multiplier = damage_profile.finesse_ability_damage_multiplier
	local finesse_ability_multiplier_stat_buff = (finesse_ability_multiplier and attacker_stat_buffs.finesse_ability_multiplier or 1) - 1
	damage_stat_buffs = damage_stat_buffs + finesse_ability_multiplier_stat_buff
	local is_krak_attack = damage_type == damage_types.krak
	local krak_damage_stat_buff = (is_krak_attack and attacker_stat_buffs.krak_damage or 1) - 1
	damage_stat_buffs = damage_stat_buffs + krak_damage_stat_buff

	return damage_stat_buffs
end

function _base_damage(damage_profile, target_settings, power_level, charge_level, armor_type, is_critical_strike, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, target_buff_extension, lerp_values, num_triggered_staggers, is_attacked_unit_suppressed, attacked_breed_or_nil, attacker_breed_or_nil, distance, auto_completed_action, blackboard, stagger_count)
	local base_damage, attack_power_level = _power_level_scaled_damage(damage_profile, target_settings, power_level, charge_level, armor_type, is_critical_strike, dropoff_scalar, lerp_values, attacker_stat_buffs, attack_type)
	local damage_type = damage_profile.damage_type
	local damage_stat_buffs = _calculate_damage_buff(damage_profile, target_settings, power_level, charge_level, armor_type, is_critical_strike, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, target_buff_extension, lerp_values, num_triggered_staggers, is_attacked_unit_suppressed, attacked_breed_or_nil, attacker_breed_or_nil, distance, auto_completed_action, blackboard, stagger_count)
	local damage_taken_multiplier = target_stat_buffs and target_stat_buffs.damage_taken_multiplier or 1
	local damage_taken_modifier = target_stat_buffs and target_stat_buffs.damage_taken_modifier or 1
	local is_ranged_attack = attack_type == attack_types.ranged
	local ranged_damage_taken_multiplier = is_ranged_attack and target_stat_buffs and target_stat_buffs.ranged_damage_taken_multiplier or 1
	local attacker_is_ogryn = attacker_breed_or_nil and attacker_breed_or_nil.tags and attacker_breed_or_nil.tags.ogryn
	local ogryn_damage_taken_multiplier = attacker_is_ogryn and target_stat_buffs and target_stat_buffs.ogryn_damage_taken_multiplier or 1
	local is_warp_attack = damage_type == damage_types.warp
	local warp_damage_taken_multiplier = is_warp_attack and target_stat_buffs and target_stat_buffs.warp_damage_taken_multiplier or 1
	local non_warp_damage_taken_modifier = not is_warp_attack and target_stat_buffs and target_stat_buffs.non_warp_damage_taken_multiplier or 1
	local per_breed_damage_taken_multiplier = _damage_multiplier_from_breed(target_stat_buffs, attacker_breed_or_nil)
	local damage_taken_stat_buffs = damage_taken_multiplier * damage_taken_modifier * ranged_damage_taken_multiplier * ogryn_damage_taken_multiplier * warp_damage_taken_multiplier * non_warp_damage_taken_modifier * per_breed_damage_taken_multiplier
	local buff_damage_modifier = damage_stat_buffs * damage_taken_stat_buffs - 1
	local buff_damage = base_damage * buff_damage_modifier

	return base_damage, buff_damage, attack_power_level
end

function _damage_multiplier_from_breed(target_stat_buffs, attacker_breed_or_nil)
	if not attacker_breed_or_nil then
		return 1
	end

	local breed_name = attacker_breed_or_nil.name
	local stat_buff_name = "damage_taken_by_" .. breed_name .. "_multiplier"
	local multiplier = target_stat_buffs[stat_buff_name] or 1

	return multiplier
end

function _rending_multiplier(attacker_stat_buffs, target_stat_buffs, is_backstab, is_flanking, is_critical_strike)
	local attacker_multiplier = attacker_stat_buffs.rending_multiplier or 1
	local target_multiplier = target_stat_buffs.rending_multiplier or 1
	local attacker_backstab_multiplier = is_backstab and attacker_stat_buffs.backstab_rending_multiplier or 1
	local target_backstab_multiplier = is_backstab and target_stat_buffs.backstab_rending_multiplier or 1
	local attacker_flanking_multiplier = is_flanking and attacker_stat_buffs.flanking_rending_multiplier or 1
	local target_flanking_multiplier = is_flanking and target_stat_buffs.flanking_rending_multiplier or 1
	local attacker_crit_multiplier = is_critical_strike and attacker_stat_buffs.critical_strike_rending_multiplier or 1
	local target_crit_multiplier = is_critical_strike and target_stat_buffs.critical_strike_rending_multiplier or 1
	local rending_multiplier = attacker_multiplier + target_multiplier + attacker_backstab_multiplier + target_backstab_multiplier + attacker_crit_multiplier + target_crit_multiplier + attacker_flanking_multiplier + target_flanking_multiplier - 8

	return rending_multiplier, rending_multiplier > 0
end

function _base_rending_damage(damage_profile, target_settings, power_level, charge_level, armor_type, is_critical_strike, dropoff_scalar, attack_type, stat_buffs, lerp_values, attacker_stat_buffs)
	local rending_armor_conversion = PowerLevelSettings.rending_armor_conversion[armor_type]
	local damage = _power_level_scaled_damage(damage_profile, target_settings, power_level, charge_level, rending_armor_conversion, is_critical_strike, dropoff_scalar, lerp_values, attacker_stat_buffs, attack_type)
	damage = _apply_damage_type_buffs_to_damage(damage, attack_type, stat_buffs)

	return damage
end

function _rending_damage(rending_multiplier, base_damage, base_rending_damage, damage_profile, target_settings, armor_type, boost_curve, lerp_values)
	local rending_min_damage = 1
	local power_damage = nil
	local rending_boost_amount = PowerLevelSettings.rending_boost_amount[armor_type]
	local use_boost_curve = boost_curve and rending_boost_amount > 0

	if use_boost_curve then
		local boost_curve_multiplier = DamageProfile.boost_curve_multiplier(target_settings, "boost_curve_multiplier", lerp_values)
		local boost_multiplier = _boost_curve_multiplier(boost_curve, rending_boost_amount) * boost_curve_multiplier
		power_damage = math.max(math.max(base_rending_damage, base_damage), rending_min_damage) * boost_multiplier * rending_multiplier
	else
		power_damage = base_rending_damage
	end

	return power_damage
end

function _finesse_boost_damage(base_damage, base_rending_damage, rending_damage, damage_profile, target_settings, breed_or_nil, hit_zone_name, armor_type, is_critical_strike, hit_weakspot, boost_curve, attack_type, stat_buffs, target_stagger_count, lerp_values, target_buff_extension)
	local finesse_boost_amount = 0
	local use_finesse_boost = not damage_profile.no_finesse_boost and hit_weakspot

	if use_finesse_boost then
		if base_damage > 0 then
			local boost_table = target_settings.finesse_boost
			finesse_boost_amount = finesse_boost_amount + (boost_table and boost_table[armor_type] or PowerLevelSettings.default_finesse_boost_amount[armor_type])
		else
			local boost_table = target_settings.finesse_boost_no_base_damage
			finesse_boost_amount = finesse_boost_amount + (boost_table and boost_table[armor_type] or PowerLevelSettings.default_finesse_boost_no_base_damage_amount[armor_type])
		end

		finesse_boost_amount = Weakspot.finesse_boost_modifer(breed_or_nil, hit_zone_name, finesse_boost_amount)
	end

	local use_crit_boost = not damage_profile.no_crit_boost and is_critical_strike

	if use_crit_boost then
		local crit_boost_amount = damage_profile.crit_boost or PowerLevelSettings.default_crit_boost_amount
		finesse_boost_amount = finesse_boost_amount + crit_boost_amount
	end

	local finesse_damage = nil
	local finesse_min_damage = base_rending_damage * PowerLevelSettings.finesse_min_damage_multiplier
	local use_boost_curve = boost_curve and finesse_boost_amount > 0

	if use_boost_curve then
		finesse_boost_amount = math.min(finesse_boost_amount, 1)
		local boost_curve_multiplier_finesse = DamageProfile.boost_curve_multiplier(target_settings, "boost_curve_multiplier_finesse", lerp_values)
		local finesse_boost_multiplier = _boost_curve_multiplier(boost_curve, finesse_boost_amount) * boost_curve_multiplier_finesse
		finesse_damage = math.max(math.max(rending_damage, base_damage), finesse_min_damage) * finesse_boost_multiplier
	else
		finesse_damage = finesse_min_damage
	end

	local is_ranged = attack_type == attack_types.ranged
	local is_melee = attack_type == attack_types.melee
	local weakspot_damage_stat_buff = 1

	if hit_weakspot then
		local weakspot_damage = stat_buffs.weakspot_damage or 1
		local ranged_weakspot_damage = is_ranged and stat_buffs.ranged_weakspot_damage or 1
		local melee_weakspot_damage = is_melee and stat_buffs.melee_weakspot_damage or 1
		weakspot_damage_stat_buff = weakspot_damage_stat_buff + weakspot_damage - 1 + ranged_weakspot_damage - 1 + melee_weakspot_damage - 1
		local ranged_weakspot_damage_vs_staggered = 1

		if is_ranged and target_stagger_count > 0 then
			ranged_weakspot_damage_vs_staggered = stat_buffs.ranged_weakspot_damage_vs_staggered or ranged_weakspot_damage_vs_staggered
		end

		weakspot_damage_stat_buff = weakspot_damage_stat_buff + ranged_weakspot_damage_vs_staggered - 1
		local melee_weakspot_damage_vs_staggered = 1

		if is_melee and target_stagger_count > 0 then
			melee_weakspot_damage_vs_staggered = stat_buffs.melee_weakspot_damage_vs_staggered or melee_weakspot_damage_vs_staggered
		end

		weakspot_damage_stat_buff = weakspot_damage_stat_buff + melee_weakspot_damage_vs_staggered - 1
		local melee_weakspot_damage_vs_bleeding = 1
		local target_is_bleeding = target_buff_extension and target_buff_extension:has_keyword(keywords.bleeding)

		if is_melee and target_is_bleeding then
			melee_weakspot_damage_vs_bleeding = stat_buffs.melee_weakspot_damage_vs_bleeding or melee_weakspot_damage_vs_bleeding
		end

		weakspot_damage_stat_buff = weakspot_damage_stat_buff + melee_weakspot_damage_vs_bleeding - 1
	end

	local critical_damage_stat_buff = 1

	if is_critical_strike then
		local critical_damage = stat_buffs.critical_strike_damage or 1
		local ranged_critical_damage = is_ranged and stat_buffs.ranged_critical_strike_damage or 1
		local melee_critical_damage = is_melee and stat_buffs.melee_critical_strike_damage or 1
		critical_damage_stat_buff = critical_damage + ranged_critical_damage + melee_critical_damage - 2
	end

	local crit_weakspot_damage_stat_buff = 1

	if is_critical_strike and hit_weakspot then
		crit_weakspot_damage_stat_buff = stat_buffs.critical_strike_weakspot_damage or 1
	end

	local finesse_modifier_bonus = stat_buffs.finesse_modifier_bonus or 1
	local finesse_buff_damage_multiplier = weakspot_damage_stat_buff + critical_damage_stat_buff + crit_weakspot_damage_stat_buff + finesse_modifier_bonus - 3
	finesse_damage = finesse_damage * finesse_buff_damage_multiplier

	return finesse_damage
end

function _hit_zone_damage_multiplier(breed_or_nil, hit_zone_name, attack_type, ignore_hitzone_multiplier)
	if ignore_hitzone_multiplier or not breed_or_nil then
		return 1
	end

	local hitzone_damage_multiplier = breed_or_nil.hitzone_damage_multiplier

	if not hitzone_damage_multiplier then
		return 1
	end

	local default_hitzone_damage_multiplier = breed_or_nil.hitzone_damage_multiplier.default
	local attack_type_damage_multipliers = hitzone_damage_multiplier[attack_type] or default_hitzone_damage_multiplier

	if not attack_type_damage_multipliers then
		return 1
	end

	local hit_zone_damage_multiplier = attack_type_damage_multipliers[hit_zone_name] or default_hitzone_damage_multiplier and default_hitzone_damage_multiplier[hit_zone_name]

	if not hit_zone_damage_multiplier then
		return 1
	end

	return hit_zone_damage_multiplier
end

function _backstab_damage(damage, attack_type, stat_buffs, is_backstab)
	local backstab_damage_buff = is_backstab and stat_buffs.backstab_damage or 1
	local backstab_damage = damage * (backstab_damage_buff - 1)

	return backstab_damage
end

function _flanking_damage(damage, stat_buffs, is_flanking)
	local flanking_damage_buff = is_flanking and stat_buffs.flanking_damage or 1
	local flanking_damage = damage * (flanking_damage_buff - 1)

	return flanking_damage
end

return DamageCalculation
