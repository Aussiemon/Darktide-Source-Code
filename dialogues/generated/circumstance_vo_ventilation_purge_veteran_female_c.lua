local circumstance_vo_ventilation_purge_veteran_female_c = {
	combat_pause_circumstance_ogryn_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_c__combat_pause_circumstance_ogryn_c_gas_b_01",
			[2.0] = "loc_veteran_female_c__combat_pause_circumstance_ogryn_c_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.262594,
			[2.0] = 2.840844
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_c__combat_pause_circumstance_psyker_c_gas_b_01",
			[2.0] = "loc_veteran_female_c__combat_pause_circumstance_psyker_c_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.495635,
			[2.0] = 2.768865
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_c_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_c__combat_pause_circumstance_veteran_c_gas_a_01",
			[2.0] = "loc_veteran_female_c__combat_pause_circumstance_veteran_c_gas_a_02"
		},
		sound_events_duration = {
			[1.0] = 3.113563,
			[2.0] = 3.480333
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_c__combat_pause_circumstance_veteran_c_gas_b_01",
			[2.0] = "loc_veteran_female_c__combat_pause_circumstance_veteran_c_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 2.747677,
			[2.0] = 2.631635
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_c__combat_pause_circumstance_zealot_c_gas_b_01",
			[2.0] = "loc_veteran_female_c__combat_pause_circumstance_zealot_c_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.018927,
			[2.0] = 2.533594
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__vent_circumstance_start_b_01",
			"loc_veteran_female_c__vent_circumstance_start_b_02",
			"loc_veteran_female_c__vent_circumstance_start_b_03",
			"loc_veteran_female_c__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			2.553885,
			2.035833,
			3.240104,
			2.663875
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

return settings("circumstance_vo_ventilation_purge_veteran_female_c", circumstance_vo_ventilation_purge_veteran_female_c)
