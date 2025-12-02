-- chunkname: @dialogues/generated/mission_vo_cm_habs_remake_adamant_female_a.lua

local mission_vo_cm_habs_remake_adamant_female_a = {
	info_extraction_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_a__info_extraction_response_01",
			[2] = "loc_adamant_female_a__info_extraction_response_02",
		},
		sound_events_duration = {
			[1] = 2.773729,
			[2] = 3.423844,
		},
		randomize_indexes = {},
	},
	mission_habs_redux_start_zone_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_a__guidance_starting_area_01",
			"loc_adamant_female_a__guidance_starting_area_02",
			"loc_adamant_female_a__guidance_starting_area_03",
			"loc_adamant_female_a__guidance_starting_area_04",
			"loc_adamant_female_a__guidance_starting_area_05",
			"loc_adamant_female_a__guidance_starting_area_06",
			"loc_adamant_female_a__guidance_starting_area_07",
			"loc_adamant_female_a__guidance_starting_area_08",
		},
		sound_events_duration = {
			1.302021,
			2.593021,
			3.317521,
			3.8065,
			2.848792,
			3.968281,
			2.085708,
			4.802833,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_habs_remake_adamant_female_a", mission_vo_cm_habs_remake_adamant_female_a)
