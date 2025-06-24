﻿-- chunkname: @dialogues/generated/mission_vo_lm_scavenge_adamant_female_a.lua

local mission_vo_lm_scavenge_adamant_female_a = {
	mission_scavenge_daylight = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_scavenge_daylight_01",
		},
		sound_events_duration = {
			[1] = 5.132969,
		},
		randomize_indexes = {},
	},
	mission_scavenge_daylight_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_a__region_periferus_01",
			"loc_adamant_female_a__region_periferus_02",
			"loc_adamant_female_a__region_periferus_03",
		},
		sound_events_duration = {
			2.842354,
			3.776198,
			3.651438,
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
			[1] = "loc_adamant_female_a__mission_scavenge_servitors_01",
		},
		sound_events_duration = {
			[1] = 5.445073,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_scavenge_adamant_female_a", mission_vo_lm_scavenge_adamant_female_a)
