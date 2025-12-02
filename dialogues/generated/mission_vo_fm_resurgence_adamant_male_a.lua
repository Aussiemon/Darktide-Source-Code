-- chunkname: @dialogues/generated/mission_vo_fm_resurgence_adamant_male_a.lua

local mission_vo_fm_resurgence_adamant_male_a = {
	luggable_mission_pick_up_fm_resurgence = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_male_a__luggable_mission_pick_up_01",
			[2] = "loc_adamant_male_a__luggable_mission_pick_up_02",
		},
		sound_events_duration = {
			[1] = 3.4,
			[2] = 4.954667,
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
			"loc_adamant_male_a__zone_throneside_01",
			"loc_adamant_male_a__zone_throneside_02",
			"loc_adamant_male_a__zone_throneside_03",
		},
		sound_events_duration = {
			3.03001,
			1.749344,
			3.894677,
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
			"loc_adamant_male_a__guidance_starting_area_01",
			"loc_adamant_male_a__guidance_starting_area_02",
			"loc_adamant_male_a__guidance_starting_area_03",
			"loc_adamant_male_a__guidance_starting_area_04",
			"loc_adamant_male_a__guidance_starting_area_05",
			"loc_adamant_male_a__guidance_starting_area_06",
			"loc_adamant_male_a__guidance_starting_area_07",
			"loc_adamant_male_a__guidance_starting_area_08",
		},
		sound_events_duration = {
			1.677333,
			3.262667,
			3.306667,
			4.317333,
			3.72,
			4.964,
			2.613333,
			5.453333,
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
			[1] = "loc_adamant_male_a__mission_resurgence_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 4.546854,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_fm_resurgence_adamant_male_a", mission_vo_fm_resurgence_adamant_male_a)
