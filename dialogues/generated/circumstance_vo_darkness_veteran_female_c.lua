local circumstance_vo_darkness_veteran_female_c = {
	combat_pause_circumstance_unnatural_dark_lurks_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_veteran_female_c__asset_unnatural_dark_a_03"
		},
		sound_events_duration = {
			[1.0] = 2.397385
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	},
	power_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__power_circumstance_start_b_01",
			"loc_veteran_female_c__power_circumstance_start_b_02",
			"loc_veteran_female_c__power_circumstance_start_b_03",
			"loc_veteran_female_c__power_circumstance_start_b_04"
		},
		sound_events_duration = {
			2.984125,
			1.855844,
			2.202594,
			1.911615
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

return settings("circumstance_vo_darkness_veteran_female_c", circumstance_vo_darkness_veteran_female_c)
