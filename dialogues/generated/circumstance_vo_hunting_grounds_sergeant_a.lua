-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_sergeant_a.lua

local circumstance_vo_hunting_grounds_sergeant_a = {
	hunting_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_sergeant_a__hunting_circumstance_start_a_01",
			"loc_sergeant_a__hunting_circumstance_start_a_02",
			"loc_sergeant_a__hunting_circumstance_start_a_03",
		},
		sound_events_duration = {
			5.447354,
			5.192354,
			4.920771,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	hunting_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__hunting_circumstance_start_b_01",
			"loc_sergeant_a__hunting_circumstance_start_b_02",
			"loc_sergeant_a__hunting_circumstance_start_b_03",
			"loc_sergeant_a__hunting_circumstance_start_b_04",
		},
		sound_events_duration = {
			2.998917,
			3.258625,
			3.677104,
			3.727313,
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

return settings("circumstance_vo_hunting_grounds_sergeant_a", circumstance_vo_hunting_grounds_sergeant_a)
