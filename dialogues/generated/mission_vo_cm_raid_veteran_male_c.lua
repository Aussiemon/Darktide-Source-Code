local mission_vo_cm_raid_veteran_male_c = {
	mission_raid_first_objective_response = {
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
			"loc_veteran_male_c__guidance_starting_area_10"
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
			3.415063
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
			"loc_veteran_male_c__region_carnival_a_01",
			"loc_veteran_male_c__region_carnival_a_02",
			"loc_veteran_male_c__region_carnival_a_03"
		},
		sound_events_duration = {
			2.745875,
			3.548396,
			2.286521
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
			"loc_veteran_male_c__surrounded_01",
			"loc_veteran_male_c__surrounded_04",
			"loc_veteran_male_c__surrounded_09"
		},
		sound_events_duration = {
			3.810958,
			2.764906,
			2.323813
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
			[1.0] = "loc_veteran_male_c__surrounded_response_04",
			[2.0] = "loc_veteran_male_c__surrounded_response_05"
		},
		sound_events_duration = {
			[1.0] = 2.167479,
			[2.0] = 3.519635
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_veteran_male_c", mission_vo_cm_raid_veteran_male_c)
