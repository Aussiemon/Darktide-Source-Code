local circumstance_vo_ventilation_purge_psyker_female_c = {
	combat_pause_circumstance_ogryn_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_c__combat_pause_circumstance_ogryn_a_gas_b_01",
			[2.0] = "loc_psyker_female_c__combat_pause_circumstance_ogryn_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 5.117313,
			[2.0] = 4.695688
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_c__combat_pause_circumstance_psyker_a_gas_b_01",
			[2.0] = "loc_psyker_female_c__combat_pause_circumstance_psyker_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 4.465063,
			[2.0] = 4.611906
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_c_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_c__combat_pause_circumstance_psyker_c_gas_a_01",
			[2.0] = "loc_psyker_female_c__combat_pause_circumstance_psyker_c_gas_a_02"
		},
		sound_events_duration = {
			[1.0] = 3.511573,
			[2.0] = 3.066677
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_c__combat_pause_circumstance_veteran_a_gas_b_01",
			[2.0] = "loc_psyker_female_c__combat_pause_circumstance_veteran_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.424198,
			[2.0] = 3.704542
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_c__combat_pause_circumstance_zealot_a_gas_b_01",
			[2.0] = "loc_psyker_female_c__combat_pause_circumstance_zealot_a_gas_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.469021,
			[2.0] = 3.552906
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_c__vent_circumstance_start_b_01",
			"loc_psyker_female_c__vent_circumstance_start_b_02",
			"loc_psyker_female_c__vent_circumstance_start_b_03",
			"loc_psyker_female_c__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			2.706135,
			3.821792,
			1.783146,
			4.96251
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

return settings("circumstance_vo_ventilation_purge_psyker_female_c", circumstance_vo_ventilation_purge_psyker_female_c)
