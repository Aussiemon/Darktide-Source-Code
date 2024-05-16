-- chunkname: @dialogues/generated/mission_vo_cm_habs_ogryn_a.lua

local mission_vo_cm_habs_ogryn_a = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_ogryn_a__region_habculum_01",
			"loc_ogryn_a__region_habculum_02",
			"loc_ogryn_a__region_habculum_03",
		},
		sound_events_duration = {
			4.67974,
			5.885865,
			4.537323,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	level_hab_block_atrium = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_a__level_hab_block_atrium_01",
			[2] = "loc_ogryn_a__level_hab_block_atrium_02",
		},
		sound_events_duration = {
			[1] = 2.535469,
			[2] = 3.450552,
		},
		randomize_indexes = {},
	},
	level_hab_block_b_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_a__level_hab_block_b_response_b_01",
			[2] = "loc_ogryn_a__level_hab_block_b_response_b_02",
		},
		sound_events_duration = {
			[1] = 0.822313,
			[2] = 0.874896,
		},
		randomize_indexes = {},
	},
	level_hab_block_market_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_a__level_hab_block_market_response_01",
			[2] = "loc_ogryn_a__level_hab_block_market_response_02",
		},
		sound_events_duration = {
			[1] = 2.694375,
			[2] = 0.80875,
		},
		randomize_indexes = {},
	},
	level_hab_block_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_a__level_hab_block_void_01",
			[2] = "loc_ogryn_a__level_hab_block_void_02",
		},
		sound_events_duration = {
			[1] = 1.939688,
			[2] = 1.983729,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	level_hab_block_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_ogryn_a__region_habculum_01",
			"loc_ogryn_a__region_habculum_02",
			"loc_ogryn_a__region_habculum_03",
			"loc_ogryn_a__zone_transit_01",
			"loc_ogryn_a__zone_transit_02",
			"loc_ogryn_a__zone_transit_03",
		},
		sound_events_duration = {
			4.67974,
			5.885865,
			4.537323,
			2.323542,
			4.643531,
			3.577458,
		},
		sound_event_weights = {
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
		},
		randomize_indexes = {},
	},
	level_hab_block_temple = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_a__level_hab_block_temple_01",
			[2] = "loc_ogryn_a__level_hab_block_temple_02",
		},
		sound_events_duration = {
			[1] = 0.640521,
			[2] = 1.997646,
		},
		randomize_indexes = {},
	},
	level_hab_block_temple_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_a__nurgle_circumstance_prop_growth_01",
			"loc_ogryn_a__nurgle_circumstance_prop_growth_02",
			"loc_ogryn_a__nurgle_circumstance_prop_growth_03",
			"loc_ogryn_a__nurgle_circumstance_prop_growth_04",
			"loc_ogryn_a__nurgle_circumstance_prop_growth_05",
			"loc_ogryn_a__nurgle_circumstance_prop_growth_06",
			"loc_ogryn_a__nurgle_circumstance_prop_growth_07",
			"loc_ogryn_a__nurgle_circumstance_prop_growth_08",
			"loc_ogryn_a__nurgle_circumstance_prop_growth_09",
			"loc_ogryn_a__nurgle_circumstance_prop_growth_10",
		},
		sound_events_duration = {
			3.289833,
			2.632531,
			1.924073,
			3.05825,
			3.09701,
			4.06424,
			3.899573,
			2.304708,
			4.900719,
			4.884094,
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
			0.1,
		},
		randomize_indexes = {},
	},
	level_hab_block_vista = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_a__level_hab_block_vista_01",
			[2] = "loc_ogryn_a__level_hab_block_vista_02",
		},
		sound_events_duration = {
			[1] = 1.267167,
			[2] = 1.845604,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_habs_ogryn_a", mission_vo_cm_habs_ogryn_a)
