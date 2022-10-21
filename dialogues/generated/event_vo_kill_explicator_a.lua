local event_vo_kill_explicator_a = {
	event_kill_kill_the_target = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_explicator_a__event_kill_kill_the_target_01",
			"loc_explicator_a__event_kill_kill_the_target_02",
			"loc_explicator_a__event_kill_kill_the_target_03",
			"loc_explicator_a__event_kill_kill_the_target_04"
		},
		sound_events_duration = {
			3.736792,
			4.060604,
			5.283104,
			4.349625
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_explicator_a__event_kill_target_destroyed_b_01",
			"loc_explicator_a__event_kill_target_destroyed_b_02",
			"loc_explicator_a__event_kill_target_destroyed_b_03",
			"loc_explicator_a__event_kill_target_destroyed_b_04"
		},
		sound_events_duration = {
			3.018271,
			5.172125,
			4.192063,
			3.409042
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_explicator_a__event_kill_target_heavy_damage_b_01",
			"loc_explicator_a__event_kill_target_heavy_damage_b_02",
			"loc_explicator_a__event_kill_target_heavy_damage_b_03",
			"loc_explicator_a__event_kill_target_heavy_damage_b_04"
		},
		sound_events_duration = {
			3.357875,
			1.918667,
			2.651979,
			1.959896
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_explicator_a", event_vo_kill_explicator_a)
