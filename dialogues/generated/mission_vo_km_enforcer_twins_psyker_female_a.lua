local mission_vo_km_enforcer_twins_psyker_female_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_psyker_female_a__enemy_kill_monster_03"
		},
		sound_events_duration = {
			[1.0] = 2.195771
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
			[1.0] = "loc_psyker_female_a__mission_stockpile_main_access_01",
			[2.0] = "loc_psyker_female_a__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 1.863271,
			[2.0] = 2.046521
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_psyker_female_a__response_for_enemy_kill_monster_01",
			"loc_psyker_female_a__response_for_enemy_kill_monster_02",
			"loc_psyker_female_a__response_for_enemy_kill_monster_06",
			"loc_psyker_female_a__response_for_enemy_kill_monster_07",
			"loc_psyker_female_a__response_for_enemy_kill_monster_10"
		},
		sound_events_duration = {
			3.146708,
			1.993333,
			2.162521,
			2.125167,
			2.687896
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_km_enforcer_twins_psyker_female_a", mission_vo_km_enforcer_twins_psyker_female_a)
