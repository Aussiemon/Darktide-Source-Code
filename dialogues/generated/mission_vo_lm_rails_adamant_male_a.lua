-- chunkname: @dialogues/generated/mission_vo_lm_rails_adamant_male_a.lua

local mission_vo_lm_rails_adamant_male_a = {
	mission_rails_disable_skyfire_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_rails_disable_skyfire_a_01",
		},
		sound_events_duration = {
			[1] = 3.005396,
		},
		randomize_indexes = {},
	},
	mission_rails_refectory_response = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_a__region_habculum_01",
			"loc_adamant_male_a__region_habculum_02",
			"loc_adamant_male_a__region_habculum_03",
			"loc_adamant_male_a__zone_transit_01",
			"loc_adamant_male_a__zone_transit_02",
			"loc_adamant_male_a__zone_transit_03",
		},
		sound_events_duration = {
			4.21601,
			4.61601,
			5.23201,
			1.785344,
			2.233344,
			2.946677,
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
			[1] = "loc_adamant_male_a__mission_rails_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 5.262354,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_rails_adamant_male_a", mission_vo_lm_rails_adamant_male_a)
