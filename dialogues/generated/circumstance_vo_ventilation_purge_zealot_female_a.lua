-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_zealot_female_a.lua

local circumstance_vo_ventilation_purge_zealot_female_a = {
	combat_pause_circumstance_ogryn_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_a__combat_pause_circumstance_ogryn_c_gas_b_01",
			[2] = "loc_zealot_female_a__combat_pause_circumstance_ogryn_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 2.934938,
			[2] = 3.856917,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_a__combat_pause_circumstance_psyker_c_gas_b_01",
			[2] = "loc_zealot_female_a__combat_pause_circumstance_psyker_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 4.544563,
			[2] = 3.700375,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_veteran_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_a__combat_pause_circumstance_veteran_c_gas_b_01",
			[2] = "loc_zealot_female_a__combat_pause_circumstance_veteran_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.122875,
			[2] = 3.785708,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_zealot_a_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_a__combat_pause_circumstance_zealot_a_gas_a_01",
			[2] = "loc_zealot_female_a__combat_pause_circumstance_zealot_a_gas_a_02",
		},
		sound_events_duration = {
			[1] = 4.051479,
			[2] = 3.517833,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_zealot_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_a__combat_pause_circumstance_zealot_c_gas_b_01",
			[2] = "loc_zealot_female_a__combat_pause_circumstance_zealot_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 4.116375,
			[2] = 6.092604,
		},
		randomize_indexes = {},
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__vent_circumstance_start_b_01",
			"loc_zealot_female_a__vent_circumstance_start_b_02",
			"loc_zealot_female_a__vent_circumstance_start_b_03",
			"loc_zealot_female_a__vent_circumstance_start_b_04",
		},
		sound_events_duration = {
			2.658,
			3.122708,
			3.430208,
			3.877146,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_ventilation_purge_zealot_female_a", circumstance_vo_ventilation_purge_zealot_female_a)
