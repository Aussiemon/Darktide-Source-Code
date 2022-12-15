local mission_vo_hm_complex_veteran_female_a = {
	mission_complex_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_a__guidance_starting_area_01",
			"loc_veteran_female_a__guidance_starting_area_02",
			"loc_veteran_female_a__guidance_starting_area_03",
			"loc_veteran_female_a__guidance_starting_area_04",
			"loc_veteran_female_a__guidance_starting_area_05",
			"loc_veteran_female_a__guidance_starting_area_06",
			"loc_veteran_female_a__guidance_starting_area_07",
			"loc_veteran_female_a__guidance_starting_area_08",
			"loc_veteran_female_a__guidance_starting_area_09",
			"loc_veteran_female_a__guidance_starting_area_10"
		},
		sound_events_duration = {
			0.927813,
			2.139771,
			1.870229,
			1.965792,
			1.220688,
			1.388438,
			1.57325,
			1.210625,
			1.97525,
			2.124896
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
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_veteran_female_a__mission_station_end_event_conversation_two_c_02"
		},
		sound_events_duration = {
			[1.0] = 3.656646
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	},
	mission_complex_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_female_a__zone_throneside_01",
			"loc_veteran_female_a__zone_throneside_02",
			"loc_veteran_female_a__zone_throneside_03"
		},
		sound_events_duration = {
			1.582854,
			3.813771,
			2.3715
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
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_a__guidance_correct_path_03",
			[2.0] = "loc_veteran_female_a__guidance_correct_path_07"
		},
		sound_events_duration = {
			[1.0] = 1.188917,
			[2.0] = 0.629729
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_hm_complex_veteran_female_a", mission_vo_hm_complex_veteran_female_a)
