-- chunkname: @dialogues/generated/mission_vo_cm_habs_remake_veteran_female_c.lua

local mission_vo_cm_habs_remake_veteran_female_c = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_c__level_hab_block_apartments_01",
			[2] = "loc_veteran_female_c__level_hab_block_apartments_02",
		},
		sound_events_duration = {
			[1] = 1.527719,
			[2] = 2.010708,
		},
		randomize_indexes = {},
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_c__level_hab_block_apartments_response_01",
			[2] = "loc_veteran_male_c__level_hab_block_apartments_response_02",
		},
		sound_events_duration = {
			[1] = 1.838823,
			[2] = 1.836552,
		},
		randomize_indexes = {},
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_c__level_hab_block_collapse_01",
			[2] = "loc_veteran_female_c__level_hab_block_collapse_02",
		},
		sound_events_duration = {
			[1] = 1.341792,
			[2] = 1.496438,
		},
		randomize_indexes = {},
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_c__level_hab_block_corpse_01",
			[2] = "loc_veteran_female_c__level_hab_block_corpse_02",
		},
		sound_events_duration = {
			[1] = 1.205938,
			[2] = 1.969354,
		},
		randomize_indexes = {},
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_c__level_hab_block_security_01",
			[2] = "loc_veteran_female_c__level_hab_block_security_02",
		},
		sound_events_duration = {
			[1] = 2.085958,
			[2] = 2.256156,
		},
		randomize_indexes = {},
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_c__guidance_starting_area_01",
			"loc_veteran_female_c__guidance_starting_area_02",
			"loc_veteran_female_c__guidance_starting_area_03",
			"loc_veteran_female_c__guidance_starting_area_04",
			"loc_veteran_female_c__guidance_starting_area_05",
			"loc_veteran_female_c__guidance_starting_area_06",
			"loc_veteran_female_c__guidance_starting_area_07",
			"loc_veteran_female_c__guidance_starting_area_08",
			"loc_veteran_female_c__guidance_starting_area_09",
			"loc_veteran_female_c__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.781354,
			2.374854,
			2.028573,
			2.545385,
			4.008042,
			2.618948,
			2.877021,
			2.45276,
			2.604781,
			4.225719,
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
			0.1,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_habs_remake_veteran_female_c", mission_vo_cm_habs_remake_veteran_female_c)
