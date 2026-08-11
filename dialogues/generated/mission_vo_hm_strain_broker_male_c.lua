-- chunkname: @dialogues/generated/mission_vo_hm_strain_broker_male_c.lua

local mission_vo_hm_strain_broker_male_c = {
	event_demolition_first_corruptor_destroyed_strain_a = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_broker_male_c__event_demolition_first_corruptor_destroyed_a_01",
			"loc_broker_male_c__event_demolition_first_corruptor_destroyed_a_02",
			"loc_broker_male_c__event_demolition_first_corruptor_destroyed_a_03",
		},
		sound_events_duration = {
			2.45701,
			2.947,
			2.66201,
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
			[1] = "loc_broker_male_c__mission_strain_crossroads_01",
		},
		sound_events_duration = {
			[1] = 3.15401,
		},
		randomize_indexes = {},
	},
	mission_strain_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_male_c__guidance_starting_area_01",
			"loc_broker_male_c__guidance_starting_area_02",
			"loc_broker_male_c__guidance_starting_area_03",
			"loc_broker_male_c__guidance_starting_area_04",
			"loc_broker_male_c__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.218677,
			3.774677,
			3.021344,
			3.682677,
			4.015677,
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

return settings("mission_vo_hm_strain_broker_male_c", mission_vo_hm_strain_broker_male_c)
