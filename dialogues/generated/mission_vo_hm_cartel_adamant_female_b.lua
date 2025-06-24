-- chunkname: @dialogues/generated/mission_vo_hm_cartel_adamant_female_b.lua

local mission_vo_hm_cartel_adamant_female_b = {
	asset_acid_clouds_mission_cartel = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_b__zone_watertown_acid_clouds_01",
			[2] = "loc_adamant_female_b__zone_watertown_acid_clouds_02",
		},
		sound_events_duration = {
			[1] = 3.441344,
			[2] = 4.006677,
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
			[1] = "loc_adamant_female_b__mission_cartel_mudlark_01",
		},
		sound_events_duration = {
			[1] = 2.889333,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_cartel_shanty_01",
		},
		sound_events_duration = {
			[1] = 5.49524,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_b__zone_watertown_01",
			"loc_adamant_female_b__zone_watertown_02",
			"loc_adamant_female_b__zone_watertown_03",
		},
		sound_events_duration = {
			4.357344,
			2.544344,
			5.910677,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_cartel_adamant_female_b", mission_vo_hm_cartel_adamant_female_b)
