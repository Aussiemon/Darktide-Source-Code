local event_vo_hacking_psyker_female_c = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_psyker_female_c__hacking_auspex_mutter_a_01",
			"loc_psyker_female_c__hacking_auspex_mutter_a_02",
			"loc_psyker_female_c__hacking_auspex_mutter_a_03",
			"loc_psyker_female_c__hacking_auspex_mutter_a_04",
			"loc_psyker_female_c__hacking_auspex_mutter_a_05"
		},
		sound_events_duration = {
			2.13201,
			1.575875,
			2.031219,
			2.260646,
			1.018344
		},
		randomize_indexes = {}
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_c__response_to_hacking_fix_decode_01",
			[2.0] = "loc_psyker_female_c__response_to_hacking_fix_decode_02"
		},
		sound_events_duration = {
			[1.0] = 1.886781,
			[2.0] = 1.695427
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_hacking_psyker_female_c", event_vo_hacking_psyker_female_c)
