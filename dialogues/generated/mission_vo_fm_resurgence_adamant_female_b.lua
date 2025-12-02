-- chunkname: @dialogues/generated/mission_vo_fm_resurgence_adamant_female_b.lua

local mission_vo_fm_resurgence_adamant_female_b = {
	luggable_mission_pick_up_fm_resurgence = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_b__luggable_mission_pick_up_01",
			[2] = "loc_adamant_female_b__luggable_mission_pick_up_02",
		},
		sound_events_duration = {
			[1] = 2.796677,
			[2] = 3.858677,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	mission_resurgence_boulevard_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_b__zone_throneside_01",
			"loc_adamant_female_b__zone_throneside_02",
			"loc_adamant_female_b__zone_throneside_03",
		},
		sound_events_duration = {
			6.028677,
			3.609344,
			3.25001,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_resurgence_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_b__guidance_starting_area_01",
			"loc_adamant_female_b__guidance_starting_area_02",
			"loc_adamant_female_b__guidance_starting_area_03",
			"loc_adamant_female_b__guidance_starting_area_04",
			"loc_adamant_female_b__guidance_starting_area_05",
			"loc_adamant_female_b__guidance_starting_area_06",
			"loc_adamant_female_b__guidance_starting_area_07",
			"loc_adamant_female_b__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.489438,
			2.14924,
			3.805177,
			3.799354,
			4.19201,
			3.705521,
			2.911885,
			3.076052,
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
	mission_resurgence_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_resurgence_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 5.00199,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_fm_resurgence_adamant_female_b", mission_vo_fm_resurgence_adamant_female_b)
