﻿-- chunkname: @scripts/utilities/attack/power_level.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local attack_types = AttackSettings.attack_types
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local MIN_POWER_LEVEL_CAP = PowerLevelSettings.min_power_level_cap
local MIN_POWER_LEVEL = PowerLevelSettings.min_power_level
local MAX_POWER_LEVEL = PowerLevelSettings.max_power_level
local MIN_MAX_POWER_LEVEL_DIFF = MAX_POWER_LEVEL - MIN_POWER_LEVEL
local POWER_LEVEL_CURVE_CONSTANTS = PowerLevelSettings.power_level_curve_constants
local POWER_LEVEL_DIFF_RATIO = PowerLevelSettings.power_level_diff_ratio
local PowerLevel = {}

PowerLevel.default_power_level = function ()
	return DEFAULT_POWER_LEVEL
end

PowerLevel.power_level_percentage = function (power_level)
	return (power_level - MIN_POWER_LEVEL) / MIN_MAX_POWER_LEVEL_DIFF
end

PowerLevel.power_level_buff_modifier = function (stat_buffs_or_nil, attack_type_or_nil, weakspot_or_nil)
	if not stat_buffs_or_nil then
		return 1
	end

	local power_level_modifier_stat_buff = stat_buffs_or_nil.power_level_modifier or 1
	local melee_power_level_modifier_stat_buff = attack_type_or_nil == attack_types.melee and stat_buffs_or_nil.melee_power_level_modifier or 1
	local weakspot_power_level_modifier = weakspot_or_nil and stat_buffs_or_nil.weakspot_power_level_modifier or 1
	local ranged_power_level_modifier_stat_buff = attack_type_or_nil == attack_types.ranged and stat_buffs_or_nil.ranged_power_level_modifier or 1
	local power_level_modifier = power_level_modifier_stat_buff + melee_power_level_modifier_stat_buff + ranged_power_level_modifier_stat_buff + weakspot_power_level_modifier - 3

	return power_level_modifier
end

PowerLevel.scale_power_level_to_power_type_curve = function (power_level, power_type, stat_buffs_or_nil, attack_type_or_nil, weakspot_or_nil)
	local scaled_power_level

	if power_level >= MIN_POWER_LEVEL_CAP then
		local curve_constants = POWER_LEVEL_CURVE_CONSTANTS
		local starting_power_level_bonus = curve_constants.starting_bonus
		local starting_bonus_range = curve_constants.starting_bonus_range
		local native_diff_ratio = curve_constants.native_diff_ratio
		local power_type_diff_ratio = (POWER_LEVEL_DIFF_RATIO[power_type] - 1) / (native_diff_ratio - 1)
		local scaled_power_level_section

		if power_level >= MIN_POWER_LEVEL_CAP + starting_bonus_range then
			scaled_power_level_section = (power_level - MIN_POWER_LEVEL_CAP) * power_type_diff_ratio
		else
			local starting_bonus = starting_power_level_bonus * (1 - (power_level - MIN_POWER_LEVEL_CAP) / starting_bonus_range)

			scaled_power_level_section = (power_level + starting_bonus - MIN_POWER_LEVEL_CAP) * power_type_diff_ratio
		end

		scaled_power_level = MIN_POWER_LEVEL_CAP + scaled_power_level_section
	else
		scaled_power_level = power_level
	end

	local power_level_buff_modifier = PowerLevel.power_level_buff_modifier(stat_buffs_or_nil, attack_type_or_nil, weakspot_or_nil)

	scaled_power_level = scaled_power_level * power_level_buff_modifier

	return scaled_power_level
end

local function _scale_power_level_with_charge_curve(charge_level, scaler_curve)
	local curve_t = charge_level
	local start_mod = scaler_curve.start_modifier
	local p1, p2 = start_mod, 1
	local segment_progress = 0

	for i = 1, #scaler_curve do
		local segment = scaler_curve[i]
		local segment_t = segment.t

		if curve_t <= segment_t then
			p2 = segment.modifier
			segment_progress = segment_t == 0 and 1 or curve_t / segment_t

			break
		else
			local modifier = segment.modifier

			p1 = modifier
			p2 = modifier
		end
	end

	local mod = math.lerp(p1, p2, segment_progress)

	return mod
end

PowerLevel.scale_by_charge_level = function (power_level, charge_level, charge_level_scaler)
	if not charge_level then
		return power_level
	end

	if charge_level_scaler then
		local power_level_scalar = _scale_power_level_with_charge_curve(charge_level, charge_level_scaler)

		return power_level * power_level_scalar
	end

	return charge_level * power_level
end

return PowerLevel
