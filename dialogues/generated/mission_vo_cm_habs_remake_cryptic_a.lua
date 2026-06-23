-- chunkname: @dialogues/generated/mission_vo_cm_habs_remake_cryptic_a.lua

local mission_vo_cm_habs_remake_cryptic_a = {
	info_extraction_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_a__info_extraction_response_01",
			[2] = "loc_cryptic_a__info_extraction_response_02",
		},
		sound_events_duration = {
			[1] = 3.020365,
			[2] = 3.162094,
		},
		randomize_indexes = {},
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_cryptic_a__guidance_starting_area_01",
			"loc_cryptic_a__guidance_starting_area_02",
			"loc_cryptic_a__guidance_starting_area_03",
			"loc_cryptic_a__guidance_starting_area_04",
			"loc_cryptic_a__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.090448,
			5.155135,
			4.769115,
			4.514323,
			3.760938,
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

return settings("mission_vo_cm_habs_remake_cryptic_a", mission_vo_cm_habs_remake_cryptic_a)
