local input_locale_name_overrides = {
	mouse = {
		extra_2 = "\ue068",
		wheel = "\ue066",
		extra_1 = "\ue067",
		middle = "\ue065",
		left = "\ue063",
		right = "\ue064"
	},
	xbox_controller = {
		d_up = "\ue0d6",
		a = "\ue0c7",
		left_thumb = "\ue0cc",
		left_shoulder = "\ue0cf",
		right_trigger = "\ue0d2",
		right_thumb = "\ue0ce",
		left = "\ue0cb",
		b = "\ue0c8",
		d_right = "\ue0d7",
		d_down = "\ue0d8",
		d_left = "\ue0d9",
		y = "\ue0ca",
		right_shoulder = "\ue0d0",
		left_trigger = "\ue0d1",
		x = "\ue0c9",
		right = "\ue0cd"
	}
}

return settings("InputLocaleNameOverrides", input_locale_name_overrides)
