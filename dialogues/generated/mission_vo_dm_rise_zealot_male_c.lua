-- chunkname: @dialogues/generated/mission_vo_dm_rise_zealot_male_c.lua

local mission_vo_dm_rise_zealot_male_c = {
	mission_rise_first_objective_response = {
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
	mission_rise_keep_coming_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__event_survive_almost_done_01",
			"loc_zealot_male_c__event_survive_almost_done_02",
			"loc_zealot_male_c__event_survive_almost_done_03",
			"loc_zealot_male_c__event_survive_almost_done_04",
		},
		sound_events_duration = {
			5.413052,
			3.409344,
			2.901708,
			4.14425,
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
		sound_events_n = 3,
		sound_events = {
			"loc_zealot_male_c__region_habculum_01",
			"loc_zealot_male_c__region_habculum_02",
			"loc_zealot_male_c__region_habculum_03",
		},
		sound_events_duration = {
			5.019344,
			2.945594,
			5.703438,
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
			"loc_zealot_male_c__zone_transit_01",
			"loc_zealot_male_c__zone_transit_02",
			"loc_zealot_male_c__zone_transit_03",
		},
		sound_events_duration = {
			3.814698,
			2.883896,
			4.57826,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_zealot_male_c", mission_vo_dm_rise_zealot_male_c)
