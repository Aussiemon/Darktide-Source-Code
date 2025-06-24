-- chunkname: @dialogues/generated/mission_vo_hm_complex_adamant_female_c.lua

local mission_vo_hm_complex_adamant_female_c = {
	mission_complex_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_complex_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 4.421115,
		},
		randomize_indexes = {},
	},
	mission_complex_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_c__zone_throneside_01",
			"loc_adamant_female_c__zone_throneside_02",
			"loc_adamant_female_c__zone_throneside_03",
		},
		sound_events_duration = {
			3.70024,
			4.810135,
			3.945656,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_complex_adamant_female_c", mission_vo_hm_complex_adamant_female_c)
