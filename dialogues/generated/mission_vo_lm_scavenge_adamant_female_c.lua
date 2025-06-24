-- chunkname: @dialogues/generated/mission_vo_lm_scavenge_adamant_female_c.lua

local mission_vo_lm_scavenge_adamant_female_c = {
	mission_scavenge_daylight = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_scavenge_daylight_01",
		},
		sound_events_duration = {
			[1] = 1.813854,
		},
		randomize_indexes = {},
	},
	mission_scavenge_daylight_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_c__region_periferus_01",
			"loc_adamant_female_c__region_periferus_02",
			"loc_adamant_female_c__region_periferus_03",
		},
		sound_events_duration = {
			3.853708,
			3.757813,
			3.600125,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_scavenge_servitors = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_scavenge_servitors_01",
		},
		sound_events_duration = {
			[1] = 3.778375,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_scavenge_adamant_female_c", mission_vo_lm_scavenge_adamant_female_c)
