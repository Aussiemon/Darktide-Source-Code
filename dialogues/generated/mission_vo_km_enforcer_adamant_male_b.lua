-- chunkname: @dialogues/generated/mission_vo_km_enforcer_adamant_male_b.lua

local mission_vo_km_enforcer_adamant_male_b = {
	mission_enforcer_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_enforcer_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 2.056823,
		},
		randomize_indexes = {},
	},
	mission_enforcer_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_b__region_habculum_01",
			"loc_adamant_male_b__region_habculum_02",
			"loc_adamant_male_b__region_habculum_03",
			"loc_adamant_male_b__zone_watertown_01",
			"loc_adamant_male_b__zone_watertown_02",
			"loc_adamant_male_b__zone_watertown_03",
		},
		sound_events_duration = {
			2.95174,
			2.910594,
			2.018958,
			4.103385,
			2.515896,
			6.788458,
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

return settings("mission_vo_km_enforcer_adamant_male_b", mission_vo_km_enforcer_adamant_male_b)
