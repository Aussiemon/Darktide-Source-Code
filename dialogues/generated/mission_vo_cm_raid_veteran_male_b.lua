local mission_vo_cm_raid_veteran_male_b = {
	mission_raid_first_objective_response = {
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
	mission_raid_region_carnival = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_male_b__region_carnival_a_01",
			"loc_veteran_male_b__region_carnival_a_02",
			"loc_veteran_male_b__region_carnival_a_03"
		},
		sound_events_duration = {
			4.98976,
			2.385646,
			4.986219
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_a = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_male_b__surrounded_01",
			"loc_veteran_male_b__surrounded_07",
			"loc_veteran_male_b__surrounded_09"
		},
		sound_events_duration = {
			2.850771,
			1.681917,
			1.650604
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_b__surrounded_response_07",
			[2.0] = "loc_veteran_male_b__surrounded_response_09"
		},
		sound_events_duration = {
			[1.0] = 2.410979,
			[2.0] = 1.694135
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_veteran_male_b", mission_vo_cm_raid_veteran_male_b)
