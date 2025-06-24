-- chunkname: @dialogues/generated/mission_vo_lm_scavenge_adamant_male_b.lua

local mission_vo_lm_scavenge_adamant_male_b = {
	mission_scavenge_daylight = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_scavenge_daylight_01",
		},
		sound_events_duration = {
			[1] = 3.110094,
		},
		randomize_indexes = {},
	},
	mission_scavenge_daylight_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__region_periferus_01",
			"loc_adamant_male_b__region_periferus_02",
			"loc_adamant_male_b__region_periferus_03",
		},
		sound_events_duration = {
			3.81176,
			4.241104,
			3.209542,
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
			[1] = "loc_adamant_male_b__mission_scavenge_servitors_01",
		},
		sound_events_duration = {
			[1] = 3.02401,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_scavenge_adamant_male_b", mission_vo_lm_scavenge_adamant_male_b)
