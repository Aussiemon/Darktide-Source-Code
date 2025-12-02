-- chunkname: @dialogues/generated/mission_vo_km_enforcer_adamant_female_b.lua

local mission_vo_km_enforcer_adamant_female_b = {
	mission_enforcer_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_b__guidance_starting_area_01",
			"loc_adamant_female_b__guidance_starting_area_02",
			"loc_adamant_female_b__guidance_starting_area_03",
			"loc_adamant_female_b__guidance_starting_area_04",
			"loc_adamant_female_b__guidance_starting_area_05",
			"loc_adamant_female_b__guidance_starting_area_06",
			"loc_adamant_female_b__guidance_starting_area_07",
			"loc_adamant_female_b__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.489438,
			2.14924,
			3.805177,
			3.799354,
			4.19201,
			3.705521,
			2.911885,
			3.076052,
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
			[1] = "loc_adamant_female_b__mission_enforcer_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 2.95,
		},
		randomize_indexes = {},
	},
	mission_enforcer_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_female_b__region_habculum_01",
			"loc_adamant_female_b__region_habculum_02",
			"loc_adamant_female_b__region_habculum_03",
			"loc_adamant_female_b__zone_watertown_01",
			"loc_adamant_female_b__zone_watertown_02",
			"loc_adamant_female_b__zone_watertown_03",
		},
		sound_events_duration = {
			3.029344,
			3.230677,
			2.259333,
			4.357344,
			2.544344,
			5.910677,
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

return settings("mission_vo_km_enforcer_adamant_female_b", mission_vo_km_enforcer_adamant_female_b)
