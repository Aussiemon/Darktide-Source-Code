local mission_giver_vo_psyker_female_b = {
	mission_scavenge_interior = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_b__mission_scavenge_interior_01",
			[2.0] = "loc_psyker_female_b__mission_scavenge_interior_02"
		},
		sound_events_duration = {
			[1.0] = 3.807708,
			[2.0] = 3.598729
		},
		randomize_indexes = {}
	},
	mission_scavenge_servitors = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_b__mission_scavenge_servitors_01",
			[2.0] = "loc_psyker_female_b__mission_scavenge_servitors_02"
		},
		sound_events_duration = {
			[1.0] = 4.782938,
			[2.0] = 3.947021
		},
		randomize_indexes = {}
	}
}

return settings("mission_giver_vo_psyker_female_b", mission_giver_vo_psyker_female_b)
