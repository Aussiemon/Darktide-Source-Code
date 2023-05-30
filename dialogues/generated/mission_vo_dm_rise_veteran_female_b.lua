local mission_vo_dm_rise_veteran_female_b = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_b__guidance_starting_area_01",
			"loc_veteran_female_b__guidance_starting_area_02",
			"loc_veteran_female_b__guidance_starting_area_03",
			"loc_veteran_female_b__guidance_starting_area_04",
			"loc_veteran_female_b__guidance_starting_area_05",
			"loc_veteran_female_b__guidance_starting_area_06",
			"loc_veteran_female_b__guidance_starting_area_07",
			"loc_veteran_female_b__guidance_starting_area_08",
			"loc_veteran_female_b__guidance_starting_area_09",
			"loc_veteran_female_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			2.784021,
			2.841854,
			3.674688,
			1.663688,
			1.961104,
			2.023521,
			2.891542,
			2.573583,
			3.490271,
			2.443458
		},
		sound_event_weights = {
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1
		},
		randomize_indexes = {}
	},
	mission_rise_keep_coming_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_b__event_survive_almost_done_01",
			"loc_veteran_female_b__event_survive_almost_done_02",
			"loc_veteran_female_b__event_survive_almost_done_03",
			"loc_veteran_female_b__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.836344,
			1.29075,
			1.568052,
			2.429
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	mission_rise_start_b_sergeant_branch = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_female_b__region_habculum_01",
			"loc_veteran_female_b__region_habculum_02",
			"loc_veteran_female_b__region_habculum_03"
		},
		sound_events_duration = {
			9.154917,
			6.161458,
			3.807
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	mission_rise_start_b_sergeant_branch_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_female_b__zone_transit_01",
			"loc_veteran_female_b__zone_transit_02",
			"loc_veteran_female_b__zone_transit_03"
		},
		sound_events_duration = {
			3.641792,
			4.692521,
			3.108938
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_veteran_female_b", mission_vo_dm_rise_veteran_female_b)
