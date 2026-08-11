-- chunkname: @dialogues/generated/mission_vo_dm_forge_cryptic_c.lua

local mission_vo_dm_forge_cryptic_c = {
	event_demolition_first_corruptor_destroyed_a_enginseer = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_cryptic_c__event_demolition_first_corruptor_destroyed_a_01",
			"loc_cryptic_c__event_demolition_first_corruptor_destroyed_a_02",
			"loc_cryptic_c__event_demolition_first_corruptor_destroyed_a_03",
		},
		sound_events_duration = {
			2.022635,
			2.245885,
			2.386448,
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

return settings("mission_vo_dm_forge_cryptic_c", mission_vo_dm_forge_cryptic_c)
