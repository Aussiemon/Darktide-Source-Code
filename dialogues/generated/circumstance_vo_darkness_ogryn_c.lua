local circumstance_vo_darkness_ogryn_c = {
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__asset_unnatural_dark_b_01",
			[2.0] = "loc_ogryn_c__asset_unnatural_dark_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.470688,
			[2.0] = 4.993167
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	combat_pause_circumstance_unnatural_dark_lurks_b = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_ogryn_c__asset_unnatural_dark_b_02"
		},
		sound_events_duration = {
			[1.0] = 4.993167
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
			"loc_ogryn_c__power_circumstance_start_b_01",
			"loc_ogryn_c__power_circumstance_start_b_02",
			"loc_ogryn_c__power_circumstance_start_b_03",
			"loc_ogryn_c__power_circumstance_start_b_04"
		},
		sound_events_duration = {
			7.048875,
			5.050094,
			3.099125,
			3.611219
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

return settings("circumstance_vo_darkness_ogryn_c", circumstance_vo_darkness_ogryn_c)
