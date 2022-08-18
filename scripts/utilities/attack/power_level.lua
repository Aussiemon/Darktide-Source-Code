local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PowerLevel = {
	power_level = function ()
		return PowerLevelSettings.default_power_level
	end,
	power_level_percentage = function (power_level)
		local min_power_level = PowerLevelSettings.min_power_level
		local max_power_level = PowerLevelSettings.max_power_level

		return (power_level - min_power_level) / (max_power_level - min_power_level)
	end,
	scale_power_level_to_power_type_curve = function (power_level, power_type)
		local min_power_level = PowerLevelSettings.min_power_level
		local max_power_level = PowerLevelSettings.max_power_level

		fassert(min_power_level <= power_level, "PowerLevel.scale_power_level_to_power_type_curve: Power level %i is less than minimum %i power level", power_level, min_power_level)
		fassert(power_level <= max_power_level, "PowerLevel.scale_power_level_to_power_type_curve: Power level %i is more than maximum %i power level", power_level, max_power_level)

		local min_power_level_cap = PowerLevelSettings.min_power_level_cap
		local scaled_power_level = nil

		if min_power_level_cap <= power_level then
			local curve_constants = PowerLevelSettings.power_level_curve_constants
			local starting_power_level_bonus = curve_constants.starting_bonus
			local starting_bonus_range = curve_constants.starting_bonus_range
			local native_diff_ratio = curve_constants.native_diff_ratio
			local power_level_diff_ratio = PowerLevelSettings.power_level_diff_ratio
			local power_type_diff_ratio = (power_level_diff_ratio[power_type] - 1) / (native_diff_ratio - 1)
			local scaled_power_level_section = nil

			if power_level >= min_power_level_cap + starting_bonus_range then
				scaled_power_level_section = (power_level - min_power_level_cap) * power_type_diff_ratio
			else
				local starting_bonus = starting_power_level_bonus * (1 - (power_level - min_power_level_cap) / starting_bonus_range)
				scaled_power_level_section = ((power_level + starting_bonus) - min_power_level_cap) * power_type_diff_ratio
			end

			scaled_power_level = min_power_level_cap + scaled_power_level_section
		else
			scaled_power_level = power_level
		end

		return scaled_power_level
	end,
	scale_by_charge_level = function (power_level, charge_level)
		local scaled_power_level = (charge_level and charge_level * power_level) or power_level

		return scaled_power_level
	end
}

return PowerLevel
