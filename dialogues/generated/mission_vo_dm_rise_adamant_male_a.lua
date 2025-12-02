-- chunkname: @dialogues/generated/mission_vo_dm_rise_adamant_male_a.lua

local mission_vo_dm_rise_adamant_male_a = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_male_a__guidance_starting_area_01",
			"loc_adamant_male_a__guidance_starting_area_02",
			"loc_adamant_male_a__guidance_starting_area_03",
			"loc_adamant_male_a__guidance_starting_area_04",
			"loc_adamant_male_a__guidance_starting_area_05",
			"loc_adamant_male_a__guidance_starting_area_06",
			"loc_adamant_male_a__guidance_starting_area_07",
			"loc_adamant_male_a__guidance_starting_area_08",
		},
		sound_events_duration = {
			1.677333,
			3.262667,
			3.306667,
			4.317333,
			3.72,
			4.964,
			2.613333,
			5.453333,
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
			"loc_adamant_male_a__region_habculum_01",
			"loc_adamant_male_a__region_habculum_02",
			"loc_adamant_male_a__region_habculum_03",
		},
		sound_events_duration = {
			4.21601,
			4.61601,
			5.23201,
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
			"loc_adamant_male_a__zone_transit_01",
			"loc_adamant_male_a__zone_transit_02",
			"loc_adamant_male_a__zone_transit_03",
		},
		sound_events_duration = {
			1.785344,
			2.233344,
			2.946677,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_adamant_male_a", mission_vo_dm_rise_adamant_male_a)
