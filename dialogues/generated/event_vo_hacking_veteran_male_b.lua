﻿-- chunkname: @dialogues/generated/event_vo_hacking_veteran_male_b.lua

local event_vo_hacking_veteran_male_b = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_b__hacking_auspex_mutter_a_01",
			"loc_veteran_male_b__hacking_auspex_mutter_a_03",
			"loc_veteran_male_b__hacking_auspex_mutter_a_04",
			"loc_veteran_male_b__hacking_auspex_mutter_a_05",
		},
		sound_events_duration = {
			1.57125,
			1.264042,
			1.972271,
			1.667375,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_b__response_to_hacking_fix_decode_01",
			[2] = "loc_veteran_male_b__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 2.275229,
			[2] = 2.564646,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_veteran_male_b", event_vo_hacking_veteran_male_b)
