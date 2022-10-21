local input_locale_name_overrides = {
	mouse = {
		extra_2 = "",
		wheel = "",
		extra_1 = "",
		middle = "",
		left = "",
		right = ""
	},
	xbox_controller = {
		left = "",
		a = "",
		left_thumb = "",
		left_shoulder = "",
		d_down = "",
		right_thumb = "",
		right_shoulder = "",
		left_trigger = "",
		d_right = "",
		d_up = "",
		back = "",
		d_left = "",
		b = "",
		y = "",
		right_trigger = "",
		x = "",
		right = "",
		start = Localize("loc_xbs_input_locale_start")
	}
}

return settings("InputLocaleNameOverrides", input_locale_name_overrides)
