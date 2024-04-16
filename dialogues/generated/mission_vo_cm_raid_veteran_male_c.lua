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
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__mission_raid_trapped_a_01",
			"loc_veteran_male_c__mission_raid_trapped_a_02",
			"loc_veteran_male_c__mission_raid_trapped_a_03",
			"loc_veteran_male_c__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			1.11775,
			1.80001,
			2.00001,
			2.42126
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__mission_raid_trapped_b_01",
			"loc_veteran_male_c__mission_raid_trapped_b_02",
			"loc_veteran_male_c__mission_raid_trapped_b_03",
			"loc_veteran_male_c__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			1.269542,
			2.60001,
			1.40001,
			1.330833
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__mission_raid_trapped_c_01",
			"loc_veteran_male_c__mission_raid_trapped_c_02",
			"loc_veteran_male_c__mission_raid_trapped_c_03",
			"loc_veteran_male_c__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			2.433344,
			2.466677,
			2.666677,
			2.566677
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_veteran_male_c", mission_vo_cm_raid_veteran_male_c)
