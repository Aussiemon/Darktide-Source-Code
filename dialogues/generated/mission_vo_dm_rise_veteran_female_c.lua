-- chunkname: @dialogues/generated/mission_vo_dm_rise_veteran_female_c.lua

local mission_vo_dm_rise_veteran_female_c = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_c__guidance_starting_area_01",
			"loc_veteran_female_c__guidance_starting_area_02",
			"loc_veteran_female_c__guidance_starting_area_03",
			"loc_veteran_female_c__guidance_starting_area_04",
			"loc_veteran_female_c__guidance_starting_area_05",
			"loc_veteran_female_c__guidance_starting_area_06",
			"loc_veteran_female_c__guidance_starting_area_07",
			"loc_veteran_female_c__guidance_starting_area_08",
			"loc_veteran_female_c__guidance_starting_area_09",
			"loc_veteran_female_c__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.781354,
			2.374854,
			2.028573,
			2.545385,
			4.008042,
			2.618948,
			2.877021,
			2.45276,
			2.604781,
			4.225719,
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
	mission_rise_keep_coming_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__event_survive_almost_done_01",
			"loc_veteran_female_c__event_survive_almost_done_02",
			"loc_veteran_female_c__event_survive_almost_done_03",
			"loc_veteran_female_c__event_survive_almost_done_04",
		},
		sound_events_duration = {
			1.931833,
			2.011417,
			2.53349,
			2.271198,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	mission_rise_start_b_sergeant_branch = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_c__region_habculum_01",
			[2] = "loc_veteran_female_c__region_habculum_03",
		},
		sound_events_duration = {
			[1] = 2.261156,
			[2] = 2.988865,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	mission_rise_start_b_sergeant_branch_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_female_c__zone_transit_01",
			"loc_veteran_female_c__zone_transit_02",
			"loc_veteran_female_c__zone_transit_03",
		},
		sound_events_duration = {
			2.046302,
			3.731979,
			2.73226,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_veteran_female_c", mission_vo_dm_rise_veteran_female_c)
