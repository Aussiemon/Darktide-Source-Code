-- chunkname: @dialogues/generated/mission_vo_cm_habs_remake_zealot_male_c.lua

local mission_vo_cm_habs_remake_zealot_male_c = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_c__level_hab_block_apartments_01",
			[2] = "loc_zealot_male_c__level_hab_block_apartments_02",
		},
		sound_events_duration = {
			[1] = 4.972156,
			[2] = 3.294271,
		},
		randomize_indexes = {},
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_c__level_hab_block_apartments_response_01",
			[2] = "loc_zealot_male_c__level_hab_block_apartments_response_02",
		},
		sound_events_duration = {
			[1] = 3.277688,
			[2] = 3.18674,
		},
		randomize_indexes = {},
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_c__level_hab_block_collapse_01",
			[2] = "loc_zealot_male_c__level_hab_block_collapse_02",
		},
		sound_events_duration = {
			[1] = 1.959938,
			[2] = 0.976833,
		},
		randomize_indexes = {},
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_c__level_hab_block_corpse_01",
			[2] = "loc_zealot_male_c__level_hab_block_corpse_02",
		},
		sound_events_duration = {
			[1] = 2.004302,
			[2] = 2.65651,
		},
		randomize_indexes = {},
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_c__level_hab_block_security_01",
			[2] = "loc_zealot_male_c__level_hab_block_security_02",
		},
		sound_events_duration = {
			[1] = 4.445031,
			[2] = 3.045948,
		},
		randomize_indexes = {},
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_male_c__guidance_starting_area_01",
			"loc_zealot_male_c__guidance_starting_area_02",
			"loc_zealot_male_c__guidance_starting_area_03",
			"loc_zealot_male_c__guidance_starting_area_04",
			"loc_zealot_male_c__guidance_starting_area_05",
			"loc_zealot_male_c__guidance_starting_area_06",
			"loc_zealot_male_c__guidance_starting_area_07",
			"loc_zealot_male_c__guidance_starting_area_08",
			"loc_zealot_male_c__guidance_starting_area_09",
			"loc_zealot_male_c__guidance_starting_area_10",
		},
		sound_events_duration = {
			2.237354,
			3.021813,
			2.52375,
			3.301417,
			3.185729,
			3.474708,
			2.851688,
			4.621146,
			6.211156,
			3.073646,
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

return settings("mission_vo_cm_habs_remake_zealot_male_c", mission_vo_cm_habs_remake_zealot_male_c)
