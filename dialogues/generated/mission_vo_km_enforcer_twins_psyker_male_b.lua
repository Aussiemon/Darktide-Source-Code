-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_psyker_male_b.lua

local mission_vo_km_enforcer_twins_psyker_male_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_male_b__enemy_kill_monster_04",
			"loc_psyker_male_b__enemy_kill_monster_06",
			"loc_psyker_male_b__enemy_kill_monster_10",
		},
		sound_events_duration = {
			1.577813,
			0.954208,
			3.275188,
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
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_psyker_male_b__mission_stockpile_main_access_02",
		},
		sound_events_duration = {
			[1] = 3.59025,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__response_for_enemy_kill_monster_01",
			"loc_psyker_male_b__response_for_enemy_kill_monster_02",
			"loc_psyker_male_b__response_for_enemy_kill_monster_08",
			"loc_psyker_male_b__response_for_enemy_kill_monster_10",
		},
		sound_events_duration = {
			1.643458,
			2.09075,
			2.267563,
			3.570771,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_psyker_male_b", mission_vo_km_enforcer_twins_psyker_male_b)
