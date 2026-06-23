-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_broker_female_c.lua

local mission_vo_km_enforcer_twins_broker_female_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_broker_female_c__enemy_kill_monster_01",
			"loc_broker_female_c__enemy_kill_monster_02",
			"loc_broker_female_c__enemy_kill_monster_05",
		},
		sound_events_duration = {
			2.702917,
			2.750865,
			2.275604,
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
			[1] = "loc_broker_female_c__response_for_enemy_kill_monster_02",
		},
		sound_events_duration = {
			[1] = 3.538542,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_broker_female_c", mission_vo_km_enforcer_twins_broker_female_c)
