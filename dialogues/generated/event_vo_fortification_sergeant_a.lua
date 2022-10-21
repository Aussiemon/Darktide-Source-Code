local event_vo_fortification_sergeant_a = {
	event_fortification_disable_the_skyfire = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_fortification_disable_the_skyfire_01",
			"loc_sergeant_a__event_fortification_disable_the_skyfire_02",
			"loc_sergeant_a__event_fortification_disable_the_skyfire_03",
			"loc_sergeant_a__event_fortification_disable_the_skyfire_04"
		},
		sound_events_duration = {
			6.854854,
			4.841458,
			5.667208,
			5.735
		},
		randomize_indexes = {}
	},
	event_fortification_fortification_survive = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_fortification_fortification_survive_01",
			"loc_sergeant_a__event_fortification_fortification_survive_02",
			"loc_sergeant_a__event_fortification_fortification_survive_03",
			"loc_sergeant_a__event_fortification_fortification_survive_04"
		},
		sound_events_duration = {
			4.349,
			3.816646,
			4.295125,
			3.663333
		},
		randomize_indexes = {}
	},
	event_fortification_kill_stragglers = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__info_event_demolition_corruptors_almost_done_01",
			"loc_sergeant_a__info_event_demolition_corruptors_almost_done_02",
			"loc_sergeant_a__info_event_demolition_corruptors_almost_done_03",
			"loc_sergeant_a__info_event_demolition_corruptors_almost_done_04"
		},
		sound_events_duration = {
			2.915729,
			2.856563,
			3.201958,
			2.753146
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	event_fortification_power_up_gate = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_fortification_power_up_gate_01",
			"loc_sergeant_a__event_fortification_power_up_gate_02",
			"loc_sergeant_a__event_fortification_power_up_gate_03",
			"loc_sergeant_a__event_fortification_power_up_gate_04"
		},
		sound_events_duration = {
			3.173646,
			3.988563,
			3.914521,
			3.420417
		},
		randomize_indexes = {}
	},
	event_fortification_set_landing_beacon = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_fortification_set_landing_beacon_01",
			"loc_sergeant_a__event_fortification_set_landing_beacon_02",
			"loc_sergeant_a__event_fortification_set_landing_beacon_03",
			"loc_sergeant_a__event_fortification_set_landing_beacon_04"
		},
		sound_events_duration = {
			4.131292,
			4.933458,
			4.233958,
			4.500667
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_sergeant_a", event_vo_fortification_sergeant_a)
