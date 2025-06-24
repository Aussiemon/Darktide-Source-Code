-- chunkname: @dialogues/generated/mission_vo_dm_rise_adamant_male_b.lua

local mission_vo_dm_rise_adamant_male_b = {
	mission_rise_start_b_sergeant_branch = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__region_habculum_01",
			"loc_adamant_male_b__region_habculum_02",
			"loc_adamant_male_b__region_habculum_03",
		},
		sound_events_duration = {
			2.95174,
			2.910594,
			2.018958,
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
			"loc_adamant_male_b__zone_transit_01",
			"loc_adamant_male_b__zone_transit_02",
			"loc_adamant_male_b__zone_transit_03",
		},
		sound_events_duration = {
			3.509448,
			2.92375,
			4.13424,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_adamant_male_b", mission_vo_dm_rise_adamant_male_b)
