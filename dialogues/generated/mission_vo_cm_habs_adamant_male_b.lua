-- chunkname: @dialogues/generated/mission_vo_cm_habs_adamant_male_b.lua

local mission_vo_cm_habs_adamant_male_b = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__region_habculum_01",
			"loc_adamant_male_b__region_habculum_02",
			"loc_adamant_male_b__region_habculum_03",
		},
		sound_events_duration = {
			2.95174,
			2.910594,
			2.018958,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	level_hab_block_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__zone_transit_01",
			"loc_adamant_male_b__zone_transit_02",
			"loc_adamant_male_b__zone_transit_03",
		},
		sound_events_duration = {
			3.509448,
			2.92375,
			4.13424,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_habs_adamant_male_b", mission_vo_cm_habs_adamant_male_b)
