-- chunkname: @dialogues/generated/mission_vo_lm_rails_adamant_female_b.lua

local mission_vo_lm_rails_adamant_female_b = {
	mission_rails_disable_skyfire_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_rails_disable_skyfire_a_01",
		},
		sound_events_duration = {
			[1] = 3.801406,
		},
		randomize_indexes = {},
	},
	mission_rails_refectory_response = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_female_b__region_habculum_01",
			"loc_adamant_female_b__region_habculum_02",
			"loc_adamant_female_b__region_habculum_03",
			"loc_adamant_female_b__zone_transit_01",
			"loc_adamant_female_b__zone_transit_02",
			"loc_adamant_female_b__zone_transit_03",
		},
		sound_events_duration = {
			3.029344,
			3.230677,
			2.259333,
			4.478677,
			3.972677,
			4.806677,
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
			[1] = "loc_adamant_female_b__mission_rails_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 4.527813,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_rails_adamant_female_b", mission_vo_lm_rails_adamant_female_b)
