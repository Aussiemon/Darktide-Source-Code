local enemy_vo_captain_twin_male_a = {
	twin_spawn_laugh_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_captain_twin_male_a__laugh_a_01",
			"loc_captain_twin_male_a__laugh_a_02",
			"loc_captain_twin_male_a__laugh_a_03",
			"loc_captain_twin_male_a__laugh_a_04",
			"loc_captain_twin_male_a__laugh_a_05"
		},
		sound_events_duration = {
			0.861063,
			1.545458,
			1.862042,
			8.047792,
			5.020396
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2
		},
		randomize_indexes = {}
	}
}

return settings("enemy_vo_captain_twin_male_a", enemy_vo_captain_twin_male_a)
