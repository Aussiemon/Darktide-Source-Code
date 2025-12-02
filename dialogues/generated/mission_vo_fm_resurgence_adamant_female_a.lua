-- chunkname: @dialogues/generated/mission_vo_fm_resurgence_adamant_female_a.lua

local mission_vo_fm_resurgence_adamant_female_a = {
	luggable_mission_pick_up_fm_resurgence = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_a__luggable_mission_pick_up_01",
			[2] = "loc_adamant_female_a__luggable_mission_pick_up_02",
		},
		sound_events_duration = {
			[1] = 3.626604,
			[2] = 4.677427,
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
			"loc_adamant_female_a__zone_throneside_01",
			"loc_adamant_female_a__zone_throneside_02",
			"loc_adamant_female_a__zone_throneside_03",
		},
		sound_events_duration = {
			2.639917,
			2.068042,
			3.882344,
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
	mission_resurgence_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_resurgence_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 3.912813,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_fm_resurgence_adamant_female_a", mission_vo_fm_resurgence_adamant_female_a)
