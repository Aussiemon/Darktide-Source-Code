-- chunkname: @dialogues/generated/mission_vo_dm_propaganda_adamant_male_b.lua

local mission_vo_dm_propaganda_adamant_male_b = {
	mission_propaganda_short_elevator_conversation_one_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_propaganda_short_elevator_conversation_one_a_01",
		},
		sound_events_duration = {
			[1] = 4.803021,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_three_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_propaganda_short_elevator_conversation_three_a_01",
		},
		sound_events_duration = {
			[1] = 3.380469,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_two_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_propaganda_short_elevator_conversation_two_a_01",
		},
		sound_events_duration = {
			[1] = 2.561917,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_propaganda_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 3.448948,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_b__region_periferus_01",
			"loc_adamant_male_b__region_periferus_02",
			"loc_adamant_male_b__region_periferus_03",
			"loc_adamant_male_b__zone_dust_01",
			"loc_adamant_male_b__zone_dust_02",
			"loc_adamant_male_b__zone_dust_03",
		},
		sound_events_duration = {
			3.81176,
			4.241104,
			3.209542,
			2.903281,
			1.909438,
			4.515177,
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

return settings("mission_vo_dm_propaganda_adamant_male_b", mission_vo_dm_propaganda_adamant_male_b)
