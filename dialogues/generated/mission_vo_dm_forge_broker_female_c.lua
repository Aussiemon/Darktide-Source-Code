-- chunkname: @dialogues/generated/mission_vo_dm_forge_broker_female_c.lua

local mission_vo_dm_forge_broker_female_c = {
	event_demolition_first_corruptor_destroyed_a_enginseer = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_broker_female_c__event_demolition_first_corruptor_destroyed_a_01",
			"loc_broker_female_c__event_demolition_first_corruptor_destroyed_a_02",
			"loc_broker_female_c__event_demolition_first_corruptor_destroyed_a_03",
		},
		sound_events_duration = {
			2.604813,
			2.743021,
			2.592073,
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

return settings("mission_vo_dm_forge_broker_female_c", mission_vo_dm_forge_broker_female_c)
