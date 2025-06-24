-- chunkname: @dialogues/generated/mission_vo_cm_habs_adamant_female_a.lua

local mission_vo_cm_habs_adamant_female_a = {
	hab_block_void_response_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_a__region_habculum_01",
			"loc_adamant_female_a__region_habculum_02",
			"loc_adamant_female_a__region_habculum_03",
		},
		sound_events_duration = {
			3.809615,
			4.015438,
			4.570906,
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
			"loc_adamant_female_a__zone_transit_01",
			"loc_adamant_female_a__zone_transit_02",
			"loc_adamant_female_a__zone_transit_03",
		},
		sound_events_duration = {
			1.932375,
			2.098385,
			2.513219,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_habs_adamant_female_a", mission_vo_cm_habs_adamant_female_a)
