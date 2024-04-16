local mission_vo_cm_habs_remake_psyker_female_b = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_b__level_hab_block_apartments_01",
			[2.0] = "loc_psyker_female_b__level_hab_block_apartments_02"
		},
		sound_events_duration = {
			[1.0] = 3.147333,
			[2.0] = 3.546979
		},
		randomize_indexes = {}
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_b__level_hab_block_apartments_response_01",
			[2.0] = "loc_psyker_female_b__level_hab_block_apartments_response_02"
		},
		sound_events_duration = {
			[1.0] = 2.375917,
			[2.0] = 3.708813
		},
		randomize_indexes = {}
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_b__level_hab_block_collapse_01",
			[2.0] = "loc_psyker_female_b__level_hab_block_collapse_02"
		},
		sound_events_duration = {
			[1.0] = 2.053104,
			[2.0] = 1.934583
		},
		randomize_indexes = {}
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_b__level_hab_block_corpse_01",
			[2.0] = "loc_psyker_female_b__level_hab_block_corpse_02"
		},
		sound_events_duration = {
			[1.0] = 2.244292,
			[2.0] = 2.51475
		},
		randomize_indexes = {}
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_b__level_hab_block_security_01",
			[2.0] = "loc_psyker_female_b__level_hab_block_security_02"
		},
		sound_events_duration = {
			[1.0] = 2.345229,
			[2.0] = 5.430958
		},
		randomize_indexes = {}
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_female_b__guidance_starting_area_01",
			"loc_psyker_female_b__guidance_starting_area_02",
			"loc_psyker_female_b__guidance_starting_area_03",
			"loc_psyker_female_b__guidance_starting_area_04",
			"loc_psyker_female_b__guidance_starting_area_05",
			"loc_psyker_female_b__guidance_starting_area_06",
			"loc_psyker_female_b__guidance_starting_area_07",
			"loc_psyker_female_b__guidance_starting_area_08",
			"loc_psyker_female_b__guidance_starting_area_09",
			"loc_psyker_female_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			1.542875,
			1.689292,
			2.206854,
			1.794875,
			1.488542,
			2.45075,
			2.846729,
			2.258458,
			2.091063,
			3.238646
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

return settings("mission_vo_cm_habs_remake_psyker_female_b", mission_vo_cm_habs_remake_psyker_female_b)
