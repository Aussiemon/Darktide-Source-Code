local mission_vo_cm_habs_psyker_male_b = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_male_b__region_habculum_01",
			"loc_psyker_male_b__region_habculum_02",
			"loc_psyker_male_b__region_habculum_03"
		},
		sound_events_duration = {
			5.513708,
			6.412979,
			1.909729
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
			[1.0] = "loc_psyker_male_b__level_hab_block_atrium_01",
			[2.0] = "loc_psyker_male_b__level_hab_block_atrium_02"
		},
		sound_events_duration = {
			[1.0] = 2.708146,
			[2.0] = 3.767896
		},
		randomize_indexes = {}
	},
	level_hab_block_b_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_b__level_hab_block_b_response_b_01",
			[2.0] = "loc_psyker_male_b__level_hab_block_b_response_b_02"
		},
		sound_events_duration = {
			[1.0] = 2.426917,
			[2.0] = 2.632833
		},
		randomize_indexes = {}
	},
	level_hab_block_market_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_b__level_hab_block_market_response_01",
			[2.0] = "loc_psyker_male_b__level_hab_block_market_response_02"
		},
		sound_events_duration = {
			[1.0] = 1.44575,
			[2.0] = 2.114354
		},
		randomize_indexes = {}
	},
	level_hab_block_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_b__level_hab_block_void_01",
			[2.0] = "loc_psyker_male_b__level_hab_block_void_02"
		},
		sound_events_duration = {
			[1.0] = 1.496521,
			[2.0] = 2.648646
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
			"loc_psyker_male_b__region_habculum_01",
			"loc_psyker_male_b__region_habculum_02",
			"loc_psyker_male_b__region_habculum_03",
			"loc_psyker_male_b__zone_transit_01",
			"loc_psyker_male_b__zone_transit_02",
			"loc_psyker_male_b__zone_transit_03"
		},
		sound_events_duration = {
			5.513708,
			6.412979,
			1.909729,
			3.250042,
			3.759708,
			3.257458
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
			[1.0] = "loc_psyker_male_b__level_hab_block_temple_01",
			[2.0] = "loc_psyker_male_b__level_hab_block_temple_02"
		},
		sound_events_duration = {
			[1.0] = 3.340021,
			[2.0] = 5.126146
		},
		randomize_indexes = {}
	},
	level_hab_block_temple_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_01",
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_02",
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_03",
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_04",
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_05",
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_06",
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_07",
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_08",
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_09",
			"loc_psyker_male_b__nurgle_circumstance_prop_growth_10"
		},
		sound_events_duration = {
			3.265458,
			3.278479,
			3.485813,
			5.166271,
			3.861167,
			7.954333,
			7.075354,
			4.114208,
			4.667083,
			5.850188
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
			[1.0] = "loc_psyker_male_b__level_hab_block_vista_01",
			[2.0] = "loc_psyker_male_b__level_hab_block_vista_02"
		},
		sound_events_duration = {
			[1.0] = 3.872292,
			[2.0] = 5.867583
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_habs_psyker_male_b", mission_vo_cm_habs_psyker_male_b)
