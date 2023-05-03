local circumstance_vo_ventilation_purge_zealot_female_c = {
	combat_pause_circumstance_ogryn_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_c__combat_pause_circumstance_ogryn_b_gas_b_01",
			[2.0] = "loc_zealot_female_c__combat_pause_circumstance_ogryn_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 2.855271,
			[2.0] = 3.905052
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_c__combat_pause_circumstance_psyker_b_gas_b_01",
			[2.0] = "loc_zealot_female_c__combat_pause_circumstance_psyker_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 4.270427,
			[2.0] = 3.395063
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_c__combat_pause_circumstance_veteran_b_gas_b_01",
			[2.0] = "loc_zealot_female_c__combat_pause_circumstance_veteran_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 4.367427,
			[2.0] = 5.402229
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_c__combat_pause_circumstance_zealot_b_gas_b_01",
			[2.0] = "loc_zealot_female_c__combat_pause_circumstance_zealot_b_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 5.028635,
			[2.0] = 3.312167
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_c_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_c__combat_pause_circumstance_zealot_c_gas_a_01",
			[2.0] = "loc_zealot_female_c__combat_pause_circumstance_zealot_c_gas_a_02"
		},
		sound_events_duration = {
			[1.0] = 5.664469,
			[2.0] = 3.96774
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_c__vent_circumstance_start_b_01",
			"loc_zealot_female_c__vent_circumstance_start_b_02",
			"loc_zealot_female_c__vent_circumstance_start_b_03",
			"loc_zealot_female_c__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			3.338688,
			2.352406,
			3.314771,
			3.25424
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

return settings("circumstance_vo_ventilation_purge_zealot_female_c", circumstance_vo_ventilation_purge_zealot_female_c)
