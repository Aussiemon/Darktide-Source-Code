local mission_giver_vo_veteran_female_a = {
	mission_scavenge_interior = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_a__mission_scavenge_interior_01",
			[2.0] = "loc_veteran_female_a__mission_scavenge_interior_02"
		},
		sound_events_duration = {
			[1.0] = 4.130875,
			[2.0] = 4.814146
		},
		randomize_indexes = {}
	},
	mission_scavenge_servitors = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_a__mission_scavenge_servitors_01",
			[2.0] = "loc_veteran_female_a__mission_scavenge_servitors_02"
		},
		sound_events_duration = {
			[1.0] = 5.124458,
			[2.0] = 4.949
		},
		randomize_indexes = {}
	}
}

return settings("mission_giver_vo_veteran_female_a", mission_giver_vo_veteran_female_a)
