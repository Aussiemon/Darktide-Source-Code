-- chunkname: @dialogues/generated/mission_vo_cm_habs_remake_veteran_female_b.lua

local mission_vo_cm_habs_remake_veteran_female_b = {
	level_hab_block_apartments = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__level_hab_block_apartments_01",
			[2] = "loc_veteran_female_b__level_hab_block_apartments_02",
		},
		sound_events_duration = {
			[1] = 1.674729,
			[2] = 2.228979,
		},
		randomize_indexes = {},
	},
	level_hab_block_apartments_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__level_hab_block_apartments_response_01",
			[2] = "loc_veteran_female_b__level_hab_block_apartments_response_02",
		},
		sound_events_duration = {
			[1] = 3.304958,
			[2] = 3.055271,
		},
		randomize_indexes = {},
	},
	level_hab_block_collapse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__level_hab_block_collapse_01",
			[2] = "loc_veteran_female_b__level_hab_block_collapse_02",
		},
		sound_events_duration = {
			[1] = 0.987792,
			[2] = 0.690313,
		},
		randomize_indexes = {},
	},
	level_hab_block_corpse = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__level_hab_block_corpse_01",
			[2] = "loc_veteran_female_b__level_hab_block_corpse_02",
		},
		sound_events_duration = {
			[1] = 2.739229,
			[2] = 2.786125,
		},
		randomize_indexes = {},
	},
	level_hab_block_security = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__level_hab_block_security_01",
			[2] = "loc_veteran_female_b__level_hab_block_security_02",
		},
		sound_events_duration = {
			[1] = 4.099167,
			[2] = 4.166479,
		},
		randomize_indexes = {},
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_b__guidance_starting_area_01",
			"loc_veteran_female_b__guidance_starting_area_02",
			"loc_veteran_female_b__guidance_starting_area_03",
			"loc_veteran_female_b__guidance_starting_area_04",
			"loc_veteran_female_b__guidance_starting_area_05",
			"loc_veteran_female_b__guidance_starting_area_06",
			"loc_veteran_female_b__guidance_starting_area_07",
			"loc_veteran_female_b__guidance_starting_area_08",
			"loc_veteran_female_b__guidance_starting_area_09",
			"loc_veteran_female_b__guidance_starting_area_10",
		},
		sound_events_duration = {
			2.784021,
			2.841854,
			3.674688,
			1.663688,
			1.961104,
			2.023521,
			2.891542,
			2.573583,
			3.490271,
			2.443458,
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

return settings("mission_vo_cm_habs_remake_veteran_female_b", mission_vo_cm_habs_remake_veteran_female_b)
