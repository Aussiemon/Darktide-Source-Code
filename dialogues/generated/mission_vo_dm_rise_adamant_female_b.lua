-- chunkname: @dialogues/generated/mission_vo_dm_rise_adamant_female_b.lua

local mission_vo_dm_rise_adamant_female_b = {
	mission_rise_start_b_sergeant_branch = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_b__region_habculum_01",
			"loc_adamant_female_b__region_habculum_02",
			"loc_adamant_female_b__region_habculum_03",
		},
		sound_events_duration = {
			3.029344,
			3.230677,
			2.259333,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_rise_start_b_sergeant_branch_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_b__zone_transit_01",
			"loc_adamant_female_b__zone_transit_02",
			"loc_adamant_female_b__zone_transit_03",
		},
		sound_events_duration = {
			4.478677,
			3.972677,
			4.806677,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_adamant_female_b", mission_vo_dm_rise_adamant_female_b)
