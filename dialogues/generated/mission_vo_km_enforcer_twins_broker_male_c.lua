-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_broker_male_c.lua

local mission_vo_km_enforcer_twins_broker_male_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_broker_male_c__enemy_kill_monster_01",
			"loc_broker_male_c__enemy_kill_monster_02",
			"loc_broker_male_c__enemy_kill_monster_05",
		},
		sound_events_duration = {
			3.434646,
			2.591531,
			3.531385,
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
			[1] = "loc_broker_male_c__response_for_enemy_kill_monster_02",
		},
		sound_events_duration = {
			[1] = 4.139542,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_broker_male_c", mission_vo_km_enforcer_twins_broker_male_c)
