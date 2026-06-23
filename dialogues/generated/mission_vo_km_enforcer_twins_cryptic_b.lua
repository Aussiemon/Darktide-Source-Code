-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_cryptic_b.lua

local mission_vo_km_enforcer_twins_cryptic_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_cryptic_b__enemy_kill_monster_01",
			"loc_cryptic_b__enemy_kill_monster_02",
			"loc_cryptic_b__enemy_kill_monster_04",
		},
		sound_events_duration = {
			2.159104,
			1.765198,
			3.265323,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_cryptic_b__response_for_enemy_kill_monster_02",
		},
		sound_events_duration = {
			[1] = 2.708615,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_cryptic_b", mission_vo_km_enforcer_twins_cryptic_b)
