local circumstance_vo_darkness_pilot_a = {
	power_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__power_circumstance_start_a_01",
			"loc_pilot_a__power_circumstance_start_a_02",
			"loc_pilot_a__power_circumstance_start_a_03",
			"loc_pilot_a__power_circumstance_start_a_04"
		},
		sound_events_duration = {
			4.336854,
			5.023271,
			5.367271,
			4.948854
		},
		randomize_indexes = {}
	},
	power_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__power_circumstance_start_b_01",
			"loc_pilot_a__power_circumstance_start_b_02",
			"loc_pilot_a__power_circumstance_start_b_03",
			"loc_pilot_a__power_circumstance_start_b_04"
		},
		sound_events_duration = {
			5.187729,
			4.633563,
			6.149021,
			5.189875
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

return settings("circumstance_vo_darkness_pilot_a", circumstance_vo_darkness_pilot_a)
