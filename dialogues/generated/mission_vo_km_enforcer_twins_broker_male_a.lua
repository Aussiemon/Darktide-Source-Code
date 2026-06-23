-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_broker_male_a.lua

local mission_vo_km_enforcer_twins_broker_male_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_broker_male_a__enemy_kill_monster_04",
		},
		sound_events_duration = {
			[1] = 2.703938,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__response_for_enemy_kill_monster_01",
			[2] = "loc_broker_male_a__response_for_enemy_kill_monster_02",
		},
		sound_events_duration = {
			[1] = 2.118958,
			[2] = 4.723792,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_broker_male_a", mission_vo_km_enforcer_twins_broker_male_a)
