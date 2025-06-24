-- chunkname: @dialogues/generated/mission_vo_hm_cartel_adamant_male_a.lua

local mission_vo_hm_cartel_adamant_male_a = {
	asset_acid_clouds_mission_cartel = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_male_a__zone_watertown_acid_clouds_01",
			[2] = "loc_adamant_male_a__zone_watertown_acid_clouds_02",
		},
		sound_events_duration = {
			[1] = 3.561333,
			[2] = 5.60001,
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
			[1] = "loc_adamant_male_a__mission_cartel_mudlark_01",
		},
		sound_events_duration = {
			[1] = 5.38099,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_cartel_shanty_01",
		},
		sound_events_duration = {
			[1] = 4.291729,
		},
		randomize_indexes = {},
	},
	mission_cartel_shanty_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_a__zone_watertown_01",
			"loc_adamant_male_a__zone_watertown_02",
			"loc_adamant_male_a__zone_watertown_03",
		},
		sound_events_duration = {
			2.460677,
			3.144,
			2.65601,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_cartel_adamant_male_a", mission_vo_hm_cartel_adamant_male_a)
