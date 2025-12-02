-- chunkname: @dialogues/generated/mission_vo_hm_cartel_adamant_male_c.lua

local mission_vo_hm_cartel_adamant_male_c = {
	asset_acid_clouds_mission_cartel = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_male_c__zone_watertown_acid_clouds_01",
			[2] = "loc_adamant_male_c__zone_watertown_acid_clouds_02",
		},
		sound_events_duration = {
			[1] = 4.009333,
			[2] = 5.411,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	mission_cartel_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_male_c__guidance_starting_area_01",
			"loc_adamant_male_c__guidance_starting_area_02",
			"loc_adamant_male_c__guidance_starting_area_03",
			"loc_adamant_male_c__guidance_starting_area_04",
			"loc_adamant_male_c__guidance_starting_area_05",
			"loc_adamant_male_c__guidance_starting_area_06",
			"loc_adamant_male_c__guidance_starting_area_07",
			"loc_adamant_male_c__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.312833,
			3.367219,
			2.002302,
			2.842625,
			1.900979,
			2.532229,
			2.363865,
			2.993396,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
	mission_cartel_mudlark = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_cartel_mudlark_01",
		},
		sound_events_duration = {
			[1] = 3.751063,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_cartel_shanty_01",
		},
		sound_events_duration = {
			[1] = 2.747615,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_c__zone_watertown_01",
			"loc_adamant_male_c__zone_watertown_02",
			"loc_adamant_male_c__zone_watertown_03",
		},
		sound_events_duration = {
			3.014667,
			2.793333,
			3.386,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_cartel_adamant_male_c", mission_vo_hm_cartel_adamant_male_c)
