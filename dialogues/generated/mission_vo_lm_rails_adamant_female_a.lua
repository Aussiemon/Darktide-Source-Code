-- chunkname: @dialogues/generated/mission_vo_lm_rails_adamant_female_a.lua

local mission_vo_lm_rails_adamant_female_a = {
	mission_rails_disable_skyfire_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_rails_disable_skyfire_a_01",
		},
		sound_events_duration = {
			[1] = 3.100198,
		},
		randomize_indexes = {},
	},
	mission_rails_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_a__guidance_starting_area_01",
			"loc_adamant_female_a__guidance_starting_area_02",
			"loc_adamant_female_a__guidance_starting_area_03",
			"loc_adamant_female_a__guidance_starting_area_04",
			"loc_adamant_female_a__guidance_starting_area_05",
			"loc_adamant_female_a__guidance_starting_area_06",
			"loc_adamant_female_a__guidance_starting_area_07",
			"loc_adamant_female_a__guidance_starting_area_08",
		},
		sound_events_duration = {
			1.302021,
			2.593021,
			3.317521,
			3.8065,
			2.848792,
			3.968281,
			2.085708,
			4.802833,
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
			"loc_adamant_female_a__region_habculum_01",
			"loc_adamant_female_a__region_habculum_02",
			"loc_adamant_female_a__region_habculum_03",
			"loc_adamant_female_a__zone_transit_01",
			"loc_adamant_female_a__zone_transit_02",
			"loc_adamant_female_a__zone_transit_03",
		},
		sound_events_duration = {
			3.809615,
			4.015438,
			4.570906,
			1.932375,
			2.098385,
			2.513219,
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
			[1] = "loc_adamant_female_a__mission_rails_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 4.732198,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_rails_adamant_female_a", mission_vo_lm_rails_adamant_female_a)
