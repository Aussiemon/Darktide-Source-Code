local mission_vo_dm_rise_psyker_male_b = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_b__guidance_starting_area_01",
			"loc_psyker_male_b__guidance_starting_area_02",
			"loc_psyker_male_b__guidance_starting_area_03",
			"loc_psyker_male_b__guidance_starting_area_04",
			"loc_psyker_male_b__guidance_starting_area_05",
			"loc_psyker_male_b__guidance_starting_area_06",
			"loc_psyker_male_b__guidance_starting_area_07",
			"loc_psyker_male_b__guidance_starting_area_08",
			"loc_psyker_male_b__guidance_starting_area_09",
			"loc_psyker_male_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			1.998167,
			1.853771,
			2.238729,
			1.286896,
			1.377813,
			2.572667,
			3.0755,
			2.197708,
			2.287354,
			2.922938
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
			"loc_psyker_male_b__event_survive_almost_done_01",
			"loc_psyker_male_b__event_survive_almost_done_02",
			"loc_psyker_male_b__event_survive_almost_done_03",
			"loc_psyker_male_b__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.215271,
			1.707833,
			1.919292,
			2.232813
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
			"loc_psyker_male_b__region_habculum_01",
			"loc_psyker_male_b__region_habculum_02",
			"loc_psyker_male_b__region_habculum_03"
		},
		sound_events_duration = {
			5.513708,
			6.412979,
			1.909729
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
			"loc_psyker_male_b__zone_transit_01",
			"loc_psyker_male_b__zone_transit_02",
			"loc_psyker_male_b__zone_transit_03"
		},
		sound_events_duration = {
			3.250042,
			3.759708,
			3.257458
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_psyker_male_b", mission_vo_dm_rise_psyker_male_b)
