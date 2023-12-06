local mission_vo_km_enforcer_twins_ogryn_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 7,
		sound_events = {
			"loc_ogryn_b__enemy_kill_monster_01",
			"loc_ogryn_b__enemy_kill_monster_02",
			"loc_ogryn_b__enemy_kill_monster_03",
			"loc_ogryn_b__enemy_kill_monster_04",
			"loc_ogryn_b__enemy_kill_monster_05",
			"loc_ogryn_b__enemy_kill_monster_07",
			"loc_ogryn_b__enemy_kill_monster_09"
		},
		sound_events_duration = {
			1.769688,
			4.659365,
			1.760021,
			1.488031,
			1.444385,
			2.297771,
			3.633813
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
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_ogryn_b__mission_stockpile_main_access_01"
		},
		sound_events_duration = {
			[1.0] = 2.170635
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 9,
		sound_events = {
			"loc_ogryn_b__response_for_enemy_kill_monster_01",
			"loc_ogryn_b__response_for_enemy_kill_monster_02",
			"loc_ogryn_b__response_for_enemy_kill_monster_04",
			"loc_ogryn_b__response_for_enemy_kill_monster_05",
			"loc_ogryn_b__response_for_enemy_kill_monster_06",
			"loc_ogryn_b__response_for_enemy_kill_monster_07",
			"loc_ogryn_b__response_for_enemy_kill_monster_08",
			"loc_ogryn_b__response_for_enemy_kill_monster_09",
			"loc_ogryn_b__response_for_enemy_kill_monster_10"
		},
		sound_events_duration = {
			2.597469,
			3.48776,
			2.11926,
			3.079094,
			4.04351,
			2.109781,
			2.057771,
			2.606688,
			2.458479
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

return settings("mission_vo_km_enforcer_twins_ogryn_b", mission_vo_km_enforcer_twins_ogryn_b)
