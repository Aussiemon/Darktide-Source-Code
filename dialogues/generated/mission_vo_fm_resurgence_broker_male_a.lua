-- chunkname: @dialogues/generated/mission_vo_fm_resurgence_broker_male_a.lua

local mission_vo_fm_resurgence_broker_male_a = {
	luggable_mission_pick_up_fm_resurgence = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__luggable_mission_pick_up_01",
			[2] = "loc_broker_male_a__luggable_mission_pick_up_02",
		},
		sound_events_duration = {
			[1] = 3.12226,
			[2] = 5.376552,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	mission_resurgence_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_male_a__guidance_starting_area_01",
			"loc_broker_male_a__guidance_starting_area_02",
			"loc_broker_male_a__guidance_starting_area_03",
			"loc_broker_male_a__guidance_starting_area_04",
			"loc_broker_male_a__guidance_starting_area_05",
		},
		sound_events_duration = {
			4.146938,
			3.423625,
			2.380875,
			5.720115,
			2.603885,
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

return settings("mission_vo_fm_resurgence_broker_male_a", mission_vo_fm_resurgence_broker_male_a)
