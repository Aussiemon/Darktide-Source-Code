local mission_vo_cm_habs_psyker_male_a = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_male_a__region_habculum_01",
			"loc_psyker_male_a__region_habculum_02",
			"loc_psyker_male_a__region_habculum_03"
		},
		sound_events_duration = {
			4.298729,
			6.468,
			3.644604
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
			[1.0] = "loc_psyker_male_a__level_hab_block_atrium_01",
			[2.0] = "loc_psyker_male_a__level_hab_block_atrium_02"
		},
		sound_events_duration = {
			[1.0] = 6.549313,
			[2.0] = 6.090583
		},
		randomize_indexes = {}
	},
	level_hab_block_b_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_a__level_hab_block_b_response_b_01",
			[2.0] = "loc_psyker_male_a__level_hab_block_b_response_b_02"
		},
		sound_events_duration = {
			[1.0] = 2.682771,
			[2.0] = 4.39925
		},
		randomize_indexes = {}
	},
	level_hab_block_market_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_a__level_hab_block_market_response_01",
			[2.0] = "loc_psyker_male_a__level_hab_block_market_response_02"
		},
		sound_events_duration = {
			[1.0] = 3.943,
			[2.0] = 3.042958
		},
		randomize_indexes = {}
	},
	level_hab_block_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_a__level_hab_block_void_01",
			[2.0] = "loc_psyker_male_a__level_hab_block_void_02"
		},
		sound_events_duration = {
			[1.0] = 3.610458,
			[2.0] = 3.863396
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
			"loc_psyker_male_a__region_habculum_01",
			"loc_psyker_male_a__region_habculum_02",
			"loc_psyker_male_a__region_habculum_03",
			"loc_psyker_male_a__zone_transit_01",
			"loc_psyker_male_a__zone_transit_02",
			"loc_psyker_male_a__zone_transit_03"
		},
		sound_events_duration = {
			4.298729,
			6.468,
			3.644604,
			7.510313,
			3.483229,
			5.392188
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
			[1.0] = "loc_psyker_male_a__level_hab_block_temple_01",
			[2.0] = "loc_psyker_male_a__level_hab_block_temple_02"
		},
		sound_events_duration = {
			[1.0] = 4.966083,
			[2.0] = 5.714292
		},
		randomize_indexes = {}
	},
	level_hab_block_temple_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_01",
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_02",
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_03",
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_04",
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_05",
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_06",
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_07",
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_08",
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_09",
			"loc_psyker_male_a__nurgle_circumstance_prop_growth_10"
		},
		sound_events_duration = {
			3.500188,
			3.159583,
			5.105563,
			4.766396,
			3.228083,
			3.537438,
			4.874333,
			5.065875,
			7.21475,
			7.653375
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
			[1.0] = "loc_psyker_male_a__level_hab_block_vista_01",
			[2.0] = "loc_psyker_male_a__level_hab_block_vista_02"
		},
		sound_events_duration = {
			[1.0] = 4.898146,
			[2.0] = 4.485708
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_habs_psyker_male_a", mission_vo_cm_habs_psyker_male_a)
