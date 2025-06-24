-- chunkname: @dialogues/generated/mission_vo_lm_rails_adamant_male_b.lua

local mission_vo_lm_rails_adamant_male_b = {
	mission_rails_disable_skyfire_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_rails_disable_skyfire_a_01",
		},
		sound_events_duration = {
			[1] = 3.221854,
		},
		randomize_indexes = {},
	},
	mission_rails_refectory_response = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_b__region_habculum_01",
			"loc_adamant_male_b__region_habculum_02",
			"loc_adamant_male_b__region_habculum_03",
			"loc_adamant_male_b__zone_transit_01",
			"loc_adamant_male_b__zone_transit_02",
			"loc_adamant_male_b__zone_transit_03",
		},
		sound_events_duration = {
			2.95174,
			2.910594,
			2.018958,
			3.509448,
			2.92375,
			4.13424,
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
			[1] = "loc_adamant_male_b__mission_rails_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 3.634875,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_rails_adamant_male_b", mission_vo_lm_rails_adamant_male_b)
