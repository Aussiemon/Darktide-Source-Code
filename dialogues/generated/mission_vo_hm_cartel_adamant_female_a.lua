﻿-- chunkname: @dialogues/generated/mission_vo_hm_cartel_adamant_female_a.lua

local mission_vo_hm_cartel_adamant_female_a = {
	asset_acid_clouds_mission_cartel = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_a__zone_watertown_acid_clouds_01",
			[2] = "loc_adamant_female_a__zone_watertown_acid_clouds_02",
		},
		sound_events_duration = {
			[1] = 4.160198,
			[2] = 4.885208,
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
			[1] = "loc_adamant_female_a__mission_cartel_mudlark_01",
		},
		sound_events_duration = {
			[1] = 4.569531,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_cartel_shanty_01",
		},
		sound_events_duration = {
			[1] = 4.137063,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_a__zone_watertown_01",
			"loc_adamant_female_a__zone_watertown_02",
			"loc_adamant_female_a__zone_watertown_03",
		},
		sound_events_duration = {
			1.945281,
			3.465292,
			2.290073,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_cartel_adamant_female_a", mission_vo_hm_cartel_adamant_female_a)
