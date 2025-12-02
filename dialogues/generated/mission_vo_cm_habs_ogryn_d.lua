-- chunkname: @dialogues/generated/mission_vo_cm_habs_ogryn_d.lua

local mission_vo_cm_habs_ogryn_d = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_ogryn_d__region_habculum_01",
			"loc_ogryn_d__region_habculum_02",
			"loc_ogryn_d__region_habculum_03",
		},
		sound_events_duration = {
			7.711094,
			10.09095,
			6.069583,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	level_hab_block_b_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__level_hab_block_b_response_b_01",
			[2] = "loc_ogryn_d__level_hab_block_b_response_b_02",
		},
		sound_events_duration = {
			[1] = 3.764146,
			[2] = 3.359344,
		},
		randomize_indexes = {},
	},
	level_hab_block_market_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__level_hab_block_market_response_01",
			[2] = "loc_ogryn_d__level_hab_block_market_response_02",
		},
		sound_events_duration = {
			[1] = 3.338313,
			[2] = 4.247802,
		},
		randomize_indexes = {},
	},
	level_hab_block_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__level_hab_block_void_01",
			[2] = "loc_ogryn_d__level_hab_block_void_02",
		},
		sound_events_duration = {
			[1] = 2.791563,
			[2] = 2.73374,
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
			"loc_ogryn_d__region_habculum_01",
			"loc_ogryn_d__region_habculum_02",
			"loc_ogryn_d__region_habculum_03",
			"loc_ogryn_d__zone_transit_01",
			"loc_ogryn_d__zone_transit_02",
			"loc_ogryn_d__zone_transit_03",
		},
		sound_events_duration = {
			7.711094,
			10.09095,
			6.069583,
			1.946885,
			2.456938,
			4.216208,
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
			[1] = "loc_ogryn_d__level_hab_block_temple_01",
			[2] = "loc_ogryn_d__level_hab_block_temple_02",
		},
		sound_events_duration = {
			[1] = 1.892594,
			[2] = 4.489635,
		},
		randomize_indexes = {},
	},
	level_hab_block_temple_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_ogryn_d__asset_nurgle_growth_01",
			"loc_ogryn_d__asset_nurgle_growth_02",
			"loc_ogryn_d__asset_nurgle_growth_03",
			"loc_ogryn_d__asset_nurgle_growth_04",
			"loc_ogryn_d__asset_nurgle_growth_05",
		},
		sound_events_duration = {
			2.049896,
			4.755698,
			2.872677,
			4.424396,
			3.724135,
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2,
		},
		randomize_indexes = {},
	},
	level_hab_block_vista = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__level_hab_block_vista_01",
			[2] = "loc_ogryn_d__level_hab_block_vista_02",
		},
		sound_events_duration = {
			[1] = 5.2595,
			[2] = 3.506542,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_habs_ogryn_d", mission_vo_cm_habs_ogryn_d)
