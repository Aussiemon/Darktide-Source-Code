﻿-- chunkname: @scripts/settings/input/input_locale_name_overrides.lua

local input_locale_name_overrides = {
	keyboard = {
		["numpad 0"] = Localize("loc_keyboard_input_numpad_0"),
		["numpad 1"] = Localize("loc_keyboard_input_numpad_1"),
		["numpad 2"] = Localize("loc_keyboard_input_numpad_2"),
		["numpad 3"] = Localize("loc_keyboard_input_numpad_3"),
		["numpad 4"] = Localize("loc_keyboard_input_numpad_4"),
		["numpad 5"] = Localize("loc_keyboard_input_numpad_5"),
		["numpad 6"] = Localize("loc_keyboard_input_numpad_6"),
		["numpad 7"] = Localize("loc_keyboard_input_numpad_7"),
		["numpad 8"] = Localize("loc_keyboard_input_numpad_8"),
		["numpad 9"] = Localize("loc_keyboard_input_numpad_9"),
		space = Localize("loc_keyboard_input_space"),
		enter = Localize("loc_keyboard_input_enter"),
		tab = Localize("loc_keyboard_input_tab"),
		esc = Localize("loc_keyboard_input_esc"),
		["left shift"] = Localize("loc_keyboard_input_shift"),
		["right shift"] = Localize("loc_keyboard_input_shift"),
		["left ctrl"] = Localize("loc_keyboard_input_ctrl"),
		["right ctrl"] = Localize("loc_keyboard_input_ctrl"),
		["left alt"] = Localize("loc_keyboard_input_alt"),
		["right alt"] = Localize("loc_keyboard_input_alt"),
		left = Localize("loc_keyboard_input_arrow_left"),
		right = Localize("loc_keyboard_input_arrow_right"),
		up = Localize("loc_keyboard_input_arrow_up"),
		down = Localize("loc_keyboard_input_arrow_down")
	},
	mouse = {
		extra_1 = "",
		extra_2 = "",
		wheel = "",
		wheel_down = "",
		wheel_up = "",
		middle = "",
		left = "",
		right = ""
	},
	xbox_controller = {
		left = "",
		a = "",
		left_thumb = "",
		left_shoulder = "",
		d_down = "",
		right_thumb = "",
		right_shoulder = "",
		left_trigger = "",
		d_right = "",
		d_up = "",
		start = "",
		back = "",
		d_left = "",
		b = "",
		y = "",
		right_trigger = "",
		x = "",
		right = ""
	}
}

return settings("InputLocaleNameOverrides", input_locale_name_overrides)
