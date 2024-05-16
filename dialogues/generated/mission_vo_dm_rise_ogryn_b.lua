-- chunkname: @dialogues/generated/mission_vo_dm_rise_ogryn_b.lua

local mission_vo_dm_rise_ogryn_b = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_b__guidance_starting_area_01",
			"loc_ogryn_b__guidance_starting_area_02",
			"loc_ogryn_b__guidance_starting_area_03",
			"loc_ogryn_b__guidance_starting_area_04",
			"loc_ogryn_b__guidance_starting_area_05",
			"loc_ogryn_b__guidance_starting_area_06",
			"loc_ogryn_b__guidance_starting_area_07",
			"loc_ogryn_b__guidance_starting_area_08",
			"loc_ogryn_b__guidance_starting_area_09",
			"loc_ogryn_b__guidance_starting_area_10",
		},
		sound_events_duration = {
			2.409448,
			3.01275,
			1.793698,
			2.30924,
			3.229344,
			5.244063,
			3.821292,
			2.978958,
			3.775854,
			5.305125,
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
			"loc_ogryn_b__event_survive_almost_done_01",
			"loc_ogryn_b__event_survive_almost_done_02",
			"loc_ogryn_b__event_survive_almost_done_03",
			"loc_ogryn_b__event_survive_almost_done_04",
		},
		sound_events_duration = {
			2.33049,
			1.681969,
			2.089469,
			1.839281,
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
			"loc_ogryn_b__region_habculum_01",
			"loc_ogryn_b__region_habculum_02",
			"loc_ogryn_b__region_habculum_03",
		},
		sound_events_duration = {
			2.677917,
			3.472167,
			4.688417,
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
			"loc_ogryn_b__zone_transit_01",
			"loc_ogryn_b__zone_transit_02",
			"loc_ogryn_b__zone_transit_03",
		},
		sound_events_duration = {
			5.573948,
			3.932,
			4.966625,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_ogryn_b", mission_vo_dm_rise_ogryn_b)
