-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_psyker_male_c.lua

local mission_vo_km_enforcer_twins_psyker_male_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_male_c__enemy_kill_monster_01",
			"loc_psyker_male_c__enemy_kill_monster_03",
			"loc_psyker_male_c__enemy_kill_monster_08",
		},
		sound_events_duration = {
			2.140167,
			2.057208,
			3.215729,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_c__mission_stockpile_main_access_01",
			[2] = "loc_psyker_male_c__mission_stockpile_main_access_02",
		},
		sound_events_duration = {
			[1] = 0.984563,
			[2] = 1.931625,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 7,
		sound_events = {
			"loc_psyker_male_c__response_for_enemy_kill_monster_01",
			"loc_psyker_male_c__response_for_enemy_kill_monster_02",
			"loc_psyker_male_c__response_for_enemy_kill_monster_05",
			"loc_psyker_male_c__response_for_enemy_kill_monster_07",
			"loc_psyker_male_c__response_for_enemy_kill_monster_08",
			"loc_psyker_male_c__response_for_enemy_kill_monster_09",
			"loc_psyker_male_c__response_for_enemy_kill_monster_10",
		},
		sound_events_duration = {
			1.904156,
			2.509896,
			2.181625,
			3.558875,
			1.860708,
			1.650167,
			3.207781,
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

return settings("mission_vo_km_enforcer_twins_psyker_male_c", mission_vo_km_enforcer_twins_psyker_male_c)
