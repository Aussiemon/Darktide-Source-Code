local mission_giver_vo_zealot_male_a = {
	mission_scavenge_interior = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_a__mission_scavenge_interior_01",
			[2.0] = "loc_zealot_male_a__mission_scavenge_interior_02"
		},
		sound_events_duration = {
			[1.0] = 4.238021,
			[2.0] = 8.033458
		},
		randomize_indexes = {}
	},
	mission_scavenge_servitors = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_a__mission_scavenge_servitors_01",
			[2.0] = "loc_zealot_male_a__mission_scavenge_servitors_02"
		},
		sound_events_duration = {
			[1.0] = 7.38675,
			[2.0] = 7.527167
		},
		randomize_indexes = {}
	}
}

return settings("mission_giver_vo_zealot_male_a", mission_giver_vo_zealot_male_a)
