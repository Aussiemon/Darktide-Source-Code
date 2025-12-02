-- chunkname: @dialogues/generated/mission_vo_dm_rise_ogryn_d.lua

local mission_vo_dm_rise_ogryn_d = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_d__guidance_starting_area_01",
			"loc_ogryn_d__guidance_starting_area_02",
			"loc_ogryn_d__guidance_starting_area_03",
			"loc_ogryn_d__guidance_starting_area_04",
			"loc_ogryn_d__guidance_starting_area_05",
			"loc_ogryn_d__guidance_starting_area_06",
			"loc_ogryn_d__guidance_starting_area_07",
			"loc_ogryn_d__guidance_starting_area_08",
			"loc_ogryn_d__guidance_starting_area_09",
			"loc_ogryn_d__guidance_starting_area_10",
		},
		sound_events_duration = {
			3.414156,
			5.921052,
			5.203438,
			5.783073,
			3.513135,
			4.039313,
			3.712104,
			4.885927,
			3.494604,
			4.877969,
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
			"loc_ogryn_d__event_survive_almost_done_01",
			"loc_ogryn_d__event_survive_almost_done_02",
			"loc_ogryn_d__event_survive_almost_done_03",
			"loc_ogryn_d__event_survive_almost_done_04",
		},
		sound_events_duration = {
			2.259948,
			1.87799,
			2.267167,
			2.974094,
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
			"loc_ogryn_d__region_habculum_01",
			"loc_ogryn_d__region_habculum_02",
			"loc_ogryn_d__region_habculum_03",
		},
		sound_events_duration = {
			7.711094,
			10.09095,
			6.069583,
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
			"loc_ogryn_d__zone_transit_01",
			"loc_ogryn_d__zone_transit_02",
			"loc_ogryn_d__zone_transit_03",
		},
		sound_events_duration = {
			1.946885,
			2.456938,
			4.216208,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_ogryn_d", mission_vo_dm_rise_ogryn_d)
