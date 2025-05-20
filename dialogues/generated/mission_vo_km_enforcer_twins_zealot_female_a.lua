-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_zealot_female_a.lua

local mission_vo_km_enforcer_twins_zealot_female_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__enemy_kill_monster_03",
			"loc_zealot_female_a__enemy_kill_monster_05",
			"loc_zealot_female_a__enemy_kill_monster_06",
			"loc_zealot_female_a__enemy_kill_monster_10",
		},
		sound_events_duration = {
			3.343104,
			3.06425,
			3.64425,
			5.120771,
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
			[1] = "loc_zealot_female_a__mission_stockpile_main_access_01",
		},
		sound_events_duration = {
			[1] = 4.632896,
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
			"loc_zealot_female_a__response_for_enemy_kill_monster_01",
			"loc_zealot_female_a__response_for_enemy_kill_monster_03",
			"loc_zealot_female_a__response_for_enemy_kill_monster_05",
			"loc_zealot_female_a__response_for_enemy_kill_monster_06",
			"loc_zealot_female_a__response_for_enemy_kill_monster_10",
		},
		sound_events_duration = {
			2.331104,
			2.793771,
			2.190021,
			3.146917,
			3.704813,
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

return settings("mission_vo_km_enforcer_twins_zealot_female_a", mission_vo_km_enforcer_twins_zealot_female_a)
