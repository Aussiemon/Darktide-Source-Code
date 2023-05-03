local circumstance_vo_ventilation_purge_zealot_male_c = {
	combat_pause_circumstance_ogryn_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_c__combat_pause_circumstance_ogryn_b_gas_b_01",
			[2.0] = "loc_zealot_male_c__combat_pause_circumstance_ogryn_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.680031,
			[2.0] = 4.056792
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_c__combat_pause_circumstance_psyker_b_gas_b_01",
			[2.0] = "loc_zealot_male_c__combat_pause_circumstance_psyker_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 5.004823,
			[2.0] = 3.811458
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_c__combat_pause_circumstance_veteran_b_gas_b_01",
			[2.0] = "loc_zealot_male_c__combat_pause_circumstance_veteran_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 5.056094,
			[2.0] = 6.292063
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_c__combat_pause_circumstance_zealot_b_gas_b_01",
			[2.0] = "loc_zealot_male_c__combat_pause_circumstance_zealot_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 5.98926,
			[2.0] = 2.812594
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_c_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_c__combat_pause_circumstance_zealot_c_gas_a_01",
			[2.0] = "loc_zealot_male_c__combat_pause_circumstance_zealot_c_gas_a_02"
		},
		sound_events_duration = {
			[1.0] = 5.858406,
			[2.0] = 3.685292
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__vent_circumstance_start_b_01",
			"loc_zealot_male_c__vent_circumstance_start_b_02",
			"loc_zealot_male_c__vent_circumstance_start_b_03",
			"loc_zealot_male_c__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			4.063365,
			2.927958,
			2.865896,
			2.734469
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

return settings("circumstance_vo_ventilation_purge_zealot_male_c", circumstance_vo_ventilation_purge_zealot_male_c)
