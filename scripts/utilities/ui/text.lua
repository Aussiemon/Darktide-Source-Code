-- chunkname: @scripts/utilities/ui/text.lua

local InputUtils = require("scripts/managers/input/input_utils")
local TextUtilities = {}

TextUtilities.apply_color_to_text = function (text, color)
	return "{#color(" .. color[2] .. "," .. color[3] .. "," .. color[4] .. ")}" .. text .. "{#reset()}"
end

TextUtilities.localize_to_upper = function (localization_key, optional_localization_context)
	local localized_text = Localize(localization_key, optional_localization_context ~= nil, optional_localization_context)

	return Utf8.upper(localized_text)
end

TextUtilities.localize_to_title_case = function (localization_key, optional_localization_context)
	local localized_text = Localize(localization_key, optional_localization_context ~= nil, optional_localization_context)
	local title_case_text

	for word in string.gmatch(localized_text, "[^%s]+") do
		local first_letter = Utf8.sub_string(word, 1, 1)
		local rest_of_word = Utf8.sub_string(word, 2)

		if title_case_text then
			title_case_text = string.format("%s %s%s", title_case_text, Utf8.upper(first_letter), Utf8.lower(rest_of_word))
		else
			title_case_text = string.format("%s%s", Utf8.upper(first_letter), Utf8.lower(rest_of_word))
		end
	end

	return title_case_text
end

TextUtilities.localize_with_button_hint = function (action, localization_key, optional_localization_context, optional_service_type, optional_pattern, include_input_type, color_tint_text)
	local pattern = optional_pattern or "%s %s"
	local service_type = optional_service_type or "View"
	local alias_key = Managers.ui:get_input_alias_key(action, service_type)
	local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key, color_tint_text)

	if include_input_type then
		local action_type = Managers.ui:get_action_type(action, service_type)

		if action_type == "held" then
			input_text = Localize("loc_input_hold") .. " " .. input_text
		elseif action_type == "released" then
			input_text = Localize("loc_input_release") .. " " .. input_text
		end
	end

	local localized_text = Localize(localization_key, optional_localization_context ~= nil, optional_localization_context)

	return string.format(pattern, input_text, localized_text)
end

local SECONDS_IN_A_MINUTE = 60
local SECONDS_IN_AN_HOUR = SECONDS_IN_A_MINUTE * 60
local SECONDS_IN_A_DAY = SECONDS_IN_AN_HOUR * 24

local function _get_days(seconds)
	local days = math.floor(seconds / SECONDS_IN_A_DAY)
	local formatted_days

	if days == 1 then
		formatted_days = Localize("loc_text_util_time_left_1_day")
	else
		formatted_days = Localize("loc_text_util_time_left_days", true, {
			number = days,
		})
	end

	return days, formatted_days
end

local function _get_hours(seconds)
	local hours = math.floor(seconds % SECONDS_IN_A_DAY / SECONDS_IN_AN_HOUR)
	local formatted_hours

	if hours == 1 then
		formatted_hours = Localize("loc_text_util_time_left_1_hour")
	else
		formatted_hours = Localize("loc_text_util_time_left_hours", true, {
			number = hours,
		})
	end

	return hours, formatted_hours
end

local function _get_minutes(seconds)
	local minutes = math.floor(seconds % SECONDS_IN_AN_HOUR / SECONDS_IN_A_MINUTE)
	local formatted_minutes

	if minutes == 1 then
		formatted_minutes = Localize("loc_text_util_time_left_1_minute")
	else
		formatted_minutes = Localize("loc_text_util_time_left_minutes", true, {
			number = minutes,
		})
	end

	return minutes, formatted_minutes
end

local function _get_seconds(seconds)
	seconds = math.floor(seconds % SECONDS_IN_A_MINUTE)

	local formatted_seconds

	if seconds == 1 then
		formatted_seconds = Localize("loc_text_util_time_left_1_second")
	else
		formatted_seconds = Localize("loc_text_util_time_left_seconds", true, {
			number = seconds,
		})
	end

	return seconds, formatted_seconds
end

TextUtilities.format_time_span_long_form_localized = function (num_seconds)
	local _, major_time_unit_formatted, minor_time_unit, minor_time_unit_formatted

	if num_seconds >= SECONDS_IN_A_DAY then
		_, major_time_unit_formatted = _get_days(num_seconds)
		minor_time_unit, minor_time_unit_formatted = _get_hours(num_seconds)
	elseif num_seconds >= SECONDS_IN_AN_HOUR then
		_, major_time_unit_formatted = _get_hours(num_seconds)
		minor_time_unit, minor_time_unit_formatted = _get_minutes(num_seconds)
	elseif num_seconds >= SECONDS_IN_A_MINUTE then
		_, major_time_unit_formatted = _get_minutes(num_seconds)
		minor_time_unit = 0
	else
		_, major_time_unit_formatted = _get_seconds(num_seconds)
		minor_time_unit = 0
	end

	if minor_time_unit > 0 then
		return Localize("loc_text_util_time_left_delimiter", true, {
			major_time_unit = major_time_unit_formatted,
			minor_time_unit = minor_time_unit_formatted,
		})
	end

	return major_time_unit_formatted
end

local _roman_number_array = {
	1,
	4,
	5,
	9,
	10,
	40,
	50,
	90,
	100,
	400,
	500,
	900,
	1000,
}
local _roman_small_cache = {
	"I",
	"II",
	"III",
	"IV",
	"V",
	"VI",
	"VII",
	"VIII",
	"IX",
	"X",
}
local _roman_chars = {
	"I",
	"IV",
	"V",
	"IX",
	"X",
	"XL",
	"L",
	"XC",
	"C",
	"CD",
	"D",
	"CM",
	"M",
}

TextUtilities.convert_to_roman_numerals = function (value)
	value = math.floor(value)

	if value > 0 and value <= 10 then
		return _roman_small_cache[value]
	end

	local idx = 13
	local roman_value = ""

	while value > 0 do
		local div = value / _roman_number_array[idx]

		value = value % _roman_number_array[idx]

		for j = 1, div do
			roman_value = roman_value .. _roman_chars[idx]
		end

		idx = idx - 1
	end

	return roman_value
end

local _formatted_character_name_character_name_params = {}

TextUtilities.formatted_character_name = function (character_name, level)
	if character_name ~= "" then
		local character_name_params = _formatted_character_name_character_name_params

		character_name_params.character_name = character_name
		character_name_params.character_level = level
		character_name = Localize("loc_social_menu_character_name_format", true, character_name_params)
	end

	return character_name
end

TextUtilities.format_localized_talent_strings_with_values = function (localized_string, format_values)
	if not localized_string then
		return ""
	end

	if not format_values then
		return localized_string
	end

	localized_string = string.format(localized_string, unpack(format_values))

	return localized_string
end

TextUtilities.format_currency = function (value)
	local value_string = tostring(value)
	local separation_limit = 3
	local formatted_string = ""
	local count = 0

	for i = #value_string, 1, -1 do
		if count == separation_limit then
			count = 0
			formatted_string = " " .. formatted_string
		end

		count = count + 1

		local character = value_string:sub(i, i)

		formatted_string = character .. formatted_string
	end

	return formatted_string
end

return TextUtilities
