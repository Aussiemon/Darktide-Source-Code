-- chunkname: @dialogues/generated/mission_vo_dm_rise_veteran_female_a.lua

local mission_vo_dm_rise_veteran_female_a = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_a__guidance_starting_area_01",
			"loc_veteran_female_a__guidance_starting_area_02",
			"loc_veteran_female_a__guidance_starting_area_03",
			"loc_veteran_female_a__guidance_starting_area_04",
			"loc_veteran_female_a__guidance_starting_area_05",
			"loc_veteran_female_a__guidance_starting_area_06",
			"loc_veteran_female_a__guidance_starting_area_07",
			"loc_veteran_female_a__guidance_starting_area_08",
			"loc_veteran_female_a__guidance_starting_area_09",
			"loc_veteran_female_a__guidance_starting_area_10"
		},
		sound_events_duration = {
			0.927813,
			2.139771,
			1.870229,
			1.965792,
			1.220688,
			1.388438,
			1.57325,
			1.210625,
			1.97525,
			2.124896
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
			"loc_veteran_female_a__event_survive_almost_done_01",
			"loc_veteran_female_a__event_survive_almost_done_02",
			"loc_veteran_female_a__event_survive_almost_done_03",
			"loc_veteran_female_a__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.240479,
			2.932688,
			1.391958,
			2.789313
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
			"loc_veteran_female_a__region_habculum_01",
			"loc_veteran_female_a__region_habculum_02",
			"loc_veteran_female_a__region_habculum_03"
		},
		sound_events_duration = {
			6.796042,
			6.596396,
			5.459271
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
			"loc_veteran_female_a__zone_transit_01",
			"loc_veteran_female_a__zone_transit_02",
			"loc_veteran_female_a__zone_transit_03"
		},
		sound_events_duration = {
			2.056,
			1.875771,
			3.007208
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_veteran_female_a", mission_vo_dm_rise_veteran_female_a)
