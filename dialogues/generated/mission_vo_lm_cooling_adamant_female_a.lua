-- chunkname: @dialogues/generated/mission_vo_lm_cooling_adamant_female_a.lua

local mission_vo_lm_cooling_adamant_female_a = {
	info_mission_cooling_vents_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_a__zone_tank_foundry_01",
			"loc_adamant_female_a__zone_tank_foundry_02",
			"loc_adamant_female_a__zone_tank_foundry_03",
		},
		sound_events_duration = {
			2.576302,
			3.465802,
			4.171031,
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
			[1] = "loc_adamant_female_a__mission_cooling_heat_01",
		},
		sound_events_duration = {
			[1] = 5.32349,
		},
		randomize_indexes = {},
	},
	mission_cooling_heat_response_two = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_a__region_mechanicus_01",
			"loc_adamant_female_a__region_mechanicus_02",
			"loc_adamant_female_a__region_mechanicus_03",
		},
		sound_events_duration = {
			3.359177,
			3.79026,
			2.889688,
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
			[1] = "loc_adamant_female_a__mission_cooling_leaving_01",
		},
		sound_events_duration = {
			[1] = 4.082365,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_cooling_adamant_female_a", mission_vo_lm_cooling_adamant_female_a)
