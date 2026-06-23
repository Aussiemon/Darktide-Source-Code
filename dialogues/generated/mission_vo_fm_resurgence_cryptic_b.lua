-- chunkname: @dialogues/generated/mission_vo_fm_resurgence_cryptic_b.lua

local mission_vo_fm_resurgence_cryptic_b = {
	luggable_mission_pick_up_fm_resurgence = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_b__luggable_mission_pick_up_01",
			[2] = "loc_cryptic_b__luggable_mission_pick_up_02",
		},
		sound_events_duration = {
			[1] = 2.77999,
			[2] = 2.70274,
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
			"loc_cryptic_b__guidance_starting_area_01",
			"loc_cryptic_b__guidance_starting_area_02",
			"loc_cryptic_b__guidance_starting_area_03",
			"loc_cryptic_b__guidance_starting_area_04",
			"loc_cryptic_b__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.329385,
			4.440385,
			3.256146,
			3.062646,
			4.296688,
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

return settings("mission_vo_fm_resurgence_cryptic_b", mission_vo_fm_resurgence_cryptic_b)
