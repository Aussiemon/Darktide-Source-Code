local mission_vo_cm_habs_zealot_female_b = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_zealot_female_b__region_habculum_01",
			"loc_zealot_female_b__region_habculum_02",
			"loc_zealot_female_b__region_habculum_03"
		},
		sound_events_duration = {
			4.296146,
			6.11475,
			2.481792
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
			[1.0] = "loc_zealot_female_b__level_hab_block_atrium_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_atrium_02"
		},
		sound_events_duration = {
			[1.0] = 7.373323,
			[2.0] = 6.70724
		},
		randomize_indexes = {}
	},
	level_hab_block_b_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_b__level_hab_block_b_response_b_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_b_response_b_02"
		},
		sound_events_duration = {
			[1.0] = 3.264948,
			[2.0] = 1.14776
		},
		randomize_indexes = {}
	},
	level_hab_block_market_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_b__level_hab_block_market_response_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_market_response_02"
		},
		sound_events_duration = {
			[1.0] = 4.664365,
			[2.0] = 5.13026
		},
		randomize_indexes = {}
	},
	level_hab_block_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_b__level_hab_block_void_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_void_02"
		},
		sound_events_duration = {
			[1.0] = 4.030115,
			[2.0] = 3.898729
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
			"loc_zealot_female_b__region_habculum_01",
			"loc_zealot_female_b__region_habculum_02",
			"loc_zealot_female_b__region_habculum_03",
			"loc_zealot_female_b__zone_transit_01",
			"loc_zealot_female_b__zone_transit_02",
			"loc_zealot_female_b__zone_transit_03"
		},
		sound_events_duration = {
			4.296146,
			6.11475,
			2.481792,
			4.234729,
			4.803896,
			3.656396
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
			[1.0] = "loc_zealot_female_b__level_hab_block_temple_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_temple_02"
		},
		sound_events_duration = {
			[1.0] = 6.491125,
			[2.0] = 5.312729
		},
		randomize_indexes = {}
	},
	level_hab_block_temple_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_01",
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_02",
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_03",
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_04",
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_05",
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_06",
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_07",
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_08",
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_09",
			"loc_zealot_female_b__nurgle_circumstance_prop_growth_10"
		},
		sound_events_duration = {
			3.472667,
			3.669271,
			4.400958,
			5.705625,
			4.196563,
			4.927354,
			4.720208,
			5.750646,
			2.543667,
			3.277646
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
			[1.0] = "loc_zealot_female_b__level_hab_block_vista_01",
			[2.0] = "loc_zealot_female_b__level_hab_block_vista_02"
		},
		sound_events_duration = {
			[1.0] = 6.002625,
			[2.0] = 5.44274
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_habs_zealot_female_b", mission_vo_cm_habs_zealot_female_b)
