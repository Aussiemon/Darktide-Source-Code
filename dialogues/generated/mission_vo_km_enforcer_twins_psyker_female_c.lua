local mission_vo_km_enforcer_twins_psyker_female_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_female_c__enemy_kill_monster_01",
			"loc_psyker_female_c__enemy_kill_monster_03",
			"loc_psyker_female_c__enemy_kill_monster_08"
		},
		sound_events_duration = {
			2.33124,
			2.267729,
			2.552198
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_female_c__mission_stockpile_main_access_01",
			[2.0] = "loc_psyker_female_c__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 1.085323,
			[2.0] = 2.292427
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
			"loc_psyker_female_c__response_for_enemy_kill_monster_01",
			"loc_psyker_female_c__response_for_enemy_kill_monster_02",
			"loc_psyker_female_c__response_for_enemy_kill_monster_05",
			"loc_psyker_female_c__response_for_enemy_kill_monster_07",
			"loc_psyker_female_c__response_for_enemy_kill_monster_08",
			"loc_psyker_female_c__response_for_enemy_kill_monster_09",
			"loc_psyker_female_c__response_for_enemy_kill_monster_10"
		},
		sound_events_duration = {
			2.406833,
			2.263948,
			2.016604,
			3.25751,
			1.84401,
			1.750156,
			3.017583
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

return settings("mission_vo_km_enforcer_twins_psyker_female_c", mission_vo_km_enforcer_twins_psyker_female_c)
