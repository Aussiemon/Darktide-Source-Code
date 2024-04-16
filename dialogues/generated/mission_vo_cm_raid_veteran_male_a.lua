local mission_vo_cm_raid_veteran_male_a = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_male_a__guidance_starting_area_01",
			"loc_veteran_male_a__guidance_starting_area_02",
			"loc_veteran_male_a__guidance_starting_area_03",
			"loc_veteran_male_a__guidance_starting_area_04",
			"loc_veteran_male_a__guidance_starting_area_05",
			"loc_veteran_male_a__guidance_starting_area_06",
			"loc_veteran_male_a__guidance_starting_area_07",
			"loc_veteran_male_a__guidance_starting_area_08",
			"loc_veteran_male_a__guidance_starting_area_09",
			"loc_veteran_male_a__guidance_starting_area_10"
		},
		sound_events_duration = {
			0.989729,
			1.379813,
			1.616938,
			2.092104,
			1.403833,
			1.059667,
			1.590104,
			1.172583,
			2.136979,
			1.585292
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
			"loc_veteran_male_a__region_carnival_a_01",
			"loc_veteran_male_a__region_carnival_a_02",
			"loc_veteran_male_a__region_carnival_a_03"
		},
		sound_events_duration = {
			3.282854,
			3.988563,
			3.755708
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
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__mission_raid_trapped_a_01",
			"loc_veteran_male_a__mission_raid_trapped_a_02",
			"loc_veteran_male_a__mission_raid_trapped_a_03",
			"loc_veteran_male_a__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			1.14925,
			0.778125,
			1.752396,
			1.272688
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__mission_raid_trapped_b_01",
			"loc_veteran_male_a__mission_raid_trapped_b_02",
			"loc_veteran_male_a__mission_raid_trapped_b_03",
			"loc_veteran_male_a__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			2.336021,
			1.427667,
			2.363042,
			2.496521
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__mission_raid_trapped_c_01",
			"loc_veteran_male_a__mission_raid_trapped_c_02",
			"loc_veteran_male_a__mission_raid_trapped_c_03",
			"loc_veteran_male_a__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			2.114667,
			1.910958,
			2.228021,
			3.008667
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_veteran_male_a", mission_vo_cm_raid_veteran_male_a)
