local mission_vo_km_enforcer_twins_zealot_male_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_b__enemy_kill_monster_05",
			"loc_zealot_male_b__enemy_kill_monster_06",
			"loc_zealot_male_b__enemy_kill_monster_08",
			"loc_zealot_male_b__enemy_kill_monster_09"
		},
		sound_events_duration = {
			3.294083,
			2.571604,
			1.774604,
			3.248417
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_zealot_male_b__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 3.837792
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
			"loc_zealot_male_b__response_for_enemy_kill_monster_02",
			"loc_zealot_male_b__response_for_enemy_kill_monster_03",
			"loc_zealot_male_b__response_for_enemy_kill_monster_04",
			"loc_zealot_male_b__response_for_enemy_kill_monster_05",
			"loc_zealot_male_b__response_for_enemy_kill_monster_06",
			"loc_zealot_male_b__response_for_enemy_kill_monster_07",
			"loc_zealot_male_b__response_for_enemy_kill_monster_09",
			"loc_zealot_male_b__response_for_enemy_kill_monster_10"
		},
		sound_events_duration = {
			2.527708,
			2.587542,
			3.163563,
			2.184167,
			3.301167,
			2.084375,
			4.260083,
			4.904104
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

return settings("mission_vo_km_enforcer_twins_zealot_male_b", mission_vo_km_enforcer_twins_zealot_male_b)
