-- chunkname: @scripts/ui/constant_elements/elements/mission_buffs/utilities/mission_buffs_parser.lua

local Text = require("scripts/utilities/ui/text")
local MissionBuffsParser = {}

local function _num_decimals(value)
	local only_decimals = value - math.floor(value)
	local has_digit_10 = false
	local has_digit_100 = false
	local digit_10_v = only_decimals * 10

	if digit_10_v > 1 then
		has_digit_10 = 1
	end

	only_decimals = digit_10_v - math.floor(digit_10_v)

	local digit_100_v = only_decimals * 10

	if digit_100_v > 1 then
		has_digit_100 = true
	end

	local num_decimals

	num_decimals = has_digit_100 and 2 or has_digit_10 and 1 or 0

	return num_decimals
end

local FORMATTING_FUNCTIONS = {
	percentage = function (value, config)
		local value_manipulation = config.value_manipulation

		if value_manipulation then
			value = value_manipulation(value)
		else
			value = value * 100
		end

		local num_decimals = config.num_decimals

		num_decimals = num_decimals or _num_decimals(value)

		local formatter

		if num_decimals > 0 then
			formatter = string.format("%%.%df", num_decimals)
		else
			formatter = "%d"
		end

		local value_string = string.format(formatter, value)

		return string.format("%s%%", value_string)
	end,
	number = function (value, config)
		local value_manipulation = config.value_manipulation

		if value_manipulation then
			value = value_manipulation(value)
		end

		local num_decimals = config.num_decimals

		num_decimals = num_decimals or _num_decimals(value)

		local formatter

		if num_decimals > 0 then
			formatter = string.format("%%.%df", num_decimals)
		else
			formatter = "%d"
		end

		return string.format(formatter, value)
	end,
	loc_string = function (value, config)
		return Managers.localization:localize(value, true)
	end,
	string = function (value, config)
		return value
	end,
	default = function (value, config)
		return tostring(value)
	end,
}
local FORMAT_VALUES_TEMP = {}

MissionBuffsParser.get_formated_buff_description = function (buff_data, value_color)
	local format_values = buff_data.buff_stats
	local actual_format_values

	if format_values then
		actual_format_values = FORMAT_VALUES_TEMP

		table.clear(actual_format_values)

		for key, config in pairs(format_values) do
			if type(config) == "table" then
				local value = config.value
				local format_type = config.format_type
				local format_function = FORMATTING_FUNCTIONS[format_type] or FORMATTING_FUNCTIONS.default
				local string_value = format_function(value, config)

				if config.prefix then
					string_value = config.prefix .. string_value
				end

				if config.suffix then
					string_value = string_value .. config.suffix
				end

				if value_color then
					actual_format_values[key] = Text.apply_color_to_text(tostring(string_value), value_color)
				else
					actual_format_values[key] = string.format("%s", string_value)
				end
			else
				actual_format_values[key] = config
			end
		end
	end

	return Managers.localization:localize(buff_data.description, true, actual_format_values)
end

return MissionBuffsParser
