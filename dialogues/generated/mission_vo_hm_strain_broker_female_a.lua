-- chunkname: @dialogues/generated/mission_vo_hm_strain_broker_female_a.lua

local mission_vo_hm_strain_broker_female_a = {
	mission_strain_crossroads = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_broker_female_a__mission_strain_crossroads_01",
		},
		sound_events_duration = {
			[1] = 3.017208,
		},
		randomize_indexes = {},
	},
	mission_strain_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_female_a__guidance_starting_area_01",
			"loc_broker_female_a__guidance_starting_area_02",
			"loc_broker_female_a__guidance_starting_area_03",
			"loc_broker_female_a__guidance_starting_area_04",
			"loc_broker_female_a__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.218094,
			3.113969,
			2.897438,
			4.094458,
			2.877646,
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

return settings("mission_vo_hm_strain_broker_female_a", mission_vo_hm_strain_broker_female_a)
