local mission_vo_km_enforcer_twins_psyker_female_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_female_b__enemy_kill_monster_04",
			"loc_psyker_female_b__enemy_kill_monster_06",
			"loc_psyker_female_b__enemy_kill_monster_10"
		},
		sound_events_duration = {
			2.500938,
			1.655479,
			4.108875
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
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_psyker_female_b__mission_stockpile_main_access_02"
		},
		sound_events_duration = {
			[1.0] = 4.147667
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__response_for_enemy_kill_monster_01",
			"loc_psyker_female_b__response_for_enemy_kill_monster_02",
			"loc_psyker_female_b__response_for_enemy_kill_monster_08",
			"loc_psyker_female_b__response_for_enemy_kill_monster_10"
		},
		sound_events_duration = {
			1.248938,
			2.172229,
			2.667438,
			4.260563
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_km_enforcer_twins_psyker_female_b", mission_vo_km_enforcer_twins_psyker_female_b)
