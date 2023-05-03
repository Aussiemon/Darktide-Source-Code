local circumstance_vo_darkness_sergeant_a = {
	power_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__power_circumstance_start_a_01",
			"loc_sergeant_a__power_circumstance_start_a_02",
			"loc_sergeant_a__power_circumstance_start_a_03",
			"loc_sergeant_a__power_circumstance_start_a_04"
		},
		sound_events_duration = {
			5.223458,
			4.644938,
			4.278396,
			5.824
		},
		randomize_indexes = {}
	},
	power_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__power_circumstance_start_b_01",
			"loc_sergeant_a__power_circumstance_start_b_02",
			"loc_sergeant_a__power_circumstance_start_b_03",
			"loc_sergeant_a__power_circumstance_start_b_04"
		},
		sound_events_duration = {
			2.931896,
			3.906417,
			5.468292,
			5.626604
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	}
}

return settings("circumstance_vo_darkness_sergeant_a", circumstance_vo_darkness_sergeant_a)
