local mission_vo_cm_raid_veteran_female_a = {
	mission_raid_first_objective_response = {
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
	mission_raid_region_carnival = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_female_a__region_carnival_a_01",
			"loc_veteran_female_a__region_carnival_a_02",
			"loc_veteran_female_a__region_carnival_a_03"
		},
		sound_events_duration = {
			2.694917,
			3.739333,
			3.468479
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
			"loc_veteran_female_a__mission_raid_trapped_a_01",
			"loc_veteran_female_a__mission_raid_trapped_a_02",
			"loc_veteran_female_a__mission_raid_trapped_a_03",
			"loc_veteran_female_a__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			1.258542,
			0.839125,
			1.777146,
			1.126354
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_a__mission_raid_trapped_b_01",
			"loc_veteran_female_a__mission_raid_trapped_b_02",
			"loc_veteran_female_a__mission_raid_trapped_b_03",
			"loc_veteran_female_a__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			2.280083,
			1.298833,
			2.787438,
			2.490896
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_a__mission_raid_trapped_c_01",
			"loc_veteran_female_a__mission_raid_trapped_c_02",
			"loc_veteran_female_a__mission_raid_trapped_c_03",
			"loc_veteran_female_a__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			1.867479,
			1.876146,
			2.144104,
			2.658042
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_veteran_female_a", mission_vo_cm_raid_veteran_female_a)
