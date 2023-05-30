local mission_vo_cm_archives_zealot_male_b = {
	mission_archives_first_objective_response = {
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
	mission_archives_front_door_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_zealot_male_b__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 3.837792
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	},
	mission_archives_keep_coming_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_b__event_survive_almost_done_01",
			"loc_zealot_male_b__event_survive_almost_done_02",
			"loc_zealot_male_b__event_survive_almost_done_03",
			"loc_zealot_male_b__event_survive_almost_done_04"
		},
		sound_events_duration = {
			2.982063,
			3.71425,
			2.196604,
			3.219458
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	mission_archives_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_b__mission_enforcer_start_banter_a_02",
			[2.0] = "loc_zealot_male_b__region_habculum_01"
		},
		sound_events_duration = {
			[1.0] = 3.256,
			[2.0] = 4.635458
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	mission_archives_start_banter_c = {
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
	}
}

return settings("mission_vo_cm_archives_zealot_male_b", mission_vo_cm_archives_zealot_male_b)
