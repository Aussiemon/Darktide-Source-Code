-- chunkname: @dialogues/generated/mission_vo_cm_habs_remake_psyker_male_b.lua

local mission_vo_cm_habs_remake_psyker_male_b = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__level_hab_block_apartments_01",
			[2] = "loc_psyker_male_b__level_hab_block_apartments_02",
		},
		sound_events_duration = {
			[1] = 3.156792,
			[2] = 4.06975,
		},
		randomize_indexes = {},
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__level_hab_block_apartments_response_01",
			[2] = "loc_psyker_male_b__level_hab_block_apartments_response_02",
		},
		sound_events_duration = {
			[1] = 2.606292,
			[2] = 3.680625,
		},
		randomize_indexes = {},
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__level_hab_block_collapse_01",
			[2] = "loc_psyker_male_b__level_hab_block_collapse_02",
		},
		sound_events_duration = {
			[1] = 2.777146,
			[2] = 3.043542,
		},
		randomize_indexes = {},
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__level_hab_block_corpse_01",
			[2] = "loc_psyker_male_b__level_hab_block_corpse_02",
		},
		sound_events_duration = {
			[1] = 3.864708,
			[2] = 2.967458,
		},
		randomize_indexes = {},
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__level_hab_block_security_01",
			[2] = "loc_psyker_male_b__level_hab_block_security_02",
		},
		sound_events_duration = {
			[1] = 1.773375,
			[2] = 6.872271,
		},
		randomize_indexes = {},
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_b__guidance_starting_area_01",
			"loc_psyker_male_b__guidance_starting_area_02",
			"loc_psyker_male_b__guidance_starting_area_03",
			"loc_psyker_male_b__guidance_starting_area_04",
			"loc_psyker_male_b__guidance_starting_area_05",
			"loc_psyker_male_b__guidance_starting_area_06",
			"loc_psyker_male_b__guidance_starting_area_07",
			"loc_psyker_male_b__guidance_starting_area_08",
			"loc_psyker_male_b__guidance_starting_area_09",
			"loc_psyker_male_b__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.998167,
			1.853771,
			2.238729,
			1.286896,
			1.377813,
			2.572667,
			3.0755,
			2.197708,
			2.287354,
			2.922938,
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

return settings("mission_vo_cm_habs_remake_psyker_male_b", mission_vo_cm_habs_remake_psyker_male_b)
