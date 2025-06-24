﻿-- chunkname: @dialogues/generated/mission_vo_hm_cartel_adamant_male_b.lua

local mission_vo_hm_cartel_adamant_male_b = {
	asset_acid_clouds_mission_cartel = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_male_b__zone_watertown_acid_clouds_01",
			[2] = "loc_adamant_male_b__zone_watertown_acid_clouds_02",
		},
		sound_events_duration = {
			[1] = 4.464125,
			[2] = 6.356531,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	mission_cartel_mudlark = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_cartel_mudlark_01",
		},
		sound_events_duration = {
			[1] = 2.499,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_cartel_shanty_01",
		},
		sound_events_duration = {
			[1] = 4.796104,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__zone_watertown_01",
			"loc_adamant_male_b__zone_watertown_02",
			"loc_adamant_male_b__zone_watertown_03",
		},
		sound_events_duration = {
			4.103385,
			2.515896,
			6.788458,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_cartel_adamant_male_b", mission_vo_hm_cartel_adamant_male_b)
