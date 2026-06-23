-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_cryptic_d.lua

local mission_vo_km_enforcer_twins_cryptic_d = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_cryptic_d__enemy_kill_monster_01",
			"loc_cryptic_d__enemy_kill_monster_02",
			"loc_cryptic_d__enemy_kill_monster_03",
			"loc_cryptic_d__enemy_kill_monster_04",
		},
		sound_events_duration = {
			3.482021,
			3.933063,
			3.71674,
			5.110948,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_cryptic_d__response_for_enemy_kill_monster_01",
			"loc_cryptic_d__response_for_enemy_kill_monster_02",
			"loc_cryptic_d__response_for_enemy_kill_monster_03",
		},
		sound_events_duration = {
			3.128719,
			2.761323,
			4.280469,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_cryptic_d", mission_vo_km_enforcer_twins_cryptic_d)
