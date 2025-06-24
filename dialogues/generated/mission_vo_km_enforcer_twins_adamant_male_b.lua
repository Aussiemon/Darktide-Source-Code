-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_adamant_male_b.lua

local mission_vo_km_enforcer_twins_adamant_male_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_adamant_male_b__enemy_kill_monster_01",
			"loc_adamant_male_b__enemy_kill_monster_02",
			"loc_adamant_male_b__enemy_kill_monster_03",
			"loc_adamant_male_b__enemy_kill_monster_06",
			"loc_adamant_male_b__enemy_kill_monster_08",
		},
		sound_events_duration = {
			2.4485,
			4.47125,
			5.034063,
			5.922875,
			2.33201,
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
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_b__response_for_enemy_kill_monster_01",
			"loc_adamant_male_b__response_for_enemy_kill_monster_02",
			"loc_adamant_male_b__response_for_enemy_kill_monster_03",
			"loc_adamant_male_b__response_for_enemy_kill_monster_04",
			"loc_adamant_male_b__response_for_enemy_kill_monster_05",
			"loc_adamant_male_b__response_for_enemy_kill_monster_06",
		},
		sound_events_duration = {
			3.11674,
			1.967052,
			2.479875,
			2.388333,
			2.1185,
			3.498323,
		},
		sound_event_weights = {
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
			0.1666667,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_adamant_male_b", mission_vo_km_enforcer_twins_adamant_male_b)
