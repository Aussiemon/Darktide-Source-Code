local mission_vo_cm_habs_remake_veteran_male_c = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_c__level_hab_block_apartments_01",
			[2.0] = "loc_veteran_male_c__level_hab_block_apartments_02"
		},
		sound_events_duration = {
			[1.0] = 1.720115,
			[2.0] = 2.815125
		},
		randomize_indexes = {}
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_c__level_hab_block_apartments_response_02",
			[2.0] = "loc_veteran_male_c__level_hab_block_apartments_response_01"
		},
		sound_events_duration = {
			[1.0] = 2.125281,
			[2.0] = 2.621073
		},
		randomize_indexes = {}
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_c__level_hab_block_collapse_01",
			[2.0] = "loc_veteran_male_c__level_hab_block_collapse_02"
		},
		sound_events_duration = {
			[1.0] = 1.232021,
			[2.0] = 1.118646
		},
		randomize_indexes = {}
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_c__level_hab_block_corpse_01",
			[2.0] = "loc_veteran_male_c__level_hab_block_corpse_02"
		},
		sound_events_duration = {
			[1.0] = 0.990135,
			[2.0] = 2.174406
		},
		randomize_indexes = {}
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_c__level_hab_block_security_01",
			[2.0] = "loc_veteran_male_c__level_hab_block_security_02"
		},
		sound_events_duration = {
			[1.0] = 2.252604,
			[2.0] = 1.738563
		},
		randomize_indexes = {}
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_male_c__guidance_starting_area_01",
			"loc_veteran_male_c__guidance_starting_area_02",
			"loc_veteran_male_c__guidance_starting_area_03",
			"loc_veteran_male_c__guidance_starting_area_04",
			"loc_veteran_male_c__guidance_starting_area_05",
			"loc_veteran_male_c__guidance_starting_area_06",
			"loc_veteran_male_c__guidance_starting_area_07",
			"loc_veteran_male_c__guidance_starting_area_08",
			"loc_veteran_male_c__guidance_starting_area_09",
			"loc_veteran_male_c__guidance_starting_area_10"
		},
		sound_events_duration = {
			2.041813,
			2.978792,
			2.393083,
			3.484417,
			4.367708,
			2.682302,
			3.141052,
			2.611063,
			2.418073,
			3.415063
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

return settings("mission_vo_cm_habs_remake_veteran_male_c", mission_vo_cm_habs_remake_veteran_male_c)
