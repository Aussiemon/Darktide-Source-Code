﻿-- chunkname: @dialogues/generated/event_vo_hacking_ogryn_b.lua

local event_vo_hacking_ogryn_b = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_ogryn_b__hacking_auspex_mutter_a_01",
			"loc_ogryn_b__hacking_auspex_mutter_a_02",
			"loc_ogryn_b__hacking_auspex_mutter_a_03",
			"loc_ogryn_b__hacking_auspex_mutter_a_04",
			"loc_ogryn_b__hacking_auspex_mutter_a_05",
		},
		sound_events_duration = {
			2.265521,
			3.940833,
			1.77725,
			2.495406,
			2.721271,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_b__response_to_hacking_fix_decode_01",
			[2] = "loc_ogryn_b__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 1.702333,
			[2] = 2.07276,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_ogryn_b", event_vo_hacking_ogryn_b)
