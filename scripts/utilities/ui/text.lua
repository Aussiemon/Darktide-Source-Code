-- chunkname: @scripts/utilities/ui/text.lua

local InputUtils = require("scripts/managers/input/input_utils")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local TextUtilities = {}

TextUtilities.apply_color_to_text = function (text, color)
	return string.format("{#color(%d,%d,%d)}%s{#reset()}", color[2], color[3], color[4], text)
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

TextUtilities.add_button_hint = function (action, text, optional_service_type, optional_pattern, include_input_type, color_tint_text)
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

	return string.format(pattern, input_text, text)
end

local SECONDS_IN_A_MINUTE = 60
local SECONDS_IN_AN_HOUR = SECONDS_IN_A_MINUTE * 60
local SECONDS_IN_A_DAY = SECONDS_IN_AN_HOUR * 24

local function _get_time(seconds, length, multiple_format, single_format, short_format, use_short)
	single_format = single_format or multiple_format

	local value = math.floor(seconds / length)
	local key = use_short == true and short_format or value == 1 and single_format or multiple_format
	local text = Localize(key, true, {
		number = value,
	})

	return value, text, seconds - value * length
end

local function _get_days(seconds, use_short)
	return _get_time(seconds, SECONDS_IN_A_DAY, "loc_text_util_time_left_days", "loc_text_util_time_left_1_day", "loc_text_short_day", use_short)
end

local function _get_hours(seconds, use_short)
	return _get_time(seconds, SECONDS_IN_AN_HOUR, "loc_text_util_time_left_hours", "loc_text_util_time_left_1_hour", "loc_text_short_hour", use_short)
end

local function _get_minutes(seconds, use_short)
	return _get_time(seconds, SECONDS_IN_A_MINUTE, "loc_text_util_time_left_minutes", "loc_text_util_time_left_1_minute", "loc_text_short_minute", use_short)
end

local function _get_seconds(seconds, use_short)
	return _get_time(seconds, 1, "loc_text_util_time_left_seconds", "loc_text_util_time_left_1_second", "loc_text_short_second", use_short)
end

local _time_steps = {
	{
		value = SECONDS_IN_A_DAY,
		get = _get_days,
	},
	{
		value = SECONDS_IN_AN_HOUR,
		get = _get_hours,
	},
	{
		force_break = true,
		value = SECONDS_IN_A_MINUTE,
		get = _get_minutes,
	},
	{
		value = 1,
		get = _get_seconds,
	},
}

TextUtilities.format_time_span_localized = function (seconds, use_short, allow_skip, max_detail)
	allow_skip = allow_skip == true
	use_short = use_short == true
	max_detail = max_detail or 2

	local step_count, steps = 0, {}

	for i = 1, #_time_steps do
		local time_step_config = _time_steps[i]
		local units, text, seconds_left = time_step_config.get(seconds, use_short)
		local should_add = units > 0 or i == #_time_steps

		if should_add then
			seconds, step_count = seconds_left, step_count + 1
			steps[step_count] = text
		end

		local force_break = should_add and time_step_config.force_break
		local break_on_skip = not allow_skip and step_count >= 1 and units == 0
		local is_full = max_detail <= step_count
		local should_break = force_break or break_on_skip or is_full

		if should_break then
			break
		end
	end

	local separator = use_short and " " or ", "

	return table.concat(steps, separator)
end

TextUtilities.format_time_span_long_form_localized = function (seconds)
	return TextUtilities.format_time_span_localized(seconds)
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

TextUtilities.text_size = function (ui_renderer, text, style, optional_size, use_max_extents)
	local calculated_size

	if optional_size then
		calculated_size = {
			optional_size[1] or 0,
			optional_size[2] or 0,
		}
	else
		local text_size = style.size
		local width = text_size and text_size[1]
		local height = text_size and text_size[2]
		local has_size = width or height

		if has_size then
			width = width or 0
			height = height or 0

			local text_additional_size = style.size_addition

			if text_additional_size then
				local additional_width = text_additional_size[1] or 0
				local additional_height = text_additional_size[2] or 0

				width = width + additional_width
				height = height + additional_height
			end

			calculated_size = {
				width,
				height,
			}
		end
	end

	return UIRenderer.styled_text_size(ui_renderer, text, style, calculated_size, use_max_extents)
end

TextUtilities.text_height = function (ui_renderer, text, style, optional_size, use_max_extents)
	local _, text_height, min, caret = TextUtilities.text_size(ui_renderer, text, style, optional_size, use_max_extents)

	return text_height, min, caret
end

TextUtilities.text_width = function (ui_renderer, text, style, optional_size, use_max_extents)
	local text_width, _, min, caret = TextUtilities.text_size(ui_renderer, text, style, optional_size, use_max_extents)

	return text_width, min, caret
end

TextUtilities.scaled_size = function (font_size, scale)
	return UIFonts.scaled_size(font_size, scale)
end

TextUtilities.crop_text_width = function (ui_renderer, text, style, max_width, crop_from_left)
	local use_max_extents = true

	return UIRenderer.styled_crop_text_width(ui_renderer, text, style, max_width, crop_from_left, use_max_extents)
end

TextUtilities.word_wrap = function (ui_renderer, text, text_style, text_width)
	return UIRenderer.word_wrap(ui_renderer, text, text_style.font_type, text_style.font_size, text_width)
end

TextUtilities.crop_to_size = function (ui_renderer, text, text_style, size, use_max_extents, append_if_too_long)
	append_if_too_long = append_if_too_long or "…"

	local width, height = size[1], size[2]
	local almost_math_dot_huge = 1000000

	size[2] = almost_math_dot_huge

	local target_height = height

	if text_style and text_style.size_addition then
		size[1] = size[1] + (text_style.size_addition[1] or 0)
		target_height = target_height + (text_style.size_addition[2] or 0)
	end

	if target_height >= TextUtilities.text_height(ui_renderer, text, text_style, size, use_max_extents) then
		size[1], size[2] = width, height

		return text
	end

	local text_length = Utf8.string_length(text)
	local lo, hi = 0, text_length

	while lo < hi do
		local mid = lo + math.ceil((hi - lo) / 2)
		local sub_text = mid >= 1 and Utf8.sub_string(text, 1, mid) .. append_if_too_long or ""
		local text_height = TextUtilities.text_height(ui_renderer, sub_text, text_style, size, use_max_extents)

		if text_height <= target_height then
			lo = mid
		else
			hi = mid - 1
		end
	end

	size[1], size[2] = width, height

	if lo == 0 then
		return ""
	end

	return Utf8.sub_string(text, 1, lo) .. append_if_too_long
end

local temp_options = {}

TextUtilities.get_font_options_by_style = function (ui_renderer, text, text_style)
	table.clear(temp_options)

	return UIFonts.get_font_options_by_style(text_style, temp_options)
end

do
	local powers_of_three = {
		{
			loc_key = "loc_key_1e3",
			value = 1000,
		},
		{
			loc_key = "loc_key_1e6",
			value = 1000000,
		},
		{
			loc_key = "loc_key_1e9",
			value = 1000000000,
		},
	}
	local powers_of_four = {
		{
			loc_key = "loc_key_1e4",
			value = 10000,
		},
		{
			loc_key = "loc_key_1e8",
			value = 100000000,
		},
	}
	local suffixes_by_language = {
		ja = powers_of_four,
		["zh-cn"] = powers_of_four,
		["zh-tw"] = powers_of_four,
		default = powers_of_three,
	}

	TextUtilities.format_large_number = function (value, factor)
		factor = factor or 1

		local language = Managers.localization:language()
		local suffix = suffixes_by_language[language] or suffixes_by_language.default

		for i = #suffix, 1, -1 do
			local suffix_data = suffix[i]

			if value >= suffix_data.value * factor then
				local formatted_value = math.round(value / suffix_data.value)

				return Localize(suffix_data.loc_key, true, {
					value = formatted_value,
				})
			end
		end

		return tostring(value)
	end
end

return TextUtilities
