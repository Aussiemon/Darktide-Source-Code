-- chunkname: @dialogues/generated/mission_vo_lm_cooling_adamant_female_c.lua

local mission_vo_lm_cooling_adamant_female_c = {
	info_mission_cooling_vents_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_c__zone_tank_foundry_01",
			"loc_adamant_female_c__zone_tank_foundry_02",
			"loc_adamant_female_c__zone_tank_foundry_03",
		},
		sound_events_duration = {
			2.826583,
			4.40949,
			4.1895,
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
			[1] = "loc_adamant_female_c__mission_cooling_heat_01",
		},
		sound_events_duration = {
			[1] = 5.066375,
		},
		randomize_indexes = {},
	},
	mission_cooling_heat_response_two = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_c__region_mechanicus_02",
			[2] = "loc_adamant_female_c__region_mechanicus_03",
		},
		sound_events_duration = {
			[1] = 3.516042,
			[2] = 3.609,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	mission_cooling_leaving = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_cooling_leaving_01",
		},
		sound_events_duration = {
			[1] = 3.578667,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_lm_cooling_adamant_female_c", mission_vo_lm_cooling_adamant_female_c)
