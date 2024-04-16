local event_vo_hacking_ogryn_c = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_ogryn_c__hacking_auspex_mutter_a_01",
			"loc_ogryn_c__hacking_auspex_mutter_a_02",
			"loc_ogryn_c__hacking_auspex_mutter_a_03",
			"loc_ogryn_c__hacking_auspex_mutter_a_04",
			"loc_ogryn_c__hacking_auspex_mutter_a_05"
		},
		sound_events_duration = {
			2.056427,
			2.852656,
			2.998292,
			0.580135,
			2.87674
		},
		randomize_indexes = {}
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__response_to_hacking_fix_decode_01",
			[2.0] = "loc_ogryn_c__response_to_hacking_fix_decode_02"
		},
		sound_events_duration = {
			[1.0] = 2.220021,
			[2.0] = 2.576646
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_hacking_ogryn_c", event_vo_hacking_ogryn_c)
