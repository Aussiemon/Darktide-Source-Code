﻿-- chunkname: @dialogues/generated/event_vo_hacking_veteran_female_a.lua

local event_vo_hacking_veteran_female_a = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_veteran_female_a__hacking_auspex_mutter_a_01",
			"loc_veteran_female_a__hacking_auspex_mutter_a_02",
			"loc_veteran_female_a__hacking_auspex_mutter_a_03",
			"loc_veteran_female_a__hacking_auspex_mutter_a_04",
			"loc_veteran_female_a__hacking_auspex_mutter_a_05",
		},
		sound_events_duration = {
			1.355417,
			1.636333,
			0.837,
			1.926625,
			1.657063,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_a__response_to_hacking_fix_decode_01",
			[2] = "loc_veteran_female_a__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 1.983188,
			[2] = 2.133958,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_veteran_female_a", event_vo_hacking_veteran_female_a)
