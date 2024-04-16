local event_vo_hacking_zealot_male_a = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_zealot_male_a__hacking_auspex_mutter_a_01",
			"loc_zealot_male_a__hacking_auspex_mutter_a_02",
			"loc_zealot_male_a__hacking_auspex_mutter_a_03",
			"loc_zealot_male_a__hacking_auspex_mutter_a_04",
			"loc_zealot_male_a__hacking_auspex_mutter_a_05"
		},
		sound_events_duration = {
			1.105292,
			1.21125,
			0.974104,
			0.520208,
			1.091021
		},
		randomize_indexes = {}
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_a__response_to_hacking_fix_decode_01",
			[2.0] = "loc_zealot_male_a__response_to_hacking_fix_decode_02"
		},
		sound_events_duration = {
			[1.0] = 2.318854,
			[2.0] = 2.068375
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_hacking_zealot_male_a", event_vo_hacking_zealot_male_a)
