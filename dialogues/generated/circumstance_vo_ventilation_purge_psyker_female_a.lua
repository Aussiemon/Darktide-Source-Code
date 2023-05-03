local circumstance_vo_ventilation_purge_psyker_female_a = {
	combat_pause_circumstance_ogryn_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_a__combat_pause_circumstance_ogryn_b_gas_b_01",
			[2.0] = "loc_psyker_female_a__combat_pause_circumstance_ogryn_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.516271,
			[2.0] = 4.398229
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_a_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_a__combat_pause_circumstance_psyker_a_gas_a_01",
			[2.0] = "loc_psyker_female_a__combat_pause_circumstance_psyker_a_gas_a_02"
		},
		sound_events_duration = {
			[1.0] = 3.090188,
			[2.0] = 5.459917
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_a__combat_pause_circumstance_psyker_b_gas_b_01",
			[2.0] = "loc_psyker_female_a__combat_pause_circumstance_psyker_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 4.365021,
			[2.0] = 4.787938
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_a__combat_pause_circumstance_veteran_b_gas_b_01",
			[2.0] = "loc_psyker_female_a__combat_pause_circumstance_veteran_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.322938,
			[2.0] = 3.933979
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_a__combat_pause_circumstance_zealot_b_gas_b_01",
			[2.0] = "loc_psyker_female_a__combat_pause_circumstance_zealot_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 6.448771,
			[2.0] = 7.311438
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__vent_circumstance_start_b_01",
			"loc_psyker_female_a__vent_circumstance_start_b_02",
			"loc_psyker_female_a__vent_circumstance_start_b_03",
			"loc_psyker_female_a__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			2.534313,
			4.149396,
			4.066458,
			3.461646
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

return settings("circumstance_vo_ventilation_purge_psyker_female_a", circumstance_vo_ventilation_purge_psyker_female_a)
