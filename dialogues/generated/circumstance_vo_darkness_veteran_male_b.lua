local circumstance_vo_darkness_veteran_male_b = {
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_male_b__asset_unnatural_dark_b_01",
			"loc_veteran_male_b__asset_unnatural_dark_b_02",
			"loc_veteran_male_b__asset_unnatural_dark_b_04"
		},
		sound_events_duration = {
			2.602167,
			1.888688,
			2.298125
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_unnatural_dark_lurks_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_b__asset_unnatural_dark_b_01",
			[2.0] = "loc_veteran_male_b__asset_unnatural_dark_b_04"
		},
		sound_events_duration = {
			[1.0] = 2.602167,
			[2.0] = 2.298125
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	}
}

return settings("circumstance_vo_darkness_veteran_male_b", circumstance_vo_darkness_veteran_male_b)
