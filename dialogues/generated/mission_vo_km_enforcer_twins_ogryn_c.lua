local mission_vo_km_enforcer_twins_ogryn_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_ogryn_c__enemy_kill_monster_02",
			"loc_ogryn_c__enemy_kill_monster_03",
			"loc_ogryn_c__enemy_kill_monster_04",
			"loc_ogryn_c__enemy_kill_monster_05",
			"loc_ogryn_c__enemy_kill_monster_07",
			"loc_ogryn_c__enemy_kill_monster_08",
			"loc_ogryn_c__enemy_kill_monster_09",
			"loc_ogryn_c__enemy_kill_monster_10"
		},
		sound_events_duration = {
			2.787135,
			3.877865,
			1.828896,
			3.815948,
			2.495021,
			2.083417,
			1.851448,
			1.520771
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
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_ogryn_c__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 2.824781
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
			"loc_ogryn_c__response_for_enemy_kill_monster_01",
			"loc_ogryn_c__response_for_enemy_kill_monster_02",
			"loc_ogryn_c__response_for_enemy_kill_monster_03",
			"loc_ogryn_c__response_for_enemy_kill_monster_06",
			"loc_ogryn_c__response_for_enemy_kill_monster_08",
			"loc_ogryn_c__response_for_enemy_kill_monster_09"
		},
		sound_events_duration = {
			2.427073,
			3.044094,
			4.826281,
			2.680865,
			1.823948,
			1.406552
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

return settings("mission_vo_km_enforcer_twins_ogryn_c", mission_vo_km_enforcer_twins_ogryn_c)
