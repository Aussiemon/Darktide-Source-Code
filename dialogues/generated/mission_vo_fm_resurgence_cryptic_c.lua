-- chunkname: @dialogues/generated/mission_vo_fm_resurgence_cryptic_c.lua

local mission_vo_fm_resurgence_cryptic_c = {
	luggable_mission_pick_up_fm_resurgence = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__luggable_mission_pick_up_01",
			[2] = "loc_cryptic_c__luggable_mission_pick_up_02",
		},
		sound_events_duration = {
			[1] = 2.60474,
			[2] = 3.186594,
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
			"loc_cryptic_c__guidance_starting_area_01",
			"loc_cryptic_c__guidance_starting_area_02",
			"loc_cryptic_c__guidance_starting_area_03",
			"loc_cryptic_c__guidance_starting_area_04",
			"loc_cryptic_c__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.623542,
			3.451458,
			2.55001,
			3.043302,
			5.726906,
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

return settings("mission_vo_fm_resurgence_cryptic_c", mission_vo_fm_resurgence_cryptic_c)
