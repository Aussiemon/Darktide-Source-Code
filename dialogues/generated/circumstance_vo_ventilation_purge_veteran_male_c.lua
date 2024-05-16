-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_veteran_male_c.lua

local circumstance_vo_ventilation_purge_veteran_male_c = {
	combat_pause_circumstance_ogryn_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_c__combat_pause_circumstance_ogryn_c_gas_b_01",
			[2] = "loc_veteran_male_c__combat_pause_circumstance_ogryn_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.158979,
			[2] = 2.740646,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_c__combat_pause_circumstance_psyker_c_gas_b_01",
			[2] = "loc_veteran_male_c__combat_pause_circumstance_psyker_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.905031,
			[2] = 2.5505,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_veteran_c_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_c__combat_pause_circumstance_veteran_c_gas_a_01",
			[2] = "loc_veteran_male_c__combat_pause_circumstance_veteran_c_gas_a_02",
		},
		sound_events_duration = {
			[1] = 3.436594,
			[2] = 4.079365,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_veteran_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_c__combat_pause_circumstance_veteran_c_gas_b_01",
			[2] = "loc_veteran_male_c__combat_pause_circumstance_veteran_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 2.885156,
			[2] = 2.096177,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_zealot_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_c__combat_pause_circumstance_zealot_c_gas_b_01",
			[2] = "loc_veteran_male_c__combat_pause_circumstance_zealot_c_gas_b_02",
		},
		sound_events_duration = {
			[1] = 2.766,
			[2] = 2.968083,
		},
		randomize_indexes = {},
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__vent_circumstance_start_b_01",
			"loc_veteran_male_c__vent_circumstance_start_b_02",
			"loc_veteran_male_c__vent_circumstance_start_b_03",
			"loc_veteran_male_c__vent_circumstance_start_b_04",
		},
		sound_events_duration = {
			2.946115,
			2.36874,
			2.774615,
			2.919521,
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

return settings("circumstance_vo_ventilation_purge_veteran_male_c", circumstance_vo_ventilation_purge_veteran_male_c)
