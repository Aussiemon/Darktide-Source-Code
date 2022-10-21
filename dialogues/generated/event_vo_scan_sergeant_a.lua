local event_vo_scan_sergeant_a = {
	cmd_wandering_skull = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_sergeant_a__cmd_wandering_skull_01",
			"loc_sergeant_a__cmd_wandering_skull_02",
			"loc_sergeant_a__cmd_wandering_skull_03",
			"loc_sergeant_a__cmd_wandering_skull_04",
			"loc_sergeant_a__cmd_wandering_skull_05"
		},
		sound_events_duration = {
			3.315688,
			3.865896,
			3.360229,
			4.291333,
			3.550792
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
	event_scan_more_data = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_sergeant_a__event_scan_more_data_01",
			"loc_sergeant_a__event_scan_more_data_02",
			"loc_sergeant_a__event_scan_more_data_03",
			"loc_sergeant_a__event_scan_more_data_04",
			"loc_sergeant_a__event_scan_more_data_05",
			"loc_sergeant_a__event_scan_more_data_06",
			"loc_sergeant_a__event_scan_more_data_07",
			"loc_sergeant_a__event_scan_more_data_08",
			"loc_sergeant_a__event_scan_more_data_09",
			"loc_sergeant_a__event_scan_more_data_10"
		},
		sound_events_duration = {
			3.423833,
			4.050771,
			3.934667,
			4.793792,
			3.874729,
			4.542917,
			4.508563,
			4.424104,
			3.695021,
			4.450188
		},
		randomize_indexes = {}
	},
	event_scan_skull_waiting = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_scan_skull_waiting_01",
			"loc_sergeant_a__event_scan_skull_waiting_02",
			"loc_sergeant_a__event_scan_skull_waiting_03",
			"loc_sergeant_a__event_scan_skull_waiting_04"
		},
		sound_events_duration = {
			2.982646,
			4.282958,
			3.748896,
			4.967958
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_scan_sergeant_a", event_vo_scan_sergeant_a)
