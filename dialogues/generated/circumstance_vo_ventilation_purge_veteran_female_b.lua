-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_veteran_female_b.lua

local circumstance_vo_ventilation_purge_veteran_female_b = {
	combat_pause_circumstance_ogryn_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__combat_pause_circumstance_ogryn_b_gas_b_01",
			[2] = "loc_veteran_female_b__combat_pause_circumstance_ogryn_b_gas_b_02"
		},
		sound_events_duration = {
			[1] = 4.727771,
			[2] = 3.165104
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__combat_pause_circumstance_psyker_b_gas_b_01",
			[2] = "loc_veteran_female_b__combat_pause_circumstance_psyker_b_gas_b_02"
		},
		sound_events_duration = {
			[1] = 3.499875,
			[2] = 4.74425
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_b_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__combat_pause_circumstance_veteran_b_gas_a_01",
			[2] = "loc_veteran_female_b__combat_pause_circumstance_veteran_b_gas_a_02"
		},
		sound_events_duration = {
			[1] = 2.307896,
			[2] = 3.343792
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__combat_pause_circumstance_veteran_b_gas_b_01",
			[2] = "loc_veteran_female_b__combat_pause_circumstance_veteran_b_gas_b_02"
		},
		sound_events_duration = {
			[1] = 4.381083,
			[2] = 2.723104
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_b_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__combat_pause_circumstance_zealot_b_gas_b_01",
			[2] = "loc_veteran_female_b__combat_pause_circumstance_zealot_b_gas_b_02"
		},
		sound_events_duration = {
			[1] = 5.345792,
			[2] = 4.580167
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_b__vent_circumstance_start_b_01",
			"loc_veteran_female_b__vent_circumstance_start_b_02",
			"loc_veteran_female_b__vent_circumstance_start_b_03",
			"loc_veteran_female_b__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			2.443375,
			3.286771,
			2.18625,
			4.32
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

return settings("circumstance_vo_ventilation_purge_veteran_female_b", circumstance_vo_ventilation_purge_veteran_female_b)
