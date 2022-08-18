local InputUtils = require("scripts/managers/input/input_utils")
local TextUtilities = {
	apply_color_to_text = function (text, color)
		return "{#color(" .. color[2] .. "," .. color[3] .. "," .. color[4] .. ")}" .. text .. "{#reset()}"
	end,
	localize_to_upper = function (localization_key, optional_localization_context)
		local localized_text = Localize(localization_key, optional_localization_context ~= nil, optional_localization_context)

		return Utf8.upper(localized_text)
	end,
	localize_to_title_case = function (localization_key, optional_localization_context)
		local localized_text = Localize(localization_key, optional_localization_context ~= nil, optional_localization_context)
		local title_case_text = nil

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
	end,
	localize_with_button_hint = function (action, localization_key, optional_localization_context, optional_service_type, optional_pattern)
		local pattern = optional_pattern or "%s %s"
		local service_type = optional_service_type or "View"
		local alias_key = Managers.ui:get_input_alias_key(action, service_type)
		local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)
		local localized_text = Localize(localization_key, optional_localization_context ~= nil, optional_localization_context)

		return string.format(pattern, input_text, localized_text)
	end
}
local SECONDS_IN_A_MINUTE = 60
local SECONDS_IN_AN_HOUR = SECONDS_IN_A_MINUTE * 60
local SECONDS_IN_A_DAY = SECONDS_IN_AN_HOUR * 24

local function _get_days(seconds)
	local days = math.floor(seconds / SECONDS_IN_A_DAY)
	local formatted_days = nil

	if days == 1 then
		formatted_days = Localize("loc_text_util_time_left_1_day")
	else
		formatted_days = Localize("loc_text_util_time_left_days", true, {
			number = days
		})
	end

	return days, formatted_days
end

local function _get_hours(seconds)
	local hours = math.floor(seconds % SECONDS_IN_A_DAY / SECONDS_IN_AN_HOUR)
	local formatted_hours = nil

	if hours == 1 then
		formatted_hours = Localize("loc_text_util_time_left_1_hour")
	else
		formatted_hours = Localize("loc_text_util_time_left_hours", true, {
			number = hours
		})
	end

	return hours, formatted_hours
end

local function _get_minutes(seconds)
	local minutes = math.floor(seconds % SECONDS_IN_AN_HOUR / SECONDS_IN_A_MINUTE)
	local formatted_minutes = nil

	if minutes == 1 then
		formatted_minutes = Localize("loc_text_util_time_left_1_minute")
	else
		formatted_minutes = Localize("loc_text_util_time_left_minutes", true, {
			number = minutes
		})
	end

	return minutes, formatted_minutes
end

local function _get_seconds(seconds)
	seconds = math.floor(seconds % SECONDS_IN_A_MINUTE)
	local formatted_seconds = nil

	if seconds == 1 then
		formatted_seconds = Localize("loc_text_util_time_left_1_second")
	else
		formatted_seconds = Localize("loc_text_util_time_left_seconds", true, {
			number = seconds
		})
	end

	return seconds, formatted_seconds
end

TextUtilities.format_time_span_long_form_localized = function (num_seconds)
	local _, major_time_unit_formatted, minor_time_unit, minor_time_unit_formatted = nil

	if SECONDS_IN_A_DAY <= num_seconds then
		_, major_time_unit_formatted = _get_days(num_seconds)
		minor_time_unit, minor_time_unit_formatted = _get_hours(num_seconds)
	elseif SECONDS_IN_AN_HOUR <= num_seconds then
		_, major_time_unit_formatted = _get_hours(num_seconds)
		minor_time_unit, minor_time_unit_formatted = _get_minutes(num_seconds)
	elseif SECONDS_IN_A_MINUTE <= num_seconds then
		_, major_time_unit_formatted = _get_minutes(num_seconds)
		minor_time_unit, minor_time_unit_formatted = _get_seconds(num_seconds)
	else
		_, major_time_unit_formatted = _get_seconds(num_seconds)
		minor_time_unit = 0
	end

	if minor_time_unit > 0 then
		return Localize("loc_text_util_time_left_delimiter", true, {
			major_time_unit = major_time_unit_formatted,
			minor_time_unit = minor_time_unit_formatted
		})
	end

	return major_time_unit_formatted
end

local _roman_number_array = {
	1,
	5,
	10,
	50,
	100,
	500,
	1000
}
local _roman_chars = {
	"I",
	"V",
	"X",
	"L",
	"C",
	"D",
	"M"
}

TextUtilities.convert_to_roman_numerals = function (value)
	value = math.floor(value)

	if value <= 0 then
		return value
	end

	local return_value = ""

	for i = #_roman_number_array, 1, -1 do
		local num = _roman_number_array[i]

		while value - num >= 0 and value > 0 do
			return_value = return_value .. _roman_chars[i]
			value = value - num
		end

		for j = 1, i - 1, 1 do
			local n2 = _roman_number_array[j]

			if value - (num - n2) >= 0 and value < num and value > 0 and num - n2 ~= n2 then
				return_value = return_value .. _roman_chars[j] .. _roman_chars[i]
				value = value - (num - n2)

				break
			end
		end
	end

	return return_value
end

local _formatted_character_name_character_name_params = {}

TextUtilities.formatted_character_name = function (player_info)
	local character_name = player_info:character_name()

	if character_name ~= "" then
		local character_name_params = _formatted_character_name_character_name_params
		character_name_params.character_name = character_name
		character_name_params.character_level = player_info:character_level()
		character_name = Localize("loc_social_menu_character_name_format", true, character_name_params)
	end

	return character_name
end

return TextUtilities
