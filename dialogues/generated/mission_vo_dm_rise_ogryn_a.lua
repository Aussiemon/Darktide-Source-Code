-- chunkname: @dialogues/generated/mission_vo_dm_rise_ogryn_a.lua

local mission_vo_dm_rise_ogryn_a = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_a__guidance_starting_area_01",
			"loc_ogryn_a__guidance_starting_area_02",
			"loc_ogryn_a__guidance_starting_area_03",
			"loc_ogryn_a__guidance_starting_area_04",
			"loc_ogryn_a__guidance_starting_area_05",
			"loc_ogryn_a__guidance_starting_area_06",
			"loc_ogryn_a__guidance_starting_area_07",
			"loc_ogryn_a__guidance_starting_area_08",
			"loc_ogryn_a__guidance_starting_area_09",
			"loc_ogryn_a__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.048844,
			1.904646,
			2.28326,
			1.733802,
			2.825177,
			3.4055,
			1.868063,
			2.969396,
			2.054813,
			2.613104,
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
			"loc_ogryn_a__event_survive_almost_done_01",
			"loc_ogryn_a__event_survive_almost_done_02",
			"loc_ogryn_a__event_survive_almost_done_03",
			"loc_ogryn_a__event_survive_almost_done_04",
		},
		sound_events_duration = {
			2.724875,
			1.463229,
			2.123083,
			3.45125,
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
			"loc_ogryn_a__region_habculum_01",
			"loc_ogryn_a__region_habculum_02",
			"loc_ogryn_a__region_habculum_03",
		},
		sound_events_duration = {
			4.67974,
			5.885865,
			4.537323,
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
			"loc_ogryn_a__zone_transit_01",
			"loc_ogryn_a__zone_transit_02",
			"loc_ogryn_a__zone_transit_03",
		},
		sound_events_duration = {
			2.323542,
			4.643531,
			3.577458,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_ogryn_a", mission_vo_dm_rise_ogryn_a)
