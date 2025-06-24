-- chunkname: @dialogues/generated/mission_vo_dm_rise_adamant_male_c.lua

local mission_vo_dm_rise_adamant_male_c = {
	mission_rise_start_b_sergeant_branch = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_c__region_habculum_01",
			"loc_adamant_male_c__region_habculum_02",
			"loc_adamant_male_c__region_habculum_03",
		},
		sound_events_duration = {
			5.100792,
			3.458396,
			3.785479,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_rise_start_b_sergeant_branch_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_c__zone_transit_01",
			"loc_adamant_male_c__zone_transit_02",
			"loc_adamant_male_c__zone_transit_03",
		},
		sound_events_duration = {
			3.849333,
			5.022667,
			3.636,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_adamant_male_c", mission_vo_dm_rise_adamant_male_c)
