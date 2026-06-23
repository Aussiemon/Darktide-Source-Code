-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_cryptic_a.lua

local mission_vo_km_enforcer_twins_cryptic_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_cryptic_a__enemy_kill_monster_01",
			"loc_cryptic_a__enemy_kill_monster_02",
			"loc_cryptic_a__enemy_kill_monster_03",
			"loc_cryptic_a__enemy_kill_monster_04",
		},
		sound_events_duration = {
			3.287552,
			3.034104,
			4.018906,
			4.603979,
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
			"loc_cryptic_a__response_for_enemy_kill_monster_01",
			"loc_cryptic_a__response_for_enemy_kill_monster_02",
			"loc_cryptic_a__response_for_enemy_kill_monster_03",
		},
		sound_events_duration = {
			3.3,
			2.676167,
			3.41849,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_cryptic_a", mission_vo_km_enforcer_twins_cryptic_a)
