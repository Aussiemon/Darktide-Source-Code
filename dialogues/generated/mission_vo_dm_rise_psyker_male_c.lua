-- chunkname: @dialogues/generated/mission_vo_dm_rise_psyker_male_c.lua

local mission_vo_dm_rise_psyker_male_c = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_c__guidance_starting_area_01",
			"loc_psyker_male_c__guidance_starting_area_02",
			"loc_psyker_male_c__guidance_starting_area_03",
			"loc_psyker_male_c__guidance_starting_area_04",
			"loc_psyker_male_c__guidance_starting_area_05",
			"loc_psyker_male_c__guidance_starting_area_06",
			"loc_psyker_male_c__guidance_starting_area_07",
			"loc_psyker_male_c__guidance_starting_area_08",
			"loc_psyker_male_c__guidance_starting_area_09",
			"loc_psyker_male_c__guidance_starting_area_10"
		},
		sound_events_duration = {
			4.944573,
			2.607427,
			2.896125,
			2.726979,
			4.333031,
			3.791271,
			3.497927,
			4.412458,
			4.215552,
			4.21376
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
			0.1
		},
		randomize_indexes = {}
	},
	mission_rise_keep_coming_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__event_survive_almost_done_01",
			"loc_psyker_male_c__event_survive_almost_done_02",
			"loc_psyker_male_c__event_survive_almost_done_03",
			"loc_psyker_male_c__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.295802,
			1.264604,
			1.126042,
			1.44851
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	mission_rise_start_b_sergeant_branch = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_male_c__region_habculum_01",
			"loc_psyker_male_c__region_habculum_02",
			"loc_psyker_male_c__region_habculum_03"
		},
		sound_events_duration = {
			3.36051,
			3.409594,
			4.554875
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	mission_rise_start_b_sergeant_branch_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_male_c__zone_transit_01",
			"loc_psyker_male_c__zone_transit_02",
			"loc_psyker_male_c__zone_transit_03"
		},
		sound_events_duration = {
			5.021115,
			2.897792,
			4.446938
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_psyker_male_c", mission_vo_dm_rise_psyker_male_c)
