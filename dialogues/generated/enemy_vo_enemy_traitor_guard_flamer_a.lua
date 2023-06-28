local enemy_vo_enemy_traitor_guard_flamer_a = {
	traitor_guard_flamer_spawned = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_enemy_traitor_guard_flamer_a__taunt_01",
			"loc_enemy_traitor_guard_flamer_a__taunt_02",
			"loc_enemy_traitor_guard_flamer_a__taunt_03",
			"loc_enemy_traitor_guard_flamer_a__taunt_04",
			"loc_enemy_traitor_guard_flamer_a__taunt_05",
			"loc_enemy_traitor_guard_flamer_a__taunt_06",
			"loc_enemy_traitor_guard_flamer_a__taunt_07",
			"loc_enemy_traitor_guard_flamer_a__taunt_08",
			"loc_enemy_traitor_guard_flamer_a__taunt_09",
			"loc_enemy_traitor_guard_flamer_a__taunt_10"
		},
		sound_events_duration = {
			2.591708,
			2.015646,
			2.621896,
			2.080146,
			1.268354,
			2.352438,
			2.035688,
			1.531521,
			2.253729,
			1.973042
		},
		sound_event_weights = {
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1
		},
		randomize_indexes = {}
	},
	traitor_guard_flamer_start_shooting = {
		randomize_indexes_n = 0,
		sound_events_n = 9,
		sound_events = {
			"loc_enemy_traitor_guard_flamer_a__attack_01",
			"loc_enemy_traitor_guard_flamer_a__attack_02",
			"loc_enemy_traitor_guard_flamer_a__attack_03",
			"loc_enemy_traitor_guard_flamer_a__attack_04",
			"loc_enemy_traitor_guard_flamer_a__attack_05",
			"loc_enemy_traitor_guard_flamer_a__attack_06",
			"loc_enemy_traitor_guard_flamer_a__attack_08",
			"loc_enemy_traitor_guard_flamer_a__attack_09",
			"loc_enemy_traitor_guard_flamer_a__attack_10"
		},
		sound_events_duration = {
			1.924667,
			2.116563,
			2.622521,
			2.383729,
			2.344146,
			2.046396,
			2.363146,
			3.410542,
			1.794167
		},
		sound_event_weights = {
			0.1111111,
			0.1111111,
			0.1111111,
			0.1111111,
			0.1111111,
			0.1111111,
			0.1111111,
			0.1111111,
			0.1111111
		},
		randomize_indexes = {}
	}
}

return settings("enemy_vo_enemy_traitor_guard_flamer_a", enemy_vo_enemy_traitor_guard_flamer_a)
