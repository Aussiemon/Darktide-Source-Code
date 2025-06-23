-- chunkname: @scripts/utilities/trait_value_parser.lua

local BuffTemplates = require("scripts/settings/buff/buff_templates")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_traits/weapon_trait_templates")
local TraitValueParser = {}
local _num_decimals, _number_value_formatter, _value_from_path, _lerp_stepped_value, _try_format_values, _try_localization_info
local FORMATTING_FUNCTIONS = {
	percentage = function (value, config)
		local value_manipulation = config.value_manipulation

		if value_manipulation then
			value = value_manipulation(value)
		else
			value = value * 100
		end

		local formatter = _number_value_formatter(value, config)
		local value_string = string.format(formatter, value)

		return string.format("%s%%", value_string)
	end,
	number = function (value, config)
		local value_manipulation = config.value_manipulation

		if value_manipulation then
			value = value_manipulation(value)
		end

		local formatter = _number_value_formatter(value, config)

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
	end
}
local FIND_VALUE_FUNCTIONS = {
	buff_template = function (trait_definition, config, trait_level)
		local buff_template_name = config.buff_template_name
		local buff_template = BuffTemplates[buff_template_name]
		local value = _value_from_path(buff_template, config.path)

		return value
	end,
	trait_override = function (trait_definition, config, trait_level)
		local buff_template_name = config.buff_template_name
		local value = _value_from_path(trait_definition.buffs[buff_template_name][trait_level], config.path)

		return value
	end,
	rarity_value = function (trait_definition, config, trait_level)
		return config.trait_value[trait_level]
	end,
	default = function (trait_definition, config, trait_level)
		return config.value
	end
}

TraitValueParser.trait_description = function (item, trait_level, lerp_value)
	local description = item.description
	local trait_name = item.trait
	local trait_definition = WeaponTraitTemplates[trait_name]
	local format_values = _try_format_values(trait_definition, trait_level, lerp_value) or _try_localization_info(item, trait_level, lerp_value)
	local trait_description = Localize(description, true, format_values)

	return trait_description
end

local FORMAT_VALUES_TEMP = {}

function _try_format_values(trait_definition, trait_level, lerp_value)
	local format_values = trait_definition and trait_definition.format_values
	local actual_format_values

	if format_values then
		actual_format_values = FORMAT_VALUES_TEMP

		table.clear(actual_format_values)

		for key, config in pairs(format_values) do
			if type(config) == "table" then
				local value
				local find_value_config = config.find_value

				if find_value_config then
					local find_value_function = FIND_VALUE_FUNCTIONS[find_value_config.find_value_type or "default"]

					value = find_value_function(trait_definition, find_value_config, trait_level)
				else
					value = config.value
				end

				local format_type = config.format_type
				local format_function = FORMATTING_FUNCTIONS[format_type] or FORMATTING_FUNCTIONS.default
				local string_value = format_function(value, config)

				if config.prefix then
					string_value = string.format("%s%s", config.prefix, string_value)
				end

				if config.suffix then
					string_value = string.format("%s%s", string_value, config.suffix)
				end

				actual_format_values[key] = string_value
			else
				actual_format_values[key] = config
			end
		end

		return actual_format_values
	end

	return nil
end

function _try_localization_info(item, trait_level, lerp_value)
	local actual_format_values = FORMAT_VALUES_TEMP

	table.clear(actual_format_values)

	local trait = item.trait
	local buff_name = trait
	local buff_template = BuffTemplates[buff_name]

	if not buff_template then
		return nil
	end

	local localization_info = buff_template.localization_info
	local class_name = buff_template.class_name

	if localization_info and class_name == "proc_buff" then
		local proc_buff_name = localization_info.proc_buff_name

		if proc_buff_name then
			buff_template = BuffTemplates[proc_buff_name]
			localization_info = buff_template.localization_info
		end
	end

	if localization_info then
		local is_meta_buff = buff_template.meta_buff
		local buff_template_stat_buffs = buff_template.stat_buffs or buff_template.meta_stat_buffs or buff_template.lerped_stat_buffs or buff_template.conditional_stat_buffs

		if buff_template_stat_buffs then
			for stat_buff_name, value in pairs(buff_template_stat_buffs) do
				if buff_template.lerped_stat_buffs then
					local min = value.min
					local max = value.max
					local lerp_value_func = value.lerp_value_func or math.lerp

					value = lerp_value_func(min, max, lerp_value)
				elseif is_meta_buff and type(value) == "table" then
					value = tostring(buff_template.lerp_function(value, lerp_value))
				elseif class_name == "stepped_range_buff" then
					value = tostring(_lerp_stepped_value(value, lerp_value))
				end

				local show_as = localization_info[stat_buff_name]

				if show_as and show_as == "percentage" then
					value = tostring(math.round(value * 100)) .. "%"
				end

				actual_format_values[stat_buff_name] = string.format("+%s", value)
			end
		end

		actual_format_values.duration = buff_template.duration

		return actual_format_values
	end

	return nil
end

function _number_value_formatter(value, config)
	local num_decimals = config.num_decimals

	num_decimals = num_decimals or _num_decimals(value)

	local formatter

	if num_decimals > 0 then
		formatter = string.format("%%.%df", num_decimals)
	else
		formatter = "%d"
	end

	return formatter
end

function _num_decimals(value)
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

function _value_from_path(base_table, path)
	local value_table = base_table
	local num_path = #path

	for ii = 1, num_path - 1 do
		value_table = value_table[path[ii]]
	end

	local key = path[num_path]
	local value = value_table[key]

	return value, key
end

function _lerp_stepped_value(range, lerp_value)
	local min = 1
	local max = #range
	local lerped_value = math.lerp(min, max, lerp_value)
	local index = math.round(lerped_value)
	local value = range[index]

	return value
end

return TraitValueParser
