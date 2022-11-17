local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local MIN_POWER_LEVEL_CAP = PowerLevelSettings.min_power_level_cap
local MIN_POWER_LEVEL = PowerLevelSettings.min_power_level
local MAX_POWER_LEVEL = PowerLevelSettings.max_power_level
local MIN_MAX_POWER_LEVEL_DIFF = MAX_POWER_LEVEL - MIN_POWER_LEVEL
local POWER_LEVEL_CURVE_CONSTANTS = PowerLevelSettings.power_level_curve_constants
local POWER_LEVEL_DIFF_RATIO = PowerLevelSettings.power_level_diff_ratio
local PowerLevel = {
	power_level = function ()
		return DEFAULT_POWER_LEVEL
	end,
	power_level_percentage = function (power_level)
		return (power_level - MIN_POWER_LEVEL) / MIN_MAX_POWER_LEVEL_DIFF
	end,
	scale_power_level_to_power_type_curve = function (power_level, power_type)
		local scaled_power_level = nil

		if MIN_POWER_LEVEL_CAP <= power_level then
			local curve_constants = POWER_LEVEL_CURVE_CONSTANTS
			local starting_power_level_bonus = curve_constants.starting_bonus
			local starting_bonus_range = curve_constants.starting_bonus_range
			local native_diff_ratio = curve_constants.native_diff_ratio
			local power_type_diff_ratio = (POWER_LEVEL_DIFF_RATIO[power_type] - 1) / (native_diff_ratio - 1)
			local scaled_power_level_section = nil

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

		return scaled_power_level
	end,
	scale_by_charge_level = function (power_level, charge_level, charge_level_scaler)
		if not charge_level then
			return power_level
		end

		if charge_level_scaler then
			local power_level_scaler = math.lerp(charge_level_scaler.min or 0, charge_level_scaler.max or 1, charge_level)

			return power_level * power_level_scaler
		end

		return charge_level * power_level
	end
}

return PowerLevel
