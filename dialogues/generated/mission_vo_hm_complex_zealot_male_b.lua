local mission_vo_hm_complex_zealot_male_b = {
	mission_complex_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_male_b__guidance_starting_area_01",
			"loc_zealot_male_b__guidance_starting_area_02",
			"loc_zealot_male_b__guidance_starting_area_03",
			"loc_zealot_male_b__guidance_starting_area_04",
			"loc_zealot_male_b__guidance_starting_area_05",
			"loc_zealot_male_b__guidance_starting_area_06",
			"loc_zealot_male_b__guidance_starting_area_07",
			"loc_zealot_male_b__guidance_starting_area_08",
			"loc_zealot_male_b__guidance_starting_area_09",
			"loc_zealot_male_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			1.607604,
			1.4465,
			3.353021,
			3.354813,
			4.893125,
			4.905875,
			3.656563,
			4.080854,
			4.515563,
			3.091354
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
	mission_complex_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_b__mission_rails_start_banter_a_01",
			[2.0] = "loc_zealot_male_b__mission_rails_start_banter_a_02"
		},
		sound_events_duration = {
			[1.0] = 3.487188,
			[2.0] = 2.570521
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	mission_complex_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_zealot_male_b__zone_throneside_01",
			"loc_zealot_male_b__zone_throneside_02",
			"loc_zealot_male_b__zone_throneside_03"
		},
		sound_events_duration = {
			4.149208,
			5.281729,
			3.825688
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	mission_complex_way_in = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_zealot_male_b__guidance_correct_path_01",
			"loc_zealot_male_b__guidance_correct_path_02",
			"loc_zealot_male_b__guidance_correct_path_07"
		},
		sound_events_duration = {
			0.861938,
			1.249125,
			0.688417
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_hm_complex_zealot_male_b", mission_vo_hm_complex_zealot_male_b)
