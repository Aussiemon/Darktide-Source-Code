-- chunkname: @dialogues/generated/mission_vo_dm_propaganda_adamant_female_c.lua

local mission_vo_dm_propaganda_adamant_female_c = {
	mission_propaganda_short_elevator_conversation_one_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_propaganda_short_elevator_conversation_one_a_01",
		},
		sound_events_duration = {
			[1] = 6.058865,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_three_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_propaganda_short_elevator_conversation_three_a_01",
		},
		sound_events_duration = {
			[1] = 5.322594,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_two_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_propaganda_short_elevator_conversation_two_a_01",
		},
		sound_events_duration = {
			[1] = 3.106271,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_propaganda_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 3.677552,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_female_c__region_periferus_01",
			"loc_adamant_female_c__region_periferus_02",
			"loc_adamant_female_c__region_periferus_03",
			"loc_adamant_female_c__zone_dust_01",
			"loc_adamant_female_c__zone_dust_02",
			"loc_adamant_female_c__zone_dust_03",
		},
		sound_events_duration = {
			3.853708,
			3.757813,
			3.600125,
			2.503667,
			3.433281,
			3.519344,
		},
		sound_event_weights = {
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_propaganda_adamant_female_c", mission_vo_dm_propaganda_adamant_female_c)
