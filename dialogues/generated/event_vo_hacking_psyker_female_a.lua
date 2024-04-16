local event_vo_hacking_psyker_female_a = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_psyker_female_a__hacking_auspex_mutter_a_01",
			"loc_psyker_female_a__hacking_auspex_mutter_a_02",
			"loc_psyker_female_a__hacking_auspex_mutter_a_03",
			"loc_psyker_female_a__hacking_auspex_mutter_a_04",
			"loc_psyker_female_a__hacking_auspex_mutter_a_05"
		},
		sound_events_duration = {
			1.306917,
			2.254938,
			0.994938,
			2.806958,
			1.761979
		},
		randomize_indexes = {}
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_a__response_to_hacking_fix_decode_01",
			[2.0] = "loc_psyker_female_a__response_to_hacking_fix_decode_02"
		},
		sound_events_duration = {
			[1.0] = 2.340083,
			[2.0] = 2.200792
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_hacking_psyker_female_a", event_vo_hacking_psyker_female_a)
