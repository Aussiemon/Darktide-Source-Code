-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_ogryn_c.lua

local circumstance_vo_ventilation_purge_ogryn_c = {
	combat_pause_circumstance_ogryn_c_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_c__combat_pause_circumstance_ogryn_c_gas_a_01",
			[2] = "loc_ogryn_c__combat_pause_circumstance_ogryn_c_gas_a_02"
		},
		sound_events_duration = {
			[1] = 2.770865,
			[2] = 3.69225
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_ogryn_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_c__combat_pause_circumstance_ogryn_c_gas_b_01",
			[2] = "loc_ogryn_c__combat_pause_circumstance_ogryn_c_gas_b_02"
		},
		sound_events_duration = {
			[1] = 4.134292,
			[2] = 5.337094
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_c__combat_pause_circumstance_psyker_c_gas_b_01",
			[2] = "loc_ogryn_c__combat_pause_circumstance_psyker_c_gas_b_02"
		},
		sound_events_duration = {
			[1] = 2.949698,
			[2] = 6.607719
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_c__combat_pause_circumstance_veteran_c_gas_b_01",
			[2] = "loc_ogryn_c__combat_pause_circumstance_veteran_c_gas_b_02"
		},
		sound_events_duration = {
			[1] = 2.217875,
			[2] = 4.931427
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_c_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_c__combat_pause_circumstance_zealot_c_gas_b_01",
			[2] = "loc_ogryn_c__combat_pause_circumstance_zealot_c_gas_b_02"
		},
		sound_events_duration = {
			[1] = 2.500885,
			[2] = 4.527979
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__vent_circumstance_start_b_01",
			"loc_ogryn_c__vent_circumstance_start_b_02",
			"loc_ogryn_c__vent_circumstance_start_b_03",
			"loc_ogryn_c__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			4.714021,
			5.860438,
			3.088594,
			3.746292
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

return settings("circumstance_vo_ventilation_purge_ogryn_c", circumstance_vo_ventilation_purge_ogryn_c)
