-- chunkname: @dialogues/generated/mission_vo_dm_stockpile_adamant_male_c.lua

local mission_vo_dm_stockpile_adamant_male_c = {
	mission_stockpile_first_objective_response = {
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
	mission_stockpile_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_stockpile_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 5.683771,
		},
		randomize_indexes = {},
	},
	mission_stockpile_start_banter_c = {
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

return settings("mission_vo_dm_stockpile_adamant_male_c", mission_vo_dm_stockpile_adamant_male_c)
