-- chunkname: @dialogues/generated/mission_vo_dm_propaganda_adamant_female_b.lua

local mission_vo_dm_propaganda_adamant_female_b = {
	mission_propaganda_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_b__guidance_starting_area_01",
			"loc_adamant_female_b__guidance_starting_area_02",
			"loc_adamant_female_b__guidance_starting_area_03",
			"loc_adamant_female_b__guidance_starting_area_04",
			"loc_adamant_female_b__guidance_starting_area_05",
			"loc_adamant_female_b__guidance_starting_area_06",
			"loc_adamant_female_b__guidance_starting_area_07",
			"loc_adamant_female_b__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.489438,
			2.14924,
			3.805177,
			3.799354,
			4.19201,
			3.705521,
			2.911885,
			3.076052,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_one_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_propaganda_short_elevator_conversation_one_a_01",
		},
		sound_events_duration = {
			[1] = 4.491115,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_three_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_propaganda_short_elevator_conversation_three_a_01",
		},
		sound_events_duration = {
			[1] = 3.419604,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_two_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_propaganda_short_elevator_conversation_two_a_01",
		},
		sound_events_duration = {
			[1] = 3.345073,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_propaganda_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 4.038896,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_female_b__region_periferus_01",
			"loc_adamant_female_b__region_periferus_02",
			"loc_adamant_female_b__region_periferus_03",
			"loc_adamant_female_b__zone_dust_01",
			"loc_adamant_female_b__zone_dust_02",
			"loc_adamant_female_b__zone_dust_03",
		},
		sound_events_duration = {
			4.278677,
			3.882677,
			3.411344,
			3.290677,
			1.96401,
			4.638677,
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

return settings("mission_vo_dm_propaganda_adamant_female_b", mission_vo_dm_propaganda_adamant_female_b)
