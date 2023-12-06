local mission_vo_km_enforcer_twins_veteran_female_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_a__enemy_kill_monster_02",
			[2.0] = "loc_veteran_female_a__enemy_kill_monster_06"
		},
		sound_events_duration = {
			[1.0] = 3.225729,
			[2.0] = 3.939125
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_veteran_female_a__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 4.141438
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 7,
		sound_events = {
			"loc_veteran_female_a__response_for_enemy_kill_monster_01",
			"loc_veteran_female_a__response_for_enemy_kill_monster_02",
			"loc_veteran_female_a__response_for_enemy_kill_monster_03",
			"loc_veteran_female_a__response_for_enemy_kill_monster_05",
			"loc_veteran_female_a__response_for_enemy_kill_monster_06",
			"loc_veteran_female_a__response_for_enemy_kill_monster_07",
			"loc_veteran_female_a__response_for_enemy_kill_monster_10"
		},
		sound_events_duration = {
			3.037229,
			2.153979,
			1.206917,
			3.097583,
			2.913458,
			3.413708,
			1.797875
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

return settings("mission_vo_km_enforcer_twins_veteran_female_a", mission_vo_km_enforcer_twins_veteran_female_a)
