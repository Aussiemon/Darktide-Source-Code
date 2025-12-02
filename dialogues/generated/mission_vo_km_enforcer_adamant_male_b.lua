-- chunkname: @dialogues/generated/mission_vo_km_enforcer_adamant_male_b.lua

local mission_vo_km_enforcer_adamant_male_b = {
	mission_enforcer_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_male_b__guidance_starting_area_01",
			"loc_adamant_male_b__guidance_starting_area_02",
			"loc_adamant_male_b__guidance_starting_area_03",
			"loc_adamant_male_b__guidance_starting_area_04",
			"loc_adamant_male_b__guidance_starting_area_05",
			"loc_adamant_male_b__guidance_starting_area_06",
			"loc_adamant_male_b__guidance_starting_area_07",
			"loc_adamant_male_b__guidance_starting_area_08",
		},
		sound_events_duration = {
			3.049573,
			2.328073,
			3.58425,
			2.881646,
			4.426927,
			3.423719,
			2.998333,
			3.458031,
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
	mission_enforcer_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_enforcer_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 2.056823,
		},
		randomize_indexes = {},
	},
	mission_enforcer_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_b__region_habculum_01",
			"loc_adamant_male_b__region_habculum_02",
			"loc_adamant_male_b__region_habculum_03",
			"loc_adamant_male_b__zone_watertown_01",
			"loc_adamant_male_b__zone_watertown_02",
			"loc_adamant_male_b__zone_watertown_03",
		},
		sound_events_duration = {
			2.95174,
			2.910594,
			2.018958,
			4.103385,
			2.515896,
			6.788458,
		},
		sound_event_weights = {
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_adamant_male_b", mission_vo_km_enforcer_adamant_male_b)
