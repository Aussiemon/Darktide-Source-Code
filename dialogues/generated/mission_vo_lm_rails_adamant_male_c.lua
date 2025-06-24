﻿-- chunkname: @dialogues/generated/mission_vo_lm_rails_adamant_male_c.lua

local mission_vo_lm_rails_adamant_male_c = {
	mission_rails_disable_skyfire_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_rails_disable_skyfire_a_01",
		},
		sound_events_duration = {
			[1] = 4.254313,
		},
		randomize_indexes = {},
	},
	mission_rails_refectory_response = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_c__region_habculum_01",
			"loc_adamant_male_c__region_habculum_02",
			"loc_adamant_male_c__region_habculum_03",
			"loc_adamant_male_c__zone_transit_01",
			"loc_adamant_male_c__zone_transit_02",
			"loc_adamant_male_c__zone_transit_03",
		},
		sound_events_duration = {
			5.100792,
			3.458396,
			3.785479,
			3.849333,
			5.022667,
			3.636,
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
			[1] = "loc_adamant_male_c__mission_rails_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 6.481188,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_rails_adamant_male_c", mission_vo_lm_rails_adamant_male_c)
