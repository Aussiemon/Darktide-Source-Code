-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_veteran_male_c.lua

local mission_vo_km_enforcer_twins_veteran_male_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_veteran_male_c__enemy_kill_monster_01",
		},
		sound_events_duration = {
			[1] = 1.481552,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_c__mission_stockpile_main_access_01",
			[2] = "loc_veteran_male_c__mission_stockpile_main_access_02",
		},
		sound_events_duration = {
			[1] = 1.394427,
			[2] = 2.456552,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_male_c__response_for_enemy_kill_monster_01",
			"loc_veteran_male_c__response_for_enemy_kill_monster_04",
			"loc_veteran_male_c__response_for_enemy_kill_monster_08",
		},
		sound_events_duration = {
			1.445031,
			2.324771,
			3.259354,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_veteran_male_c", mission_vo_km_enforcer_twins_veteran_male_c)
