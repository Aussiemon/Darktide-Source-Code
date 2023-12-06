local mission_vo_km_enforcer_twins_veteran_female_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_b__enemy_kill_monster_04",
			"loc_veteran_female_b__enemy_kill_monster_05",
			"loc_veteran_female_b__enemy_kill_monster_07",
			"loc_veteran_female_b__enemy_kill_monster_08"
		},
		sound_events_duration = {
			1.417188,
			1.279854,
			1.572813,
			5.879375
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
			[1.0] = "loc_veteran_female_b__mission_stockpile_main_access_01",
			[2.0] = "loc_veteran_female_b__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 4.624427,
			[2.0] = 3.637542
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
			"loc_veteran_female_b__response_for_enemy_kill_monster_01",
			"loc_veteran_female_b__response_for_enemy_kill_monster_02",
			"loc_veteran_female_b__response_for_enemy_kill_monster_04",
			"loc_veteran_female_b__response_for_enemy_kill_monster_07",
			"loc_veteran_female_b__response_for_enemy_kill_monster_08",
			"loc_veteran_female_b__response_for_enemy_kill_monster_09",
			"loc_veteran_female_b__response_for_enemy_kill_monster_10"
		},
		sound_events_duration = {
			2.436333,
			2.680167,
			3.154438,
			2.352333,
			1.965458,
			2.487688,
			1.794563
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

return settings("mission_vo_km_enforcer_twins_veteran_female_b", mission_vo_km_enforcer_twins_veteran_female_b)
