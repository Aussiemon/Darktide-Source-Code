local mission_vo_km_enforcer_twins_zealot_female_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_zealot_female_b__enemy_kill_monster_01",
			"loc_zealot_female_b__enemy_kill_monster_04",
			"loc_zealot_female_b__enemy_kill_monster_05",
			"loc_zealot_female_b__enemy_kill_monster_06",
			"loc_zealot_female_b__enemy_kill_monster_08",
			"loc_zealot_female_b__enemy_kill_monster_09"
		},
		sound_events_duration = {
			2.641563,
			2.763354,
			2.207333,
			2.500563,
			2.249875,
			3.591583
		},
		sound_event_weights = {
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667
		},
		randomize_indexes = {}
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_zealot_female_b__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 4.127729
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_zealot_female_b__response_for_enemy_kill_monster_02",
			"loc_zealot_female_b__response_for_enemy_kill_monster_03",
			"loc_zealot_female_b__response_for_enemy_kill_monster_04",
			"loc_zealot_female_b__response_for_enemy_kill_monster_05",
			"loc_zealot_female_b__response_for_enemy_kill_monster_06",
			"loc_zealot_female_b__response_for_enemy_kill_monster_07",
			"loc_zealot_female_b__response_for_enemy_kill_monster_09",
			"loc_zealot_female_b__response_for_enemy_kill_monster_10"
		},
		sound_events_duration = {
			2.229771,
			2.923833,
			3.468896,
			1.952542,
			3.128604,
			2.909938,
			4.554563,
			5.081375
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_km_enforcer_twins_zealot_female_b", mission_vo_km_enforcer_twins_zealot_female_b)
