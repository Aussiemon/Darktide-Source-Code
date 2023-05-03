local circumstance_vo_darkness_psyker_male_a = {
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_a__asset_unnatural_dark_b_02",
			[2.0] = "loc_psyker_male_a__asset_unnatural_dark_b_03"
		},
		sound_events_duration = {
			[1.0] = 3.081146,
			[2.0] = 1.875792
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_unnatural_dark_lurks_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_a__asset_unnatural_dark_b_02",
			[2.0] = "loc_psyker_male_a__asset_unnatural_dark_b_03"
		},
		sound_events_duration = {
			[1.0] = 3.081146,
			[2.0] = 1.875792
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	power_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__power_circumstance_start_b_01",
			"loc_psyker_male_a__power_circumstance_start_b_02",
			"loc_psyker_male_a__power_circumstance_start_b_03",
			"loc_psyker_male_a__power_circumstance_start_b_04"
		},
		sound_events_duration = {
			3.590958,
			5.850833,
			4.993271,
			3.841042
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

return settings("circumstance_vo_darkness_psyker_male_a", circumstance_vo_darkness_psyker_male_a)
