local mission_vo_cm_habs_zealot_female_a = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_zealot_female_a__region_habculum_01",
			"loc_zealot_female_a__region_habculum_02",
			"loc_zealot_female_a__region_habculum_03"
		},
		sound_events_duration = {
			5.614292,
			8.9905,
			3.530667
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
			[1.0] = "loc_zealot_female_a__level_hab_block_atrium_01",
			[2.0] = "loc_zealot_female_a__level_hab_block_atrium_02"
		},
		sound_events_duration = {
			[1.0] = 5.386292,
			[2.0] = 4.669167
		},
		randomize_indexes = {}
	},
	level_hab_block_b_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_a__level_hab_block_b_response_b_01",
			[2.0] = "loc_zealot_female_a__level_hab_block_b_response_b_02"
		},
		sound_events_duration = {
			[1.0] = 2.288917,
			[2.0] = 1.951813
		},
		randomize_indexes = {}
	},
	level_hab_block_market_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_a__level_hab_block_market_response_01",
			[2.0] = "loc_zealot_female_a__level_hab_block_market_response_02"
		},
		sound_events_duration = {
			[1.0] = 3.681208,
			[2.0] = 4.044979
		},
		randomize_indexes = {}
	},
	level_hab_block_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_a__level_hab_block_void_01",
			[2.0] = "loc_zealot_female_a__level_hab_block_void_02"
		},
		sound_events_duration = {
			[1.0] = 3.88575,
			[2.0] = 3.066208
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
			"loc_zealot_female_a__region_habculum_01",
			"loc_zealot_female_a__region_habculum_02",
			"loc_zealot_female_a__region_habculum_03",
			"loc_zealot_female_a__zone_transit_01",
			"loc_zealot_female_a__zone_transit_02",
			"loc_zealot_female_a__zone_transit_03"
		},
		sound_events_duration = {
			5.614292,
			8.9905,
			3.530667,
			2.822542,
			2.447083,
			3.322833
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
			[1.0] = "loc_zealot_female_a__level_hab_block_temple_01",
			[2.0] = "loc_zealot_female_a__level_hab_block_temple_02"
		},
		sound_events_duration = {
			[1.0] = 2.835479,
			[2.0] = 3.774896
		},
		randomize_indexes = {}
	},
	level_hab_block_temple_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_01",
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_02",
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_03",
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_04",
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_05",
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_06",
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_07",
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_08",
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_09",
			"loc_zealot_female_a__nurgle_circumstance_prop_growth_10"
		},
		sound_events_duration = {
			3.909438,
			5.350313,
			4.364042,
			6.2195,
			3.595875,
			5.204708,
			3.435667,
			6.185208,
			4.722708,
			3.874417
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
			[1.0] = "loc_zealot_female_a__level_hab_block_vista_01",
			[2.0] = "loc_zealot_female_a__level_hab_block_vista_02"
		},
		sound_events_duration = {
			[1.0] = 3.736792,
			[2.0] = 4.647021
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_habs_zealot_female_a", mission_vo_cm_habs_zealot_female_a)
