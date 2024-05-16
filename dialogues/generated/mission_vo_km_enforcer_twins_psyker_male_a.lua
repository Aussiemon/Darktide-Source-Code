-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_psyker_male_a.lua

local mission_vo_km_enforcer_twins_psyker_male_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_psyker_male_a__enemy_kill_monster_03",
		},
		sound_events_duration = {
			[1] = 1.730146,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_a__mission_stockpile_main_access_01",
			[2] = "loc_psyker_male_a__mission_stockpile_main_access_02",
		},
		sound_events_duration = {
			[1] = 3.491979,
			[2] = 2.338604,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_psyker_male_a__response_for_enemy_kill_monster_01",
			"loc_psyker_male_a__response_for_enemy_kill_monster_02",
			"loc_psyker_male_a__response_for_enemy_kill_monster_06",
			"loc_psyker_male_a__response_for_enemy_kill_monster_07",
			"loc_psyker_male_a__response_for_enemy_kill_monster_10",
		},
		sound_events_duration = {
			1.497313,
			1.826625,
			1.685125,
			2.320042,
			2.243875,
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_psyker_male_a", mission_vo_km_enforcer_twins_psyker_male_a)
