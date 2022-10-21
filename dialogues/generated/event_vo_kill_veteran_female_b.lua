local event_vo_kill_veteran_female_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_b__event_kill_target_damaged_01",
			"loc_veteran_female_b__event_kill_target_damaged_02",
			"loc_veteran_female_b__event_kill_target_damaged_03",
			"loc_veteran_female_b__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			3.173,
			2.805583,
			1.951292,
			1.579313
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_b__event_kill_target_destroyed_a_01",
			"loc_veteran_female_b__event_kill_target_destroyed_a_02",
			"loc_veteran_female_b__event_kill_target_destroyed_a_03",
			"loc_veteran_female_b__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			1.631021,
			1.654896,
			3.564104,
			2.499563
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_b__event_kill_target_heavy_damage_a_01",
			"loc_veteran_female_b__event_kill_target_heavy_damage_a_02",
			"loc_veteran_female_b__event_kill_target_heavy_damage_a_03",
			"loc_veteran_female_b__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			3.053208,
			2.938708,
			3.092292,
			2.448896
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_veteran_female_b", event_vo_kill_veteran_female_b)
