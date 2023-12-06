local mission_vo_km_enforcer_twins_veteran_male_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_b__enemy_kill_monster_04",
			"loc_veteran_male_b__enemy_kill_monster_05",
			"loc_veteran_male_b__enemy_kill_monster_07",
			"loc_veteran_male_b__enemy_kill_monster_08"
		},
		sound_events_duration = {
			2.333417,
			1.622333,
			1.820833,
			3.795458
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
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_male_b__mission_stockpile_main_access_01",
			[2.0] = "loc_veteran_male_b__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 5.170927,
			[2.0] = 4.484417
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 7,
		sound_events = {
			"loc_veteran_male_b__response_for_enemy_kill_monster_01",
			"loc_veteran_male_b__response_for_enemy_kill_monster_02",
			"loc_veteran_male_b__response_for_enemy_kill_monster_04",
			"loc_veteran_male_b__response_for_enemy_kill_monster_07",
			"loc_veteran_male_b__response_for_enemy_kill_monster_08",
			"loc_veteran_male_b__response_for_enemy_kill_monster_09",
			"loc_veteran_male_b__response_for_enemy_kill_monster_10"
		},
		sound_events_duration = {
			1.417479,
			2.698771,
			2.470729,
			3.214688,
			1.583792,
			2.823563,
			1.880083
		},
		sound_event_weights = {
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_km_enforcer_twins_veteran_male_b", mission_vo_km_enforcer_twins_veteran_male_b)
