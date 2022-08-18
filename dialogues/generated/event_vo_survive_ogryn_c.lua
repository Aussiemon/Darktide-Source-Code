local event_vo_survive_ogryn_c = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_survive_almost_done_01",
			"loc_ogryn_c__event_survive_almost_done_02",
			"loc_ogryn_c__event_survive_almost_done_03",
			"loc_ogryn_c__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.588354,
			2.627313,
			2.523688,
			1.358396
		},
		randomize_indexes = {}
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_survive_keep_coming_a_01",
			"loc_ogryn_c__event_survive_keep_coming_a_02",
			"loc_ogryn_c__event_survive_keep_coming_a_03",
			"loc_ogryn_c__event_survive_keep_coming_a_04"
		},
		sound_events_duration = {
			1.462688,
			1.850958,
			2.412104,
			2.221896
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_survive_ogryn_c", event_vo_survive_ogryn_c)
