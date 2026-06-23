-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_broker_male_b.lua

local mission_vo_km_enforcer_twins_broker_male_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_male_b__enemy_kill_monster_01",
			"loc_broker_male_b__enemy_kill_monster_02",
			"loc_broker_male_b__enemy_kill_monster_03",
			"loc_broker_male_b__enemy_kill_monster_04",
			"loc_broker_male_b__enemy_kill_monster_05",
		},
		sound_events_duration = {
			3.796125,
			3.627677,
			3.809083,
			4.662885,
			2.557219,
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
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_b__response_for_enemy_kill_monster_01",
			[2] = "loc_broker_male_b__response_for_enemy_kill_monster_02",
		},
		sound_events_duration = {
			[1] = 3.942229,
			[2] = 3.504708,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_broker_male_b", mission_vo_km_enforcer_twins_broker_male_b)
