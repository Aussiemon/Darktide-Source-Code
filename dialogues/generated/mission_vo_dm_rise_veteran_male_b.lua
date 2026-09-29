-- chunkname: @dialogues/generated/mission_vo_dm_rise_veteran_male_b.lua

local mission_vo_dm_rise_veteran_male_b = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_male_b__guidance_starting_area_01",
			"loc_veteran_male_b__guidance_starting_area_02",
			"loc_veteran_male_b__guidance_starting_area_03",
			"loc_veteran_male_b__guidance_starting_area_04",
			"loc_veteran_male_b__guidance_starting_area_05",
			"loc_veteran_male_b__guidance_starting_area_06",
			"loc_veteran_male_b__guidance_starting_area_07",
			"loc_veteran_male_b__guidance_starting_area_08",
			"loc_veteran_male_b__guidance_starting_area_09",
			"loc_veteran_male_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			2.807333,
			3.393708,
			4.216229,
			1.783667,
			2.353729,
			1.99775,
			2.877917,
			2.221354,
			2.726938,
			3.0765
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
			"loc_veteran_male_b__event_survive_almost_done_01",
			"loc_veteran_male_b__event_survive_almost_done_02",
			"loc_veteran_male_b__event_survive_almost_done_03",
			"loc_veteran_male_b__event_survive_almost_done_04"
		},
		sound_events_duration = {
			2.241146,
			1.330604,
			2.901125,
			2.200729
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
			"loc_veteran_male_b__region_habculum_01",
			"loc_veteran_male_b__region_habculum_02",
			"loc_veteran_male_b__region_habculum_03"
		},
		sound_events_duration = {
			6.857729,
			4.159563,
			3.920688
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
			"loc_veteran_male_b__zone_transit_01",
			"loc_veteran_male_b__zone_transit_02",
			"loc_veteran_male_b__zone_transit_03"
		},
		sound_events_duration = {
			3.567667,
			5.182688,
			3.639292
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_veteran_male_b", mission_vo_dm_rise_veteran_male_b)
