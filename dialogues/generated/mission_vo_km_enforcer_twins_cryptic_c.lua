-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_cryptic_c.lua

local mission_vo_km_enforcer_twins_cryptic_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_cryptic_c__enemy_kill_monster_01",
			"loc_cryptic_c__enemy_kill_monster_02",
			"loc_cryptic_c__enemy_kill_monster_04",
		},
		sound_events_duration = {
			2.163948,
			2.29074,
			4.164208,
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
		sound_events_n = 3,
		sound_events = {
			"loc_cryptic_c__response_for_enemy_kill_monster_01",
			"loc_cryptic_c__response_for_enemy_kill_monster_02",
			"loc_cryptic_c__response_for_enemy_kill_monster_03",
		},
		sound_events_duration = {
			2.192625,
			1.61624,
			1.515,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_cryptic_c", mission_vo_km_enforcer_twins_cryptic_c)
