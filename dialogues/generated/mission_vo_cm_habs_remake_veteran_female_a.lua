-- chunkname: @dialogues/generated/mission_vo_cm_habs_remake_veteran_female_a.lua

local mission_vo_cm_habs_remake_veteran_female_a = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_a__level_hab_block_apartments_01",
			[2] = "loc_veteran_female_a__level_hab_block_apartments_02",
		},
		sound_events_duration = {
			[1] = 3.551438,
			[2] = 2.469521,
		},
		randomize_indexes = {},
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_a__level_hab_block_apartments_response_01",
			[2] = "loc_veteran_female_a__level_hab_block_apartments_response_02",
		},
		sound_events_duration = {
			[1] = 6.371583,
			[2] = 1.989563,
		},
		randomize_indexes = {},
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_a__level_hab_block_collapse_01",
			[2] = "loc_veteran_female_a__level_hab_block_collapse_02",
		},
		sound_events_duration = {
			[1] = 1.754646,
			[2] = 1.358729,
		},
		randomize_indexes = {},
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_a__level_hab_block_corpse_01",
			[2] = "loc_veteran_female_a__level_hab_block_corpse_02",
		},
		sound_events_duration = {
			[1] = 2.465188,
			[2] = 3.080271,
		},
		randomize_indexes = {},
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_a__level_hab_block_security_01",
			[2] = "loc_veteran_female_a__level_hab_block_security_02",
		},
		sound_events_duration = {
			[1] = 3.756458,
			[2] = 4.282521,
		},
		randomize_indexes = {},
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_a__guidance_starting_area_01",
			"loc_veteran_female_a__guidance_starting_area_02",
			"loc_veteran_female_a__guidance_starting_area_03",
			"loc_veteran_female_a__guidance_starting_area_04",
			"loc_veteran_female_a__guidance_starting_area_05",
			"loc_veteran_female_a__guidance_starting_area_06",
			"loc_veteran_female_a__guidance_starting_area_07",
			"loc_veteran_female_a__guidance_starting_area_08",
			"loc_veteran_female_a__guidance_starting_area_09",
			"loc_veteran_female_a__guidance_starting_area_10",
		},
		sound_events_duration = {
			0.927813,
			2.139771,
			1.870229,
			1.965792,
			1.220688,
			1.388438,
			1.57325,
			1.210625,
			1.97525,
			2.124896,
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

return settings("mission_vo_cm_habs_remake_veteran_female_a", mission_vo_cm_habs_remake_veteran_female_a)
