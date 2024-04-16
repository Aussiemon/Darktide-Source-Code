local mission_vo_cm_habs_remake_zealot_female_b = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_b__level_hab_block_apartments_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_apartments_02"
		},
		sound_events_duration = {
			[1.0] = 3.205365,
			[2.0] = 5.498458
		},
		randomize_indexes = {}
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_b__level_hab_block_apartments_response_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_apartments_response_02"
		},
		sound_events_duration = {
			[1.0] = 3.746042,
			[2.0] = 3.583729
		},
		randomize_indexes = {}
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_b__level_hab_block_collapse_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_collapse_02"
		},
		sound_events_duration = {
			[1.0] = 1.965563,
			[2.0] = 2.220094
		},
		randomize_indexes = {}
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_b__level_hab_block_corpse_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_corpse_02"
		},
		sound_events_duration = {
			[1.0] = 3.465844,
			[2.0] = 1.830458
		},
		randomize_indexes = {}
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_b__level_hab_block_security_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_security_02"
		},
		sound_events_duration = {
			[1.0] = 5.657865,
			[2.0] = 4.684354
		},
		randomize_indexes = {}
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_female_b__guidance_starting_area_01",
			"loc_zealot_female_b__guidance_starting_area_02",
			"loc_zealot_female_b__guidance_starting_area_03",
			"loc_zealot_female_b__guidance_starting_area_04",
			"loc_zealot_female_b__guidance_starting_area_05",
			"loc_zealot_female_b__guidance_starting_area_06",
			"loc_zealot_female_b__guidance_starting_area_07",
			"loc_zealot_female_b__guidance_starting_area_08",
			"loc_zealot_female_b__guidance_starting_area_09",
			"loc_zealot_female_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			1.610542,
			1.635375,
			3.170229,
			2.595125,
			3.769438,
			4.984063,
			2.656167,
			4.440458,
			3.321958,
			2.848896
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

return settings("mission_vo_cm_habs_remake_zealot_female_b", mission_vo_cm_habs_remake_zealot_female_b)
