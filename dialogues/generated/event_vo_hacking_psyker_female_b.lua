local event_vo_hacking_psyker_female_b = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_psyker_female_b__hacking_auspex_mutter_a_01",
			"loc_psyker_female_b__hacking_auspex_mutter_a_02",
			"loc_psyker_female_b__hacking_auspex_mutter_a_03",
			"loc_psyker_female_b__hacking_auspex_mutter_a_04",
			"loc_psyker_female_b__hacking_auspex_mutter_a_05"
		},
		sound_events_duration = {
			1.906563,
			2.513146,
			1.602354,
			1.653083,
			1.8565
		},
		randomize_indexes = {}
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_b__response_to_hacking_fix_decode_01",
			[2.0] = "loc_psyker_female_b__response_to_hacking_fix_decode_02"
		},
		sound_events_duration = {
			[1.0] = 1.959854,
			[2.0] = 2.564396
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_hacking_psyker_female_b", event_vo_hacking_psyker_female_b)
