-- chunkname: @dialogues/generated/mission_vo_km_enforcer_adamant_male_c.lua

local mission_vo_km_enforcer_adamant_male_c = {
	mission_enforcer_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_enforcer_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 2.83399,
		},
		randomize_indexes = {},
	},
	mission_enforcer_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_c__region_habculum_01",
			"loc_adamant_male_c__region_habculum_02",
			"loc_adamant_male_c__region_habculum_03",
			"loc_adamant_male_c__zone_watertown_01",
			"loc_adamant_male_c__zone_watertown_02",
			"loc_adamant_male_c__zone_watertown_03",
		},
		sound_events_duration = {
			5.100792,
			3.458396,
			3.785479,
			3.014667,
			2.793333,
			3.386,
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

return settings("mission_vo_km_enforcer_adamant_male_c", mission_vo_km_enforcer_adamant_male_c)
