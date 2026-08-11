-- chunkname: @dialogues/generated/mission_vo_hm_strain_broker_male_a.lua

local mission_vo_hm_strain_broker_male_a = {
	event_demolition_first_corruptor_destroyed_strain_a = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_broker_male_a__event_demolition_first_corruptor_destroyed_a_01",
			"loc_broker_male_a__event_demolition_first_corruptor_destroyed_a_02",
			"loc_broker_male_a__event_demolition_first_corruptor_destroyed_a_03",
		},
		sound_events_duration = {
			2.824323,
			2.290469,
			1.946896,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_strain_crossroads = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_broker_male_a__mission_strain_crossroads_01",
		},
		sound_events_duration = {
			[1] = 2.887177,
		},
		randomize_indexes = {},
	},
	mission_strain_first_objective_response = {
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

return settings("mission_vo_hm_strain_broker_male_a", mission_vo_hm_strain_broker_male_a)
