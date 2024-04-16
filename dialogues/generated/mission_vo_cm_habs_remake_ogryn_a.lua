local mission_vo_cm_habs_remake_ogryn_a = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_a__level_hab_block_apartments_01",
			[2.0] = "loc_ogryn_a__level_hab_block_apartments_02"
		},
		sound_events_duration = {
			[1.0] = 1.191458,
			[2.0] = 0.692292
		},
		randomize_indexes = {}
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_a__level_hab_block_apartments_response_01",
			[2.0] = "loc_ogryn_a__level_hab_block_apartments_response_02"
		},
		sound_events_duration = {
			[1.0] = 1.748688,
			[2.0] = 1.02724
		},
		randomize_indexes = {}
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_a__level_hab_block_collapse_01",
			[2.0] = "loc_ogryn_a__level_hab_block_collapse_02"
		},
		sound_events_duration = {
			[1.0] = 1.029438,
			[2.0] = 1.046583
		},
		randomize_indexes = {}
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_a__level_hab_block_corpse_01",
			[2.0] = "loc_ogryn_a__level_hab_block_corpse_02"
		},
		sound_events_duration = {
			[1.0] = 1.786896,
			[2.0] = 2.89425
		},
		randomize_indexes = {}
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_a__level_hab_block_security_01",
			[2.0] = "loc_ogryn_a__level_hab_block_security_02"
		},
		sound_events_duration = {
			[1.0] = 2.912917,
			[2.0] = 2.307875
		},
		randomize_indexes = {}
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_a__guidance_starting_area_01",
			"loc_ogryn_a__guidance_starting_area_02",
			"loc_ogryn_a__guidance_starting_area_03",
			"loc_ogryn_a__guidance_starting_area_04",
			"loc_ogryn_a__guidance_starting_area_05",
			"loc_ogryn_a__guidance_starting_area_06",
			"loc_ogryn_a__guidance_starting_area_07",
			"loc_ogryn_a__guidance_starting_area_08",
			"loc_ogryn_a__guidance_starting_area_09",
			"loc_ogryn_a__guidance_starting_area_10"
		},
		sound_events_duration = {
			1.048844,
			1.904646,
			2.28326,
			1.733802,
			2.825177,
			3.4055,
			1.868063,
			2.969396,
			2.054813,
			2.613104
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

return settings("mission_vo_cm_habs_remake_ogryn_a", mission_vo_cm_habs_remake_ogryn_a)
