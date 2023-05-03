local circumstance_vo_ventilation_purge_veteran_male_a = {
	combat_pause_circumstance_ogryn_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_a__combat_pause_circumstance_ogryn_a_gas_b_01",
			[2.0] = "loc_veteran_male_a__combat_pause_circumstance_ogryn_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 5.734396,
			[2.0] = 3.060438
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_a__combat_pause_circumstance_psyker_a_gas_b_01",
			[2.0] = "loc_veteran_male_a__combat_pause_circumstance_psyker_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 2.706833,
			[2.0] = 2.597771
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_a_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_a__combat_pause_circumstance_veteran_a_gas_a_01",
			[2.0] = "loc_veteran_male_a__combat_pause_circumstance_veteran_a_gas_a_02"
		},
		sound_events_duration = {
			[1.0] = 2.728125,
			[2.0] = 4.073021
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_a__combat_pause_circumstance_veteran_a_gas_b_01",
			[2.0] = "loc_veteran_male_a__combat_pause_circumstance_veteran_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 4.023125,
			[2.0] = 4.190021
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_a__combat_pause_circumstance_zealot_a_gas_b_01",
			[2.0] = "loc_veteran_male_a__combat_pause_circumstance_zealot_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 4.244042,
			[2.0] = 3.793938
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__vent_circumstance_start_b_01",
			"loc_veteran_male_a__vent_circumstance_start_b_02",
			"loc_veteran_male_a__vent_circumstance_start_b_03",
			"loc_veteran_male_a__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			3.190042,
			4.297438,
			2.218604,
			3.490396
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

return settings("circumstance_vo_ventilation_purge_veteran_male_a", circumstance_vo_ventilation_purge_veteran_male_a)
