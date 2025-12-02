-- chunkname: @dialogues/generated/mission_vo_cm_habs_remake_broker_female_b.lua

local mission_vo_cm_habs_remake_broker_female_b = {
	info_extraction_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__info_extraction_response_01",
			[2] = "loc_broker_female_b__info_extraction_response_02",
		},
		sound_events_duration = {
			[1] = 1.081792,
			[2] = 2.139771,
		},
		randomize_indexes = {},
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_female_b__guidance_starting_area_01",
			"loc_broker_female_b__guidance_starting_area_02",
			"loc_broker_female_b__guidance_starting_area_03",
			"loc_broker_female_b__guidance_starting_area_04",
			"loc_broker_female_b__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.989708,
			3.952698,
			3.021573,
			3.366896,
			2.885917,
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_habs_remake_broker_female_b", mission_vo_cm_habs_remake_broker_female_b)
