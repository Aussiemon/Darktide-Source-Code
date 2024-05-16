-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_zealot_male_a.lua

local circumstance_vo_ventilation_purge_zealot_male_a = {
	combat_pause_circumstance_ogryn_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_a__combat_pause_circumstance_ogryn_c_gas_b_01",
			[2] = "loc_zealot_male_a__combat_pause_circumstance_ogryn_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.249292,
			[2] = 4.688563,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_a__combat_pause_circumstance_psyker_c_gas_b_01",
			[2] = "loc_zealot_male_a__combat_pause_circumstance_psyker_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 4.354333,
			[2] = 3.203396,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_veteran_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_a__combat_pause_circumstance_veteran_c_gas_b_01",
			[2] = "loc_zealot_male_a__combat_pause_circumstance_veteran_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 2.972854,
			[2] = 4.592667,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_zealot_a_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_a__combat_pause_circumstance_zealot_a_gas_a_01",
			[2] = "loc_zealot_male_a__combat_pause_circumstance_zealot_a_gas_a_02",
		},
		sound_events_duration = {
			[1] = 4.689646,
			[2] = 4.421729,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_zealot_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_a__combat_pause_circumstance_zealot_c_gas_b_01",
			[2] = "loc_zealot_male_a__combat_pause_circumstance_zealot_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 4.925833,
			[2] = 6.362625,
		},
		randomize_indexes = {},
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_a__vent_circumstance_start_b_01",
			"loc_zealot_male_a__vent_circumstance_start_b_02",
			"loc_zealot_male_a__vent_circumstance_start_b_03",
			"loc_zealot_male_a__vent_circumstance_start_b_04",
		},
		sound_events_duration = {
			2.740354,
			3.904458,
			2.915729,
			3.833104,
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

return settings("circumstance_vo_ventilation_purge_zealot_male_a", circumstance_vo_ventilation_purge_zealot_male_a)
