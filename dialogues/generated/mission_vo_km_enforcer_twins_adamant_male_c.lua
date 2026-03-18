-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_adamant_male_c.lua

local mission_vo_km_enforcer_twins_adamant_male_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_c__enemy_kill_monster_01",
			"loc_adamant_male_c__enemy_kill_monster_02",
			"loc_adamant_male_c__enemy_kill_monster_03",
			"loc_adamant_male_c__enemy_kill_monster_04",
			"loc_adamant_male_c__enemy_kill_monster_07",
			"loc_adamant_male_c__enemy_kill_monster_08",
		},
		sound_events_duration = {
			4.773344,
			4.12801,
			2.36601,
			2.966677,
			4.781344,
			3.44001,
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
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_c__response_for_enemy_kill_monster_01",
			"loc_adamant_male_c__response_for_enemy_kill_monster_02",
			"loc_adamant_male_c__response_for_enemy_kill_monster_03",
			"loc_adamant_male_c__response_for_enemy_kill_monster_04",
			"loc_adamant_male_c__response_for_enemy_kill_monster_05",
			"loc_adamant_male_c__response_for_enemy_kill_monster_06",
		},
		sound_events_duration = {
			2.479396,
			2.339885,
			3.150115,
			1.691542,
			2.303875,
			1.834115,
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

return settings("mission_vo_km_enforcer_twins_adamant_male_c", mission_vo_km_enforcer_twins_adamant_male_c)
