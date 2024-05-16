-- chunkname: @dialogues/generated/mission_vo_dm_rise_veteran_male_c.lua

local mission_vo_dm_rise_veteran_male_c = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_male_c__guidance_starting_area_01",
			"loc_veteran_male_c__guidance_starting_area_02",
			"loc_veteran_male_c__guidance_starting_area_03",
			"loc_veteran_male_c__guidance_starting_area_04",
			"loc_veteran_male_c__guidance_starting_area_05",
			"loc_veteran_male_c__guidance_starting_area_06",
			"loc_veteran_male_c__guidance_starting_area_07",
			"loc_veteran_male_c__guidance_starting_area_08",
			"loc_veteran_male_c__guidance_starting_area_09",
			"loc_veteran_male_c__guidance_starting_area_10",
		},
		sound_events_duration = {
			2.041813,
			2.978792,
			2.393083,
			3.484417,
			4.367708,
			2.682302,
			3.141052,
			2.611063,
			2.418073,
			3.415063,
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
			"loc_veteran_male_c__event_survive_almost_done_01",
			"loc_veteran_male_c__event_survive_almost_done_02",
			"loc_veteran_male_c__event_survive_almost_done_03",
			"loc_veteran_male_c__event_survive_almost_done_04",
		},
		sound_events_duration = {
			1.950583,
			1.974625,
			2.323219,
			2.54226,
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
			[1] = "loc_veteran_male_c__region_habculum_01",
			[2] = "loc_veteran_male_c__region_habculum_03",
		},
		sound_events_duration = {
			[1] = 3.064042,
			[2] = 2.817177,
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
			"loc_veteran_male_c__zone_transit_01",
			"loc_veteran_male_c__zone_transit_02",
			"loc_veteran_male_c__zone_transit_03",
		},
		sound_events_duration = {
			1.731833,
			3.54251,
			2.170458,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_veteran_male_c", mission_vo_dm_rise_veteran_male_c)
