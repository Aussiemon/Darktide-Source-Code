local mission_vo_km_enforcer_twins_ogryn_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 9,
		sound_events = {
			"loc_ogryn_a__enemy_kill_monster_01",
			"loc_ogryn_a__enemy_kill_monster_02",
			"loc_ogryn_a__enemy_kill_monster_03",
			"loc_ogryn_a__enemy_kill_monster_05",
			"loc_ogryn_a__enemy_kill_monster_06",
			"loc_ogryn_a__enemy_kill_monster_07",
			"loc_ogryn_a__enemy_kill_monster_08",
			"loc_ogryn_a__enemy_kill_monster_09",
			"loc_ogryn_a__enemy_kill_monster_10"
		},
		sound_events_duration = {
			1.359938,
			3.702958,
			1.522542,
			2.641813,
			1.749813,
			1.561542,
			1.433479,
			2.319417,
			2.691083
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
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_ogryn_a__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 2.304333
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_ogryn_a__response_for_enemy_kill_monster_01",
			"loc_ogryn_a__response_for_enemy_kill_monster_02",
			"loc_ogryn_a__response_for_enemy_kill_monster_03",
			"loc_ogryn_a__response_for_enemy_kill_monster_04",
			"loc_ogryn_a__response_for_enemy_kill_monster_05",
			"loc_ogryn_a__response_for_enemy_kill_monster_08"
		},
		sound_events_duration = {
			1.104688,
			1.054083,
			1.506688,
			2.287375,
			1.944229,
			2.833208
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
	}
}

return settings("mission_vo_km_enforcer_twins_ogryn_a", mission_vo_km_enforcer_twins_ogryn_a)
