-- chunkname: @dialogues/generated/mission_vo_lm_cooling_adamant_male_b.lua

local mission_vo_lm_cooling_adamant_male_b = {
	info_mission_cooling_vents_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__zone_tank_foundry_01",
			"loc_adamant_male_b__zone_tank_foundry_02",
			"loc_adamant_male_b__zone_tank_foundry_03",
		},
		sound_events_duration = {
			2.649396,
			3.449958,
			4.36201,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_cooling_heat = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_cooling_heat_01",
		},
		sound_events_duration = {
			[1] = 4.933677,
		},
		randomize_indexes = {},
	},
	mission_cooling_heat_response_two = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__region_mechanicus_01",
			"loc_adamant_male_b__region_mechanicus_02",
			"loc_adamant_male_b__region_mechanicus_03",
		},
		sound_events_duration = {
			3.802344,
			4.56775,
			5.080719,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_cooling_leaving = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_cooling_leaving_01",
		},
		sound_events_duration = {
			[1] = 2.577885,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_cooling_adamant_male_b", mission_vo_lm_cooling_adamant_male_b)
