-- chunkname: @dialogues/generated/mission_vo_dm_rise_zealot_female_a.lua

local mission_vo_dm_rise_zealot_female_a = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_female_a__guidance_starting_area_01",
			"loc_zealot_female_a__guidance_starting_area_02",
			"loc_zealot_female_a__guidance_starting_area_03",
			"loc_zealot_female_a__guidance_starting_area_04",
			"loc_zealot_female_a__guidance_starting_area_05",
			"loc_zealot_female_a__guidance_starting_area_06",
			"loc_zealot_female_a__guidance_starting_area_07",
			"loc_zealot_female_a__guidance_starting_area_08",
			"loc_zealot_female_a__guidance_starting_area_09",
			"loc_zealot_female_a__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.147604,
			2.041,
			1.56625,
			1.863583,
			2.258104,
			2.178771,
			1.645542,
			3.153792,
			3.300042,
			2.505625,
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
			"loc_zealot_female_a__event_survive_almost_done_01",
			"loc_zealot_female_a__event_survive_almost_done_02",
			"loc_zealot_female_a__event_survive_almost_done_03",
			"loc_zealot_female_a__event_survive_almost_done_04",
		},
		sound_events_duration = {
			2.856333,
			3.484958,
			2.530771,
			2.076729,
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
			"loc_zealot_female_a__region_habculum_01",
			"loc_zealot_female_a__region_habculum_02",
			"loc_zealot_female_a__region_habculum_03",
		},
		sound_events_duration = {
			5.614292,
			8.9905,
			3.530667,
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
			"loc_zealot_female_a__zone_transit_01",
			"loc_zealot_female_a__zone_transit_02",
			"loc_zealot_female_a__zone_transit_03",
		},
		sound_events_duration = {
			2.822542,
			2.447083,
			3.322833,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_zealot_female_a", mission_vo_dm_rise_zealot_female_a)
