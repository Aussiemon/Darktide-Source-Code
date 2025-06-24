﻿-- chunkname: @dialogues/generated/mission_vo_dm_propaganda_adamant_male_c.lua

local mission_vo_dm_propaganda_adamant_male_c = {
	mission_propaganda_short_elevator_conversation_one_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_propaganda_short_elevator_conversation_one_a_01",
		},
		sound_events_duration = {
			[1] = 5.24101,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_three_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_propaganda_short_elevator_conversation_three_a_01",
		},
		sound_events_duration = {
			[1] = 4.360781,
		},
		randomize_indexes = {},
	},
	mission_propaganda_short_elevator_conversation_two_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_propaganda_short_elevator_conversation_two_a_01",
		},
		sound_events_duration = {
			[1] = 4.109396,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_propaganda_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 2.643208,
		},
		randomize_indexes = {},
	},
	mission_propaganda_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_c__region_periferus_01",
			"loc_adamant_male_c__region_periferus_02",
			"loc_adamant_male_c__region_periferus_03",
			"loc_adamant_male_c__zone_dust_01",
			"loc_adamant_male_c__zone_dust_02",
			"loc_adamant_male_c__zone_dust_03",
		},
		sound_events_duration = {
			5.05324,
			5.20225,
			4.028521,
			2.378667,
			4.020667,
			4.002,
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

return settings("mission_vo_dm_propaganda_adamant_male_c", mission_vo_dm_propaganda_adamant_male_c)
