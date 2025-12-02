-- chunkname: @dialogues/generated/mission_vo_dm_rise_adamant_male_b.lua

local mission_vo_dm_rise_adamant_male_b = {
	mission_rise_first_objective_response = {
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
	mission_rise_start_b_sergeant_branch = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__region_habculum_01",
			"loc_adamant_male_b__region_habculum_02",
			"loc_adamant_male_b__region_habculum_03",
		},
		sound_events_duration = {
			2.95174,
			2.910594,
			2.018958,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_rise_start_b_sergeant_branch_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__zone_transit_01",
			"loc_adamant_male_b__zone_transit_02",
			"loc_adamant_male_b__zone_transit_03",
		},
		sound_events_duration = {
			3.509448,
			2.92375,
			4.13424,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_adamant_male_b", mission_vo_dm_rise_adamant_male_b)
