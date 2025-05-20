-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_zealot_male_a.lua

local mission_vo_km_enforcer_twins_zealot_male_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_a__enemy_kill_monster_03",
			"loc_zealot_male_a__enemy_kill_monster_05",
			"loc_zealot_male_a__enemy_kill_monster_06",
			"loc_zealot_male_a__enemy_kill_monster_10",
		},
		sound_events_duration = {
			3.209396,
			3.400896,
			5.110188,
			5.397042,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_zealot_male_a__mission_stockpile_main_access_01",
		},
		sound_events_duration = {
			[1] = 5.673604,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_zealot_male_a__response_for_enemy_kill_monster_01",
			"loc_zealot_male_a__response_for_enemy_kill_monster_03",
			"loc_zealot_male_a__response_for_enemy_kill_monster_05",
			"loc_zealot_male_a__response_for_enemy_kill_monster_06",
			"loc_zealot_male_a__response_for_enemy_kill_monster_10",
		},
		sound_events_duration = {
			2.731573,
			3.300094,
			2.469417,
			5.483375,
			4.543,
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

return settings("mission_vo_km_enforcer_twins_zealot_male_a", mission_vo_km_enforcer_twins_zealot_male_a)
