local mission_giver_vo_psyker_male_a = {
	mission_scavenge_interior = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_a__mission_scavenge_interior_01",
			[2.0] = "loc_psyker_male_a__mission_scavenge_interior_02"
		},
		sound_events_duration = {
			[1.0] = 4.385104,
			[2.0] = 5.279771
		},
		randomize_indexes = {}
	},
	mission_scavenge_servitors = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_a__mission_scavenge_servitors_01",
			[2.0] = "loc_psyker_male_a__mission_scavenge_servitors_02"
		},
		sound_events_duration = {
			[1.0] = 8.598625,
			[2.0] = 7.143938
		},
		randomize_indexes = {}
	}
}

return settings("mission_giver_vo_psyker_male_a", mission_giver_vo_psyker_male_a)
