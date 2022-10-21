local BuffSettings = require("scripts/settings/buff/buff_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PowerLevel = require("scripts/utilities/attack/power_level")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local buff_keywords = BuffSettings.keywords
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local DEFALT_FALLBACK_LERP_VALUE = WeaponTweakTemplateSettings.DEFALT_FALLBACK_LERP_VALUE
local DEFAULT_CRIT_MOD = DamageProfileSettings.default_crit_mod
local MIN_CRIT_MOD = DamageProfileSettings.min_crit_mod
local _distribute_power_level_to_power_type, _max_hit_mass = nil
local armor_penetrating_conversion = {
	armored = "unarmored",
	super_armor = "armored"
}
local DamageProfile = {
	target_settings = function (damage_profile, target_index)
		local targets = damage_profile.targets
		local target_settings = targets[target_index] or targets.default_target

		return target_settings
	end,
	power_distribution_from_power_level = function (power_level, power_type, damage_profile, target_settings, is_critical_strike, dropoff_scalar, armor_type, damage_profile_lerp_values)
		local scaled_power_level = PowerLevel.scale_power_level_to_power_type_curve(power_level, power_type)
		local power_type_power = _distribute_power_level_to_power_type(power_type, scaled_power_level, damage_profile, target_settings, dropoff_scalar, damage_profile_lerp_values)

		return power_type_power
	end,
	max_hit_mass = function (damage_profile, power_level, charge_level, lerp_values, is_critical_strike, unit)
		local scaled_power_level = PowerLevel.scale_by_charge_level(power_level, charge_level)
		local scaled_cleave_power_level = PowerLevel.scale_power_level_to_power_type_curve(scaled_power_level, "cleave")
		local cleave_output = PowerLevelSettings.cleave_output
		local cleave_min = cleave_output.min
		local cleave_max = cleave_output.max
		local cleave_range = cleave_max - cleave_min
		local cleave_distribution = damage_profile.cleave_distribution or PowerLevelSettings.default_cleave_distribution
		local max_hit_mass_attack = _max_hit_mass(cleave_min, cleave_range, scaled_cleave_power_level, cleave_distribution, "attack", lerp_values)
		local max_hit_mass_impact = _max_hit_mass(cleave_min, cleave_range, scaled_cleave_power_level, cleave_distribution, "impact", lerp_values)
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local stat_buffs = buff_extension:stat_buffs()
			local max_hit_mass_attack_modifier = stat_buffs.max_hit_mass_attack_modifier or 1
			max_hit_mass_attack = max_hit_mass_attack * max_hit_mass_attack_modifier
			local max_hit_mass_impact_modifier = stat_buffs.max_hit_mass_impact_modifier or 1
			max_hit_mass_impact = max_hit_mass_impact * max_hit_mass_impact_modifier
			local crit_piercing_keyword = buff_extension:has_keyword(buff_keywords.critical_hit_infinite_hit_mass)

			if is_critical_strike and crit_piercing_keyword then
				max_hit_mass_attack = math.huge
			end
		end

		return max_hit_mass_attack, max_hit_mass_impact
	end
}

function _max_hit_mass(cleave_min, cleave_range, scaled_cleave_power_level, cleave_distribution, power_type, lerp_values)
	local distribution = cleave_distribution[power_type]

	if type(distribution) == "table" then
		local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "cleave_distribution", "attack")
		distribution = DamageProfile.lerp_damage_profile_entry(distribution, lerp_value)
	end

	local attack_cleave_power_level = scaled_cleave_power_level * distribution
	local attack_percentage = PowerLevel.power_level_percentage(attack_cleave_power_level)
	local max_hit_mass = cleave_min + cleave_range * attack_percentage

	return max_hit_mass
end

DamageProfile.armor_damage_modifier = function (power_type, damage_profile, target_settings, damage_profile_lerp_values, armor_type, is_critical_strike, dropoff_scalar, armor_penetrating)
	local target_settings_lerp_values = damage_profile_lerp_values.current_target_settings_lerp_values

	if armor_penetrating then
		local new_armor_type = armor_penetrating_conversion[armor_type]
		armor_type = new_armor_type or armor_type
	end

	local from_target_settings_near, from_target_settings_far, adm_near, adm_far = nil
	local target_adm_ranged = target_settings.armor_damage_modifier_ranged
	local adm_ranged = damage_profile.armor_damage_modifier_ranged
	local target_settings_adm_near = target_adm_ranged and target_adm_ranged.near and target_adm_ranged.near[power_type] and target_adm_ranged.near[power_type][armor_type] or nil
	local target_settings_adm_far = target_adm_ranged and target_adm_ranged.far and target_adm_ranged.far[power_type] and target_adm_ranged.far[power_type][armor_type] or nil

	if target_settings_adm_near then
		adm_near = target_settings_adm_near
		from_target_settings_near = true
	else
		adm_near = adm_ranged and adm_ranged.near[power_type][armor_type]
		from_target_settings_near = false
	end

	if target_settings_adm_far then
		adm_far = target_settings_adm_far
		from_target_settings_far = true
	else
		adm_far = adm_ranged and adm_ranged.far[power_type][armor_type]
		from_target_settings_far = false
	end

	local should_calculate_adm_ranged = adm_near and adm_far
	local lerp_value, armor_damage_modifier = nil

	if should_calculate_adm_ranged then
		local near_lerp_values = from_target_settings_near and target_settings_lerp_values or damage_profile_lerp_values
		local far_lerp_values = from_target_settings_far and target_settings_lerp_values or damage_profile_lerp_values
		local near = adm_near
		local far = adm_far
		local near_is_lerpable = type(near) == "table"

		if near_is_lerpable then
			lerp_value = DamageProfile.lerp_value_from_path(near_lerp_values, "armor_damage_modifier_ranged", "near", power_type, armor_type)
			near = DamageProfile.lerp_damage_profile_entry(near, lerp_value)
		end

		local far_is_lerpable = type(far) == "table"

		if far_is_lerpable then
			lerp_value = DamageProfile.lerp_value_from_path(far_lerp_values, "armor_damage_modifier_ranged", "far", power_type, armor_type)
			far = DamageProfile.lerp_damage_profile_entry(far, lerp_value)
		end

		armor_damage_modifier = math.lerp(near, far, dropoff_scalar or 0)
	else
		local adm = target_settings.armor_damage_modifier
		local target_settings_adm = adm and adm[power_type] and adm[power_type][armor_type] or nil
		local lerp_values = nil

		if target_settings_adm then
			lerp_values = target_settings_lerp_values
			armor_damage_modifier = target_settings_adm
		else
			local damage_profile_adm = damage_profile.armor_damage_modifier
			local damage_profile_settings_adm = damage_profile_adm and damage_profile_adm[power_type] and damage_profile_adm[power_type][armor_type] or nil
			lerp_values = damage_profile_lerp_values
			armor_damage_modifier = damage_profile_settings_adm or PowerLevelSettings.default_armor_damage_modifier[power_type][armor_type]
		end

		lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "armor_damage_modifier", power_type, armor_type)
	end

	local lerpable_entry = type(armor_damage_modifier) == "table"

	if lerpable_entry then
		armor_damage_modifier = DamageProfile.lerp_damage_profile_entry(armor_damage_modifier, lerp_value)
	end

	if is_critical_strike then
		local armor_crit_mod = DEFAULT_CRIT_MOD

		if damage_profile.crit_mod and damage_profile.crit_mod[power_type] and damage_profile.crit_mod[power_type][armor_type] then
			armor_crit_mod = damage_profile.crit_mod[power_type][armor_type]

			if type(armor_crit_mod) == "table" then
				lerp_value = DamageProfile.lerp_value_from_path(damage_profile_lerp_values, "crit_mod", power_type, armor_type)
				armor_crit_mod = DamageProfile.lerp_damage_profile_entry(armor_crit_mod, lerp_value)
			end
		end

		local critical_armor_damage_modifiers = armor_damage_modifier + armor_crit_mod
		armor_damage_modifier = math.max(critical_armor_damage_modifiers, MIN_CRIT_MOD)
	end

	return armor_damage_modifier
end

DamageProfile.dropoff_scalar = function (hit_distance, damage_profile, lerp_values)
	local dropoff_scalar = false
	local ranges = damage_profile.ranges

	if ranges then
		local min = ranges.min
		local max = ranges.max
		local lerpable_min = type(min) == "table"

		if lerpable_min then
			local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "ranges", "min")
			min = DamageProfile.lerp_damage_profile_entry(min, lerp_value)
		end

		local lerpable_max = type(max) == "table"

		if lerpable_max then
			local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "ranges", "max")
			max = DamageProfile.lerp_damage_profile_entry(max, lerp_value)
		end

		if max <= hit_distance then
			dropoff_scalar = 1
		elseif hit_distance <= min then
			dropoff_scalar = 0
		else
			dropoff_scalar = (hit_distance - min) / (max - min)
		end
	end

	return dropoff_scalar
end

DamageProfile.boost_curve_multiplier = function (target_settings, boost_multiplier_name, damage_profile_lerp_values)
	local multiplier = target_settings[boost_multiplier_name] or PowerLevelSettings.default_boost_curve_multiplier
	local lerpable_multiplier = type(multiplier) == "table"

	if lerpable_multiplier then
		local target_settings_lerp_values = damage_profile_lerp_values.current_target_settings_lerp_values
		local lerp_value = DamageProfile.lerp_value_from_path(target_settings_lerp_values, boost_multiplier_name)
		multiplier = DamageProfile.lerp_damage_profile_entry(multiplier, lerp_value)
	end

	return multiplier
end

DamageProfile.suppression_value = function (damage_profile, damage_profile_lerp_values, num_suppressions)
	local suppression_value_or_nil = damage_profile.suppression_value
	local lerpable_value = type(suppression_value_or_nil) == "table"

	if lerpable_value then
		local lerp_value = DamageProfile.lerp_value_from_path(damage_profile_lerp_values, "suppression_value")
		suppression_value_or_nil = DamageProfile.lerp_damage_profile_entry(suppression_value_or_nil, lerp_value)
	end

	num_suppressions = num_suppressions or 1
	suppression_value_or_nil = suppression_value_or_nil and suppression_value_or_nil * num_suppressions

	return suppression_value_or_nil
end

DamageProfile.suppression_attack_delay = function (damage_profile, damage_profile_lerp_values)
	local suppression_attack_delay_or_nil = damage_profile.suppression_attack_delay
	local lerpable_value = type(suppression_attack_delay_or_nil) == "table"

	if lerpable_value then
		local lerp_value = DamageProfile.lerp_value_from_path(damage_profile_lerp_values, "suppression_attack_delay")
		suppression_attack_delay_or_nil = DamageProfile.lerp_damage_profile_entry(suppression_attack_delay_or_nil, lerp_value)
	end

	return suppression_attack_delay_or_nil
end

local DAMAGE_PROFILE_NO_LERP_VALUES = {}
local TARGET_SETTINGS_NO_LERP_VALUES = {}

DamageProfile.lerp_values = function (damage_profile, attacking_unit_or_nil, target_index_or_nil)
	if not attacking_unit_or_nil then
		return DAMAGE_PROFILE_NO_LERP_VALUES
	end

	local weapon_extension = ScriptUnit.has_extension(attacking_unit_or_nil, "weapon_system")

	if not weapon_extension then
		return DAMAGE_PROFILE_NO_LERP_VALUES
	end

	local lerp_values = weapon_extension:damage_profile_lerp_values(damage_profile.name)
	local targets = target_index_or_nil and lerp_values.targets
	local target_settings_lerp_values = targets and (targets[target_index_or_nil] or targets.default_target) or TARGET_SETTINGS_NO_LERP_VALUES
	lerp_values.current_target_settings_lerp_values = target_settings_lerp_values

	return lerp_values
end

local EMPTY_PATH = {
	[DEFAULT_LERP_VALUE] = 0
}

DamageProfile.lerp_value_from_path = function (lerp_values, ...)
	local default_lerp_value_or_nil = lerp_values[DEFAULT_LERP_VALUE]
	local local_lerp_values = lerp_values
	local depth = select("#", ...)

	for i = 1, depth - 1 do
		local id = select(i, ...)
		local_lerp_values = local_lerp_values[id] or EMPTY_PATH
	end

	local last_id = select(depth, ...)
	local lerp_value = local_lerp_values[last_id] or default_lerp_value_or_nil or DEFALT_FALLBACK_LERP_VALUE

	return lerp_value
end

DamageProfile.progress_lerp_values_path = function (lerp_values, ...)
	local default_lerp_value_or_nil = lerp_values[DEFAULT_LERP_VALUE]
	EMPTY_PATH[DEFAULT_LERP_VALUE] = default_lerp_value_or_nil
	local local_lerp_values = lerp_values
	local depth = select("#", ...)

	for i = 1, depth do
		local id = select(i, ...)
		local_lerp_values = local_lerp_values[id] or EMPTY_PATH
	end

	return local_lerp_values
end

DamageProfile.lerp_damage_profile_entry = function (entry, lerp_value)
	local min = entry[1]
	local max = entry[2]
	local t = lerp_value

	return math.lerp(min, max, t)
end

function _distribute_power_level_to_power_type(power_type, power_level, damage_profile, target_settings, dropoff_scalar, damage_profile_lerp_values)
	local from_target_settings, power_distribution_ranged = nil
	local target_settings_power_distribution_ranged = target_settings.power_distribution_ranged

	if target_settings_power_distribution_ranged then
		power_distribution_ranged = target_settings.power_distribution_ranged
		from_target_settings = true
	else
		power_distribution_ranged = damage_profile.power_distribution_ranged
		from_target_settings = false
	end

	local target_settings_lerp_values = damage_profile_lerp_values.current_target_settings_lerp_values
	local power_multiplier = nil

	if dropoff_scalar and power_distribution_ranged then
		local pdr_table = power_distribution_ranged[power_type]
		local power_near = pdr_table.near
		local power_far = pdr_table.far
		local lerp_values = from_target_settings and target_settings_lerp_values or damage_profile_lerp_values

		if type(power_near) == "table" then
			local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "power_distribution_ranged", power_type, "near")
			power_near = DamageProfile.lerp_damage_profile_entry(power_near, lerp_value)
		end

		if type(power_far) == "table" then
			local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "power_distribution_ranged", power_type, "far")
			power_far = DamageProfile.lerp_damage_profile_entry(power_far, lerp_value)
		end

		power_multiplier = math.lerp(power_near, power_far, math.sqrt(dropoff_scalar))
	else
		local power_distribution, lerp_values = nil
		local target_settings_power_distribution = target_settings.power_distribution

		if target_settings_power_distribution then
			power_distribution = target_settings_power_distribution
			lerp_values = target_settings_lerp_values
		else
			power_distribution = damage_profile.power_distribution or PowerLevelSettings.default_power_distribution
			lerp_values = damage_profile_lerp_values
		end

		power_multiplier = power_distribution[power_type]

		if type(power_multiplier) == "table" then
			local lerp_value = DamageProfile.lerp_value_from_path(lerp_values, "power_distribution", power_type)
			power_multiplier = DamageProfile.lerp_damage_profile_entry(power_multiplier, lerp_value)
		end
	end

	if not dropoff_scalar and power_multiplier > 0 and power_multiplier < 2 then
		power_multiplier = power_multiplier * (power_type == "attack" and 250 or 50)
	end

	return power_level * power_multiplier
end

return DamageProfile
