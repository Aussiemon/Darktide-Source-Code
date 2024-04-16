local mission_vo_cm_habs_remake_zealot_male_b = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_b__level_hab_block_apartments_01",
			[2.0] = "loc_zealot_male_b__level_hab_block_apartments_02"
		},
		sound_events_duration = {
			[1.0] = 4.27625,
			[2.0] = 4.489354
		},
		randomize_indexes = {}
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_b__level_hab_block_apartments_response_01",
			[2.0] = "loc_zealot_male_b__level_hab_block_apartments_response_02"
		},
		sound_events_duration = {
			[1.0] = 3.378354,
			[2.0] = 4.590229
		},
		randomize_indexes = {}
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_b__level_hab_block_collapse_01",
			[2.0] = "loc_zealot_male_b__level_hab_block_collapse_02"
		},
		sound_events_duration = {
			[1.0] = 1.663208,
			[2.0] = 2.407188
		},
		randomize_indexes = {}
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_b__level_hab_block_corpse_01",
			[2.0] = "loc_zealot_male_b__level_hab_block_corpse_02"
		},
		sound_events_duration = {
			[1.0] = 3.931625,
			[2.0] = 1.889458
		},
		randomize_indexes = {}
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_b__level_hab_block_security_01",
			[2.0] = "loc_zealot_male_b__level_hab_block_security_02"
		},
		sound_events_duration = {
			[1.0] = 5.607708,
			[2.0] = 3.793146
		},
		randomize_indexes = {}
	},
	mission_habs_redux_start_zone_response = {
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
	}
}

return settings("mission_vo_cm_habs_remake_zealot_male_b", mission_vo_cm_habs_remake_zealot_male_b)
