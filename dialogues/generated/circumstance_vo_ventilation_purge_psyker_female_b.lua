-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_psyker_female_b.lua

local circumstance_vo_ventilation_purge_psyker_female_b = {
	combat_pause_circumstance_ogryn_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_female_b__combat_pause_circumstance_ogryn_c_gas_b_01",
			[2] = "loc_psyker_female_b__combat_pause_circumstance_ogryn_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.631917,
			[2] = 6.667583,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_b_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_female_b__combat_pause_circumstance_psyker_b_gas_a_01",
			[2] = "loc_psyker_female_b__combat_pause_circumstance_psyker_b_gas_a_02",
		},
		sound_events_duration = {
			[1] = 3.091604,
			[2] = 2.930563,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_female_b__combat_pause_circumstance_psyker_c_gas_b_01",
			[2] = "loc_psyker_female_b__combat_pause_circumstance_psyker_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 4.238188,
			[2] = 4.039,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_veteran_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_female_b__combat_pause_circumstance_veteran_c_gas_b_01",
			[2] = "loc_psyker_female_b__combat_pause_circumstance_veteran_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.764271,
			[2] = 7.054125,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_zealot_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_female_b__combat_pause_circumstance_zealot_c_gas_b_01",
			[2] = "loc_psyker_female_b__combat_pause_circumstance_zealot_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 4.597875,
			[2] = 6.507146,
		},
		randomize_indexes = {},
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__vent_circumstance_start_b_01",
			"loc_psyker_female_b__vent_circumstance_start_b_02",
			"loc_psyker_female_b__vent_circumstance_start_b_03",
			"loc_psyker_female_b__vent_circumstance_start_b_04",
		},
		sound_events_duration = {
			4.922646,
			4.238229,
			7.334917,
			2.308521,
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

return settings("circumstance_vo_ventilation_purge_psyker_female_b", circumstance_vo_ventilation_purge_psyker_female_b)
