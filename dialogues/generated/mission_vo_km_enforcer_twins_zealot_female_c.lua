-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_zealot_female_c.lua

local mission_vo_km_enforcer_twins_zealot_female_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_zealot_female_c__enemy_kill_monster_01",
			"loc_zealot_female_c__enemy_kill_monster_02",
			"loc_zealot_female_c__enemy_kill_monster_03",
			"loc_zealot_female_c__enemy_kill_monster_04",
			"loc_zealot_female_c__enemy_kill_monster_05",
			"loc_zealot_female_c__enemy_kill_monster_06",
			"loc_zealot_female_c__enemy_kill_monster_07",
			"loc_zealot_female_c__enemy_kill_monster_08",
		},
		sound_events_duration = {
			3.222615,
			3.406469,
			3.652135,
			3.928594,
			4.345156,
			4.182844,
			2.685292,
			2.623823,
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
			[1] = "loc_zealot_female_c__mission_stockpile_main_access_01",
		},
		sound_events_duration = {
			[1] = 1.210042,
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
			"loc_zealot_female_c__response_for_enemy_kill_monster_01",
			"loc_zealot_female_c__response_for_enemy_kill_monster_02",
			"loc_zealot_female_c__response_for_enemy_kill_monster_03",
			"loc_zealot_female_c__response_for_enemy_kill_monster_04",
			"loc_zealot_female_c__response_for_enemy_kill_monster_05",
			"loc_zealot_female_c__response_for_enemy_kill_monster_08",
			"loc_zealot_female_c__response_for_enemy_kill_monster_10",
		},
		sound_events_duration = {
			1.669698,
			1.983219,
			1.922448,
			2.515073,
			1.659135,
			1.769073,
			1.332417,
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

return settings("mission_vo_km_enforcer_twins_zealot_female_c", mission_vo_km_enforcer_twins_zealot_female_c)
