local gameplay_vo_pilot_a = {
	event_one_down = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_pilot_a__info_event_one_down_01",
			"loc_pilot_a__info_event_one_down_02",
			"loc_pilot_a__info_event_one_down_03",
			"loc_pilot_a__info_event_one_down_04",
			"loc_pilot_a__info_event_one_down_05"
		},
		sound_events_duration = {
			0.84075,
			0.514813,
			1.354354,
			0.864417,
			1.036417
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2
		},
		randomize_indexes = {}
	},
	info_event_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_pilot_a__info_event_almost_done_01",
			"loc_pilot_a__info_event_almost_done_02",
			"loc_pilot_a__info_event_almost_done_03",
			"loc_pilot_a__info_event_almost_done_04",
			"loc_pilot_a__info_event_almost_done_05"
		},
		sound_events_duration = {
			1.119125,
			1.148792,
			2.066104,
			0.987021,
			2.095833
		},
		randomize_indexes = {}
	}
}

return settings("gameplay_vo_pilot_a", gameplay_vo_pilot_a)
