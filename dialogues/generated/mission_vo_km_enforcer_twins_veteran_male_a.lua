-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_veteran_male_a.lua

local mission_vo_km_enforcer_twins_veteran_male_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_a__enemy_kill_monster_02",
			[2] = "loc_veteran_male_a__enemy_kill_monster_06",
		},
		sound_events_duration = {
			[1] = 1.880021,
			[2] = 3.928333,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_veteran_male_a__mission_stockpile_main_access_02",
		},
		sound_events_duration = {
			[1] = 3.363604,
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
			"loc_veteran_male_a__response_for_enemy_kill_monster_01",
			"loc_veteran_male_a__response_for_enemy_kill_monster_02",
			"loc_veteran_male_a__response_for_enemy_kill_monster_03",
			"loc_veteran_male_a__response_for_enemy_kill_monster_05",
			"loc_veteran_male_a__response_for_enemy_kill_monster_06",
			"loc_veteran_male_a__response_for_enemy_kill_monster_07",
			"loc_veteran_male_a__response_for_enemy_kill_monster_10",
		},
		sound_events_duration = {
			2.163125,
			1.75925,
			1.113771,
			3.193854,
			3.833229,
			3.082958,
			1.001875,
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

return settings("mission_vo_km_enforcer_twins_veteran_male_a", mission_vo_km_enforcer_twins_veteran_male_a)
