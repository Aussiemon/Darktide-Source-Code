local mission_vo_cm_habs_veteran_female_b = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_female_b__region_habculum_01",
			"loc_veteran_female_b__region_habculum_02",
			"loc_veteran_female_b__region_habculum_03"
		},
		sound_events_duration = {
			9.154917,
			6.161458,
			3.807
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	level_hab_block_atrium = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_b__level_hab_block_atrium_01",
			[2.0] = "loc_veteran_female_b__level_hab_block_atrium_02"
		},
		sound_events_duration = {
			[1.0] = 2.437396,
			[2.0] = 3.847646
		},
		randomize_indexes = {}
	},
	level_hab_block_b_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_b__level_hab_block_b_response_b_01",
			[2.0] = "loc_veteran_female_b__level_hab_block_b_response_b_02"
		},
		sound_events_duration = {
			[1.0] = 1.380333,
			[2.0] = 3.036708
		},
		randomize_indexes = {}
	},
	level_hab_block_market_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_b__level_hab_block_market_response_01",
			[2.0] = "loc_veteran_female_b__level_hab_block_market_response_02"
		},
		sound_events_duration = {
			[1.0] = 3.021771,
			[2.0] = 2.808729
		},
		randomize_indexes = {}
	},
	level_hab_block_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_b__level_hab_block_void_01",
			[2.0] = "loc_veteran_female_b__level_hab_block_void_02"
		},
		sound_events_duration = {
			[1.0] = 1.816938,
			[2.0] = 3.7595
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	level_hab_block_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_veteran_female_b__region_habculum_01",
			"loc_veteran_female_b__region_habculum_02",
			"loc_veteran_female_b__region_habculum_03",
			"loc_veteran_female_b__zone_transit_01",
			"loc_veteran_female_b__zone_transit_02",
			"loc_veteran_female_b__zone_transit_03"
		},
		sound_events_duration = {
			9.154917,
			6.161458,
			3.807,
			3.641792,
			4.692521,
			3.108938
		},
		sound_event_weights = {
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667
		},
		randomize_indexes = {}
	},
	level_hab_block_temple = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_b__level_hab_block_temple_01",
			[2.0] = "loc_veteran_female_b__level_hab_block_temple_02"
		},
		sound_events_duration = {
			[1.0] = 3.167958,
			[2.0] = 1.559188
		},
		randomize_indexes = {}
	},
	level_hab_block_temple_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_01",
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_02",
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_03",
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_04",
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_05",
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_06",
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_07",
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_08",
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_09",
			"loc_veteran_female_b__nurgle_circumstance_prop_growth_10"
		},
		sound_events_duration = {
			3.340313,
			3.520208,
			4.508271,
			4.353875,
			4.085625,
			4.298063,
			4.712063,
			4.716563,
			2.268313,
			4.929229
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
	level_hab_block_vista = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_b__level_hab_block_vista_01",
			[2.0] = "loc_veteran_female_b__level_hab_block_vista_02"
		},
		sound_events_duration = {
			[1.0] = 2.502125,
			[2.0] = 3.117229
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_habs_veteran_female_b", mission_vo_cm_habs_veteran_female_b)
