local mission_vo_dm_rise_veteran_male_a = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_male_a__guidance_starting_area_01",
			"loc_veteran_male_a__guidance_starting_area_02",
			"loc_veteran_male_a__guidance_starting_area_03",
			"loc_veteran_male_a__guidance_starting_area_04",
			"loc_veteran_male_a__guidance_starting_area_05",
			"loc_veteran_male_a__guidance_starting_area_06",
			"loc_veteran_male_a__guidance_starting_area_07",
			"loc_veteran_male_a__guidance_starting_area_08",
			"loc_veteran_male_a__guidance_starting_area_09",
			"loc_veteran_male_a__guidance_starting_area_10"
		},
		sound_events_duration = {
			0.989729,
			1.379813,
			1.616938,
			2.092104,
			1.403833,
			1.059667,
			1.590104,
			1.172583,
			2.136979,
			1.585292
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
			"loc_veteran_male_a__event_survive_almost_done_01",
			"loc_veteran_male_a__event_survive_almost_done_02",
			"loc_veteran_male_a__event_survive_almost_done_03",
			"loc_veteran_male_a__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.258396,
			2.39925,
			0.9765,
			3.218917
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
			"loc_veteran_male_a__region_habculum_01",
			"loc_veteran_male_a__region_habculum_02",
			"loc_veteran_male_a__region_habculum_03"
		},
		sound_events_duration = {
			5.870667,
			4.34875,
			4.6865
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
			"loc_veteran_male_a__zone_transit_01",
			"loc_veteran_male_a__zone_transit_02",
			"loc_veteran_male_a__zone_transit_03"
		},
		sound_events_duration = {
			2.078854,
			2.180833,
			2.962875
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_veteran_male_a", mission_vo_dm_rise_veteran_male_a)
