-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_zealot_male_c.lua

local mission_vo_km_enforcer_twins_zealot_male_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_zealot_male_c__enemy_kill_monster_01",
			"loc_zealot_male_c__enemy_kill_monster_02",
			"loc_zealot_male_c__enemy_kill_monster_03",
			"loc_zealot_male_c__enemy_kill_monster_04",
			"loc_zealot_male_c__enemy_kill_monster_05",
			"loc_zealot_male_c__enemy_kill_monster_06",
			"loc_zealot_male_c__enemy_kill_monster_07",
			"loc_zealot_male_c__enemy_kill_monster_08",
		},
		sound_events_duration = {
			2.034885,
			2.551396,
			3.521229,
			2.478885,
			3.105365,
			4.068323,
			1.818885,
			2.709646,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_zealot_male_c__mission_stockpile_main_access_01",
		},
		sound_events_duration = {
			[1] = 1.96225,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 7,
		sound_events = {
			"loc_zealot_male_c__response_for_enemy_kill_monster_01",
			"loc_zealot_male_c__response_for_enemy_kill_monster_02",
			"loc_zealot_male_c__response_for_enemy_kill_monster_03",
			"loc_zealot_male_c__response_for_enemy_kill_monster_04",
			"loc_zealot_male_c__response_for_enemy_kill_monster_05",
			"loc_zealot_male_c__response_for_enemy_kill_monster_08",
			"loc_zealot_male_c__response_for_enemy_kill_monster_10",
		},
		sound_events_duration = {
			2.481156,
			2.767781,
			2.876448,
			3.092667,
			2.474375,
			2.878344,
			1.522146,
		},
		sound_event_weights = {
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_zealot_male_c", mission_vo_km_enforcer_twins_zealot_male_c)
