-- chunkname: @dialogues/generated/mission_vo_lm_scavenge_broker_female_c.lua

local mission_vo_lm_scavenge_broker_female_c = {
	mission_scavenge_first_objective_response = {
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

return settings("mission_vo_lm_scavenge_broker_female_c", mission_vo_lm_scavenge_broker_female_c)
