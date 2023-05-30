local mission_vo_dm_rise_zealot_male_a = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_male_a__guidance_starting_area_01",
			"loc_zealot_male_a__guidance_starting_area_02",
			"loc_zealot_male_a__guidance_starting_area_03",
			"loc_zealot_male_a__guidance_starting_area_04",
			"loc_zealot_male_a__guidance_starting_area_05",
			"loc_zealot_male_a__guidance_starting_area_06",
			"loc_zealot_male_a__guidance_starting_area_07",
			"loc_zealot_male_a__guidance_starting_area_08",
			"loc_zealot_male_a__guidance_starting_area_09",
			"loc_zealot_male_a__guidance_starting_area_10"
		},
		sound_events_duration = {
			1.120792,
			1.273313,
			1.124146,
			2.188063,
			2.252375,
			1.989813,
			2.571313,
			3.660875,
			2.525271,
			2.869521
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
			"loc_zealot_male_a__event_survive_almost_done_01",
			"loc_zealot_male_a__event_survive_almost_done_02",
			"loc_zealot_male_a__event_survive_almost_done_03",
			"loc_zealot_male_a__event_survive_almost_done_04"
		},
		sound_events_duration = {
			3.764563,
			5.044375,
			4.259948,
			3.584615
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
			"loc_zealot_male_a__region_habculum_01",
			"loc_zealot_male_a__region_habculum_02",
			"loc_zealot_male_a__region_habculum_03"
		},
		sound_events_duration = {
			5.763042,
			11.39183,
			3.9235
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
			"loc_zealot_male_a__zone_transit_01",
			"loc_zealot_male_a__zone_transit_02",
			"loc_zealot_male_a__zone_transit_03"
		},
		sound_events_duration = {
			3.125521,
			2.909563,
			3.736813
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_zealot_male_a", mission_vo_dm_rise_zealot_male_a)
