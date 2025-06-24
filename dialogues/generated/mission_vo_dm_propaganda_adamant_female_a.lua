-- chunkname: @dialogues/generated/mission_vo_dm_propaganda_adamant_female_a.lua

local mission_vo_dm_propaganda_adamant_female_a = {
	mission_propaganda_short_elevator_conversation_one_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_propaganda_short_elevator_conversation_one_a_01",
		},
		sound_events_duration = {
			[1] = 3.81751,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_three_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_propaganda_short_elevator_conversation_three_a_01",
		},
		sound_events_duration = {
			[1] = 4.045958,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_two_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_propaganda_short_elevator_conversation_two_a_01",
		},
		sound_events_duration = {
			[1] = 4.432417,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_propaganda_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 4.678146,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_female_a__region_periferus_01",
			"loc_adamant_female_a__region_periferus_02",
			"loc_adamant_female_a__region_periferus_03",
			"loc_adamant_female_a__zone_dust_01",
			"loc_adamant_female_a__zone_dust_02",
			"loc_adamant_female_a__zone_dust_03",
		},
		sound_events_duration = {
			2.842354,
			3.776198,
			3.651438,
			1.882969,
			4.136594,
			4.538771,
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

return settings("mission_vo_dm_propaganda_adamant_female_a", mission_vo_dm_propaganda_adamant_female_a)
