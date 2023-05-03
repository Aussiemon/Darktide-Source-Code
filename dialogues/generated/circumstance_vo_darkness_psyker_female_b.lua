local circumstance_vo_darkness_psyker_female_b = {
	combat_pause_circumstance_unnatural_dark_lights_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_b__asset_unnatural_dark_a_03",
			[2.0] = "loc_psyker_female_b__asset_unnatural_dark_a_04"
		},
		sound_events_duration = {
			[1.0] = 2.495917,
			[2.0] = 3.234229
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__asset_unnatural_dark_b_01",
			"loc_psyker_female_b__asset_unnatural_dark_b_02",
			"loc_psyker_female_b__asset_unnatural_dark_b_03",
			"loc_psyker_female_b__asset_unnatural_dark_b_04"
		},
		sound_events_duration = {
			2.703458,
			3.100938,
			4.28625,
			4.429063
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_unnatural_dark_lurks_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_female_b__asset_unnatural_dark_b_02",
			"loc_psyker_female_b__asset_unnatural_dark_b_03",
			"loc_psyker_female_b__asset_unnatural_dark_b_04"
		},
		sound_events_duration = {
			3.100938,
			4.28625,
			4.429063
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	power_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__power_circumstance_start_b_01",
			"loc_psyker_female_b__power_circumstance_start_b_02",
			"loc_psyker_female_b__power_circumstance_start_b_03",
			"loc_psyker_female_b__power_circumstance_start_b_04"
		},
		sound_events_duration = {
			2.891604,
			3.928333,
			3.666458,
			4.753604
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

return settings("circumstance_vo_darkness_psyker_female_b", circumstance_vo_darkness_psyker_female_b)
