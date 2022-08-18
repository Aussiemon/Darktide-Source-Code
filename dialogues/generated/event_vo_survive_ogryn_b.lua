local event_vo_survive_ogryn_b = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__event_survive_almost_done_01",
			"loc_ogryn_b__event_survive_almost_done_02",
			"loc_ogryn_b__event_survive_almost_done_03",
			"loc_ogryn_b__event_survive_almost_done_04"
		},
		sound_events_duration = {
			2.33049,
			1.681969,
			2.089469,
			1.839281
		},
		randomize_indexes = {}
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__event_survive_keep_coming_a_01",
			"loc_ogryn_b__event_survive_keep_coming_a_02",
			"loc_ogryn_b__event_survive_keep_coming_a_03",
			"loc_ogryn_b__event_survive_keep_coming_a_04"
		},
		sound_events_duration = {
			1.202792,
			4.226323,
			3.112625,
			2.574063
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_survive_ogryn_b", event_vo_survive_ogryn_b)
