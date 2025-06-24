-- chunkname: @dialogues/generated/mission_vo_hm_cartel_adamant_female_c.lua

local mission_vo_hm_cartel_adamant_female_c = {
	asset_acid_clouds_mission_cartel = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_c__zone_watertown_acid_clouds_01",
			[2] = "loc_adamant_female_c__zone_watertown_acid_clouds_02",
		},
		sound_events_duration = {
			[1] = 3.480677,
			[2] = 5.304833,
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
			[1] = "loc_adamant_female_c__mission_cartel_mudlark_01",
		},
		sound_events_duration = {
			[1] = 2.526552,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_cartel_shanty_01",
		},
		sound_events_duration = {
			[1] = 2.61926,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_c__zone_watertown_01",
			"loc_adamant_female_c__zone_watertown_02",
			"loc_adamant_female_c__zone_watertown_03",
		},
		sound_events_duration = {
			2.757531,
			2.499698,
			3.361615,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_cartel_adamant_female_c", mission_vo_hm_cartel_adamant_female_c)
