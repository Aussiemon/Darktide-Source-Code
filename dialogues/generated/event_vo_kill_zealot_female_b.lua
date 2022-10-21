local event_vo_kill_zealot_female_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_b__event_kill_target_damaged_01",
			"loc_zealot_female_b__event_kill_target_damaged_02",
			"loc_zealot_female_b__event_kill_target_damaged_03",
			"loc_zealot_female_b__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.552094,
			2.718063,
			2.293771,
			3.456823
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_b__event_kill_target_destroyed_a_01",
			"loc_zealot_female_b__event_kill_target_destroyed_a_02",
			"loc_zealot_female_b__event_kill_target_destroyed_a_03",
			"loc_zealot_female_b__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			3.492313,
			4.279719,
			3.555833,
			4.093135
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_b__event_kill_target_heavy_damage_a_01",
			"loc_zealot_female_b__event_kill_target_heavy_damage_a_02",
			"loc_zealot_female_b__event_kill_target_heavy_damage_a_03",
			"loc_zealot_female_b__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			4.006031,
			4.184927,
			1.72751,
			3.695146
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_zealot_female_b", event_vo_kill_zealot_female_b)
