-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_zealot_female_b.lua

local circumstance_vo_ventilation_purge_zealot_female_b = {
	combat_pause_circumstance_ogryn_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_b__combat_pause_circumstance_ogryn_a_gas_b_01",
			[2] = "loc_zealot_female_b__combat_pause_circumstance_ogryn_a_gas_b_02"
		},
		sound_events_duration = {
			[1] = 4.051625,
			[2] = 3.840333
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_psyker_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_b__combat_pause_circumstance_psyker_a_gas_b_01",
			[2] = "loc_zealot_female_b__combat_pause_circumstance_psyker_a_gas_b_02"
		},
		sound_events_duration = {
			[1] = 4.743563,
			[2] = 3.71125
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_veteran_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_b__combat_pause_circumstance_veteran_a_gas_b_01",
			[2] = "loc_zealot_female_b__combat_pause_circumstance_veteran_a_gas_b_02"
		},
		sound_events_duration = {
			[1] = 2.627125,
			[2] = 2.843333
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_a_gas_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_b__combat_pause_circumstance_zealot_a_gas_b_01",
			[2] = "loc_zealot_female_b__combat_pause_circumstance_zealot_a_gas_b_02"
		},
		sound_events_duration = {
			[1] = 3.210771,
			[2] = 3.93325
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_zealot_b_gas_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_female_b__combat_pause_circumstance_zealot_b_gas_a_01",
			[2] = "loc_zealot_female_b__combat_pause_circumstance_zealot_b_gas_a_02"
		},
		sound_events_duration = {
			[1] = 4.351313,
			[2] = 4.2335
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_b__vent_circumstance_start_b_01",
			"loc_zealot_female_b__vent_circumstance_start_b_02",
			"loc_zealot_female_b__vent_circumstance_start_b_03",
			"loc_zealot_female_b__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			2.468688,
			3.094729,
			4.250458,
			3.269729
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

return settings("circumstance_vo_ventilation_purge_zealot_female_b", circumstance_vo_ventilation_purge_zealot_female_b)
