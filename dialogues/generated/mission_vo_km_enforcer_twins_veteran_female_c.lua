local mission_vo_km_enforcer_twins_veteran_female_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_veteran_female_c__enemy_kill_monster_01"
		},
		sound_events_duration = {
			[1.0] = 1.441552
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_c__mission_stockpile_main_access_01",
			[2.0] = "loc_veteran_female_c__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 1.671771,
			[2.0] = 2.398917
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_female_c__response_for_enemy_kill_monster_01",
			"loc_veteran_female_c__response_for_enemy_kill_monster_04",
			"loc_veteran_female_c__response_for_enemy_kill_monster_08"
		},
		sound_events_duration = {
			1.256552,
			2.096958,
			2.657125
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_km_enforcer_twins_veteran_female_c", mission_vo_km_enforcer_twins_veteran_female_c)
