-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_psyker_male_b.lua

local circumstance_vo_ventilation_purge_psyker_male_b = {
	combat_pause_circumstance_ogryn_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__combat_pause_circumstance_ogryn_c_gas_b_01",
			[2] = "loc_psyker_male_b__combat_pause_circumstance_ogryn_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.472333,
			[2] = 4.998542,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_b_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__combat_pause_circumstance_psyker_b_gas_a_01",
			[2] = "loc_psyker_male_b__combat_pause_circumstance_psyker_b_gas_a_02",
		},
		sound_events_duration = {
			[1] = 2.445896,
			[2] = 2.331438,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__combat_pause_circumstance_psyker_c_gas_b_01",
			[2] = "loc_psyker_male_b__combat_pause_circumstance_psyker_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.058917,
			[2] = 2.990917,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_veteran_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__combat_pause_circumstance_veteran_c_gas_b_01",
			[2] = "loc_psyker_male_b__combat_pause_circumstance_veteran_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 2.809104,
			[2] = 5.114063,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_zealot_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__combat_pause_circumstance_zealot_c_gas_b_01",
			[2] = "loc_psyker_male_b__combat_pause_circumstance_zealot_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 2.346167,
			[2] = 5.287125,
		},
		randomize_indexes = {},
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__vent_circumstance_start_b_01",
			"loc_psyker_male_b__vent_circumstance_start_b_02",
			"loc_psyker_male_b__vent_circumstance_start_b_03",
			"loc_psyker_male_b__vent_circumstance_start_b_04",
		},
		sound_events_duration = {
			4.397521,
			8.697104,
			6.671021,
			2.477292,
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

return settings("circumstance_vo_ventilation_purge_psyker_male_b", circumstance_vo_ventilation_purge_psyker_male_b)
