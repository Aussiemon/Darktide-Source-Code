local event_vo_hacking_psyker_male_b = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_psyker_male_b__hacking_auspex_mutter_a_01",
			"loc_psyker_male_b__hacking_auspex_mutter_a_02",
			"loc_psyker_male_b__hacking_auspex_mutter_a_03",
			"loc_psyker_male_b__hacking_auspex_mutter_a_04",
			"loc_psyker_male_b__hacking_auspex_mutter_a_05"
		},
		sound_events_duration = {
			1.626354,
			2.249792,
			1.456542,
			2.295813,
			1.851229
		},
		randomize_indexes = {}
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_b__response_to_hacking_fix_decode_01",
			[2.0] = "loc_psyker_male_b__response_to_hacking_fix_decode_02"
		},
		sound_events_duration = {
			[1.0] = 2.841146,
			[2.0] = 3.660479
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_hacking_psyker_male_b", event_vo_hacking_psyker_male_b)
