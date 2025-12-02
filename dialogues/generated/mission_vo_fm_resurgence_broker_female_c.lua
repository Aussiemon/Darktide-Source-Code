-- chunkname: @dialogues/generated/mission_vo_fm_resurgence_broker_female_c.lua

local mission_vo_fm_resurgence_broker_female_c = {
	luggable_mission_pick_up_fm_resurgence = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__luggable_mission_pick_up_01",
			[2] = "loc_broker_female_c__luggable_mission_pick_up_02",
		},
		sound_events_duration = {
			[1] = 3.918156,
			[2] = 4.354208,
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
			"loc_broker_female_c__guidance_starting_area_01",
			"loc_broker_female_c__guidance_starting_area_02",
			"loc_broker_female_c__guidance_starting_area_03",
			"loc_broker_female_c__guidance_starting_area_04",
			"loc_broker_female_c__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.094688,
			3.616292,
			3.610115,
			3.666156,
			3.74175,
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

return settings("mission_vo_fm_resurgence_broker_female_c", mission_vo_fm_resurgence_broker_female_c)
