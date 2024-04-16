local mission_vo_cm_habs_remake_ogryn_c = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__level_hab_block_apartments_01",
			[2.0] = "loc_ogryn_c__level_hab_block_apartments_02"
		},
		sound_events_duration = {
			[1.0] = 4.029563,
			[2.0] = 2.818885
		},
		randomize_indexes = {}
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__level_hab_block_apartments_response_01",
			[2.0] = "loc_ogryn_c__level_hab_block_apartments_response_02"
		},
		sound_events_duration = {
			[1.0] = 1.757073,
			[2.0] = 2.835563
		},
		randomize_indexes = {}
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__level_hab_block_collapse_01",
			[2.0] = "loc_ogryn_c__level_hab_block_collapse_02"
		},
		sound_events_duration = {
			[1.0] = 3.080406,
			[2.0] = 4.033594
		},
		randomize_indexes = {}
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__level_hab_block_corpse_01",
			[2.0] = "loc_ogryn_c__level_hab_block_corpse_02"
		},
		sound_events_duration = {
			[1.0] = 5.095135,
			[2.0] = 4.323792
		},
		randomize_indexes = {}
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__level_hab_block_security_01",
			[2.0] = "loc_ogryn_c__level_hab_block_security_02"
		},
		sound_events_duration = {
			[1.0] = 4.646021,
			[2.0] = 4.385323
		},
		randomize_indexes = {}
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_c__guidance_starting_area_01",
			"loc_ogryn_c__guidance_starting_area_02",
			"loc_ogryn_c__guidance_starting_area_03",
			"loc_ogryn_c__guidance_starting_area_04",
			"loc_ogryn_c__guidance_starting_area_05",
			"loc_ogryn_c__guidance_starting_area_06",
			"loc_ogryn_c__guidance_starting_area_07",
			"loc_ogryn_c__guidance_starting_area_08",
			"loc_ogryn_c__guidance_starting_area_09",
			"loc_ogryn_c__guidance_starting_area_10"
		},
		sound_events_duration = {
			2.687979,
			2.8775,
			3.552531,
			2.388438,
			3.068083,
			4.558521,
			3.969979,
			3.13975,
			3.403104,
			3.747969
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

return settings("mission_vo_cm_habs_remake_ogryn_c", mission_vo_cm_habs_remake_ogryn_c)
