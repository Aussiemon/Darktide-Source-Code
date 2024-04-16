local mission_vo_cm_habs_remake_psyker_male_c = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__level_hab_block_apartments_01",
			[2.0] = "loc_psyker_male_c__level_hab_block_apartments_02"
		},
		sound_events_duration = {
			[1.0] = 5.342698,
			[2.0] = 5.80724
		},
		randomize_indexes = {}
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__level_hab_block_apartments_response_01",
			[2.0] = "loc_psyker_male_c__level_hab_block_apartments_response_02"
		},
		sound_events_duration = {
			[1.0] = 3.491479,
			[2.0] = 4.550177
		},
		randomize_indexes = {}
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__level_hab_block_collapse_01",
			[2.0] = "loc_psyker_male_c__level_hab_block_collapse_02"
		},
		sound_events_duration = {
			[1.0] = 1.829115,
			[2.0] = 1.970417
		},
		randomize_indexes = {}
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__level_hab_block_corpse_01",
			[2.0] = "loc_psyker_male_c__level_hab_block_corpse_02"
		},
		sound_events_duration = {
			[1.0] = 4.499469,
			[2.0] = 3.896583
		},
		randomize_indexes = {}
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__level_hab_block_security_01",
			[2.0] = "loc_psyker_male_c__level_hab_block_security_02"
		},
		sound_events_duration = {
			[1.0] = 4.356469,
			[2.0] = 4.729146
		},
		randomize_indexes = {}
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_c__guidance_starting_area_01",
			"loc_psyker_male_c__guidance_starting_area_02",
			"loc_psyker_male_c__guidance_starting_area_03",
			"loc_psyker_male_c__guidance_starting_area_04",
			"loc_psyker_male_c__guidance_starting_area_05",
			"loc_psyker_male_c__guidance_starting_area_06",
			"loc_psyker_male_c__guidance_starting_area_07",
			"loc_psyker_male_c__guidance_starting_area_08",
			"loc_psyker_male_c__guidance_starting_area_09",
			"loc_psyker_male_c__guidance_starting_area_10"
		},
		sound_events_duration = {
			4.944573,
			2.607427,
			2.896125,
			2.726979,
			4.333031,
			3.791271,
			3.497927,
			4.412458,
			4.215552,
			4.21376
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

return settings("mission_vo_cm_habs_remake_psyker_male_c", mission_vo_cm_habs_remake_psyker_male_c)
