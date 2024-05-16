-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_psyker_male_a.lua

local circumstance_vo_ventilation_purge_psyker_male_a = {
	combat_pause_circumstance_ogryn_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_a__combat_pause_circumstance_ogryn_b_gas_b_01",
			[2] = "loc_psyker_male_a__combat_pause_circumstance_ogryn_b_gas_b_02",
		},
		sound_events_duration = {
			[1] = 4.597875,
			[2] = 5.277917,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_a_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_a__combat_pause_circumstance_psyker_a_gas_a_01",
			[2] = "loc_psyker_male_a__combat_pause_circumstance_psyker_a_gas_a_02",
		},
		sound_events_duration = {
			[1] = 3.883646,
			[2] = 5.43875,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_a__combat_pause_circumstance_psyker_b_gas_b_01",
			[2] = "loc_psyker_male_a__combat_pause_circumstance_psyker_b_gas_b_02",
		},
		sound_events_duration = {
			[1] = 5.682042,
			[2] = 5.398729,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_veteran_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_a__combat_pause_circumstance_veteran_b_gas_b_01",
			[2] = "loc_psyker_male_a__combat_pause_circumstance_veteran_b_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.194667,
			[2] = 3.859958,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_zealot_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_a__combat_pause_circumstance_zealot_b_gas_b_01",
			[2] = "loc_psyker_male_a__combat_pause_circumstance_zealot_b_gas_b_02",
		},
		sound_events_duration = {
			[1] = 7.277688,
			[2] = 7.314646,
		},
		randomize_indexes = {},
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__vent_circumstance_start_b_01",
			"loc_psyker_male_a__vent_circumstance_start_b_02",
			"loc_psyker_male_a__vent_circumstance_start_b_03",
			"loc_psyker_male_a__vent_circumstance_start_b_04",
		},
		sound_events_duration = {
			2.698208,
			5.10975,
			4.143708,
			4.073188,
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

return settings("circumstance_vo_ventilation_purge_psyker_male_a", circumstance_vo_ventilation_purge_psyker_male_a)
