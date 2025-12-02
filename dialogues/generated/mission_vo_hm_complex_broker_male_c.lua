-- chunkname: @dialogues/generated/mission_vo_hm_complex_broker_male_c.lua

local mission_vo_hm_complex_broker_male_c = {
	mission_complex_first_objective_response = {
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

return settings("mission_vo_hm_complex_broker_male_c", mission_vo_hm_complex_broker_male_c)
