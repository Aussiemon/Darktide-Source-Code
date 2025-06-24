-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_ogryn_b.lua

local circumstance_vo_ventilation_purge_ogryn_b = {
	combat_pause_circumstance_ogryn_b_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_b__combat_pause_circumstance_ogryn_b_gas_a_01",
			[2] = "loc_ogryn_b__combat_pause_circumstance_ogryn_b_gas_a_02",
		},
		sound_events_duration = {
			[1] = 3.498646,
			[2] = 6.226708,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_ogryn_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_b__combat_pause_circumstance_ogryn_b_gas_b_01",
			[2] = "loc_ogryn_b__combat_pause_circumstance_ogryn_b_gas_b_02",
		},
		sound_events_duration = {
			[1] = 4.88076,
			[2] = 3.941698,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_psyker_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_b__combat_pause_circumstance_psyker_b_gas_b_01",
			[2] = "loc_ogryn_b__combat_pause_circumstance_psyker_b_gas_b_02",
		},
		sound_events_duration = {
			[1] = 3.4005,
			[2] = 5.250438,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_veteran_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_b__combat_pause_circumstance_veteran_b_gas_b_01",
			[2] = "loc_ogryn_b__combat_pause_circumstance_veteran_b_gas_b_02",
		},
		sound_events_duration = {
			[1] = 4.325646,
			[2] = 3.663969,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_zealot_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_b__combat_pause_circumstance_zealot_b_gas_b_01",
			[2] = "loc_ogryn_b__combat_pause_circumstance_zealot_b_gas_b_02",
		},
		sound_events_duration = {
			[1] = 6.071198,
			[2] = 6.136844,
		},
		randomize_indexes = {},
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__vent_circumstance_start_b_01",
			"loc_ogryn_b__vent_circumstance_start_b_02",
			"loc_ogryn_b__vent_circumstance_start_b_03",
			"loc_ogryn_b__vent_circumstance_start_b_04",
		},
		sound_events_duration = {
			3.817219,
			3.7965,
			5.000583,
			4.78125,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_ventilation_purge_ogryn_b", circumstance_vo_ventilation_purge_ogryn_b)
