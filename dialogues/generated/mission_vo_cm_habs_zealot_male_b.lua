-- chunkname: @dialogues/generated/mission_vo_cm_habs_zealot_male_b.lua

local mission_vo_cm_habs_zealot_male_b = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_zealot_male_b__region_habculum_01",
			"loc_zealot_male_b__region_habculum_02",
			"loc_zealot_male_b__region_habculum_03",
		},
		sound_events_duration = {
			4.635458,
			6.237438,
			2.444396,
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
			[1] = "loc_zealot_male_b__level_hab_block_atrium_01",
			[2] = "loc_zealot_male_b__level_hab_block_atrium_02",
		},
		sound_events_duration = {
			[1] = 8.269917,
			[2] = 7.595354,
		},
		randomize_indexes = {},
	},
	level_hab_block_b_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_b__level_hab_block_b_response_b_01",
			[2] = "loc_zealot_male_b__level_hab_block_b_response_b_02",
		},
		sound_events_duration = {
			[1] = 3.430917,
			[2] = 0.845354,
		},
		randomize_indexes = {},
	},
	level_hab_block_market_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_b__level_hab_block_market_response_01",
			[2] = "loc_zealot_male_b__level_hab_block_market_response_02",
		},
		sound_events_duration = {
			[1] = 4.992354,
			[2] = 5.908354,
		},
		randomize_indexes = {},
	},
	level_hab_block_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_b__level_hab_block_void_01",
			[2] = "loc_zealot_male_b__level_hab_block_void_02",
		},
		sound_events_duration = {
			[1] = 5.2065,
			[2] = 3.915313,
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
			"loc_zealot_male_b__region_habculum_01",
			"loc_zealot_male_b__region_habculum_02",
			"loc_zealot_male_b__region_habculum_03",
			"loc_zealot_male_b__zone_transit_01",
			"loc_zealot_male_b__zone_transit_02",
			"loc_zealot_male_b__zone_transit_03",
		},
		sound_events_duration = {
			4.635458,
			6.237438,
			2.444396,
			3.507083,
			4.100729,
			4.620688,
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
			[1] = "loc_zealot_male_b__level_hab_block_temple_01",
			[2] = "loc_zealot_male_b__level_hab_block_temple_02",
		},
		sound_events_duration = {
			[1] = 6.281979,
			[2] = 5.156708,
		},
		randomize_indexes = {},
	},
	level_hab_block_temple_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_01",
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_02",
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_03",
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_04",
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_05",
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_06",
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_07",
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_08",
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_09",
			"loc_zealot_male_b__nurgle_circumstance_prop_growth_10",
		},
		sound_events_duration = {
			3.2905,
			3.183854,
			4.324792,
			4.895271,
			4.135458,
			5.824771,
			3.831771,
			5.842583,
			3.343188,
			3.536354,
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
			[1] = "loc_zealot_male_b__level_hab_block_vista_01",
			[2] = "loc_zealot_male_b__level_hab_block_vista_02",
		},
		sound_events_duration = {
			[1] = 5.486688,
			[2] = 5.949063,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_habs_zealot_male_b", mission_vo_cm_habs_zealot_male_b)
