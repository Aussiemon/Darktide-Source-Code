-- chunkname: @dialogues/generated/mission_vo_lm_rails_adamant_female_c.lua

local mission_vo_lm_rails_adamant_female_c = {
	mission_rails_disable_skyfire_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_rails_disable_skyfire_a_01",
		},
		sound_events_duration = {
			[1] = 3.005688,
		},
		randomize_indexes = {},
	},
	mission_rails_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_c__guidance_starting_area_01",
			"loc_adamant_female_c__guidance_starting_area_02",
			"loc_adamant_female_c__guidance_starting_area_03",
			"loc_adamant_female_c__guidance_starting_area_04",
			"loc_adamant_female_c__guidance_starting_area_05",
			"loc_adamant_female_c__guidance_starting_area_06",
			"loc_adamant_female_c__guidance_starting_area_07",
			"loc_adamant_female_c__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.282708,
			2.790948,
			2.620156,
			2.567042,
			2.132865,
			2.604115,
			2.831365,
			2.629792,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
	mission_rails_refectory_response = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_female_c__region_habculum_01",
			"loc_adamant_female_c__region_habculum_02",
			"loc_adamant_female_c__region_habculum_03",
			"loc_adamant_female_c__zone_transit_01",
			"loc_adamant_female_c__zone_transit_02",
			"loc_adamant_female_c__zone_transit_03",
		},
		sound_events_duration = {
			4.67876,
			3.265594,
			3.567938,
			3.439479,
			4.728438,
			4.889583,
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
	mission_rails_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_rails_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 5.291448,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_rails_adamant_female_c", mission_vo_lm_rails_adamant_female_c)
