-- chunkname: @dialogues/generated/mission_vo_dm_forge_cryptic_b.lua

local mission_vo_dm_forge_cryptic_b = {
	event_demolition_first_corruptor_destroyed_a_enginseer = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_cryptic_b__event_demolition_first_corruptor_destroyed_a_01",
			"loc_cryptic_b__event_demolition_first_corruptor_destroyed_a_02",
			"loc_cryptic_b__event_demolition_first_corruptor_destroyed_a_03",
		},
		sound_events_duration = {
			2.030792,
			2.364198,
			2.761052,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_forge_first_objective_response = {
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

return settings("mission_vo_dm_forge_cryptic_b", mission_vo_dm_forge_cryptic_b)
