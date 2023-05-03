local circumstance_vo_ventilation_purge_psyker_male_c = {
	combat_pause_circumstance_ogryn_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__combat_pause_circumstance_ogryn_a_gas_b_01",
			[2.0] = "loc_psyker_male_c__combat_pause_circumstance_ogryn_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 5.497958,
			[2.0] = 4.85825
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__combat_pause_circumstance_psyker_a_gas_b_01",
			[2.0] = "loc_psyker_male_c__combat_pause_circumstance_psyker_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 4.336531,
			[2.0] = 4.5765
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_c_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__combat_pause_circumstance_psyker_c_gas_a_01",
			[2.0] = "loc_psyker_male_c__combat_pause_circumstance_psyker_c_gas_a_02"
		},
		sound_events_duration = {
			[1.0] = 3.11076,
			[2.0] = 2.907229
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__combat_pause_circumstance_veteran_a_gas_b_01",
			[2.0] = "loc_psyker_male_c__combat_pause_circumstance_veteran_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.984823,
			[2.0] = 3.676781
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__combat_pause_circumstance_zealot_a_gas_b_01",
			[2.0] = "loc_psyker_male_c__combat_pause_circumstance_zealot_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.563115,
			[2.0] = 2.984333
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__vent_circumstance_start_b_01",
			"loc_psyker_male_c__vent_circumstance_start_b_02",
			"loc_psyker_male_c__vent_circumstance_start_b_03",
			"loc_psyker_male_c__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			2.315115,
			4.106563,
			1.423802,
			4.122979
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

return settings("circumstance_vo_ventilation_purge_psyker_male_c", circumstance_vo_ventilation_purge_psyker_male_c)
