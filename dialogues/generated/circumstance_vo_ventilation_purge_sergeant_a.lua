-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_sergeant_a.lua

local circumstance_vo_ventilation_purge_sergeant_a = {
	vent_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__vent_circumstance_start_a_01",
			"loc_sergeant_a__vent_circumstance_start_a_02",
			"loc_sergeant_a__vent_circumstance_start_a_03",
			"loc_sergeant_a__vent_circumstance_start_a_04",
		},
		sound_events_duration = {
			5.551729,
			6.856875,
			4.648917,
			6.51725,
		},
		randomize_indexes = {},
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__vent_circumstance_start_b_01",
			"loc_sergeant_a__vent_circumstance_start_b_02",
			"loc_sergeant_a__vent_circumstance_start_b_03",
			"loc_sergeant_a__vent_circumstance_start_b_04",
		},
		sound_events_duration = {
			3.208917,
			3.231896,
			3.909167,
			3.786229,
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

return settings("circumstance_vo_ventilation_purge_sergeant_a", circumstance_vo_ventilation_purge_sergeant_a)
