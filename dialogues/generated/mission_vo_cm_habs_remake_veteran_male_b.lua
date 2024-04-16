local mission_vo_cm_habs_remake_veteran_male_b = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_b__level_hab_block_apartments_01",
			[2.0] = "loc_veteran_male_b__level_hab_block_apartments_02"
		},
		sound_events_duration = {
			[1.0] = 2.677021,
			[2.0] = 3.284813
		},
		randomize_indexes = {}
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_b__level_hab_block_apartments_response_01",
			[2.0] = "loc_veteran_male_b__level_hab_block_apartments_response_02"
		},
		sound_events_duration = {
			[1.0] = 5.120292,
			[2.0] = 3.098104
		},
		randomize_indexes = {}
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_b__level_hab_block_collapse_01",
			[2.0] = "loc_veteran_male_b__level_hab_block_collapse_02"
		},
		sound_events_duration = {
			[1.0] = 1.759979,
			[2.0] = 1.435354
		},
		randomize_indexes = {}
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_b__level_hab_block_corpse_01",
			[2.0] = "loc_veteran_male_b__level_hab_block_corpse_02"
		},
		sound_events_duration = {
			[1.0] = 2.818083,
			[2.0] = 3.958167
		},
		randomize_indexes = {}
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_b__level_hab_block_security_01",
			[2.0] = "loc_veteran_male_b__level_hab_block_security_02"
		},
		sound_events_duration = {
			[1.0] = 5.056833,
			[2.0] = 5.231167
		},
		randomize_indexes = {}
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_male_b__guidance_starting_area_01",
			"loc_veteran_male_b__guidance_starting_area_02",
			"loc_veteran_male_b__guidance_starting_area_03",
			"loc_veteran_male_b__guidance_starting_area_04",
			"loc_veteran_male_b__guidance_starting_area_05",
			"loc_veteran_male_b__guidance_starting_area_06",
			"loc_veteran_male_b__guidance_starting_area_07",
			"loc_veteran_male_b__guidance_starting_area_08",
			"loc_veteran_male_b__guidance_starting_area_09",
			"loc_veteran_male_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			2.807333,
			3.393708,
			4.216229,
			1.783667,
			2.353729,
			1.99775,
			2.877917,
			2.221354,
			2.726938,
			3.0765
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
	}
}

return settings("mission_vo_cm_habs_remake_veteran_male_b", mission_vo_cm_habs_remake_veteran_male_b)
