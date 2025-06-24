-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_adamant_female_c.lua

local mission_vo_km_enforcer_twins_adamant_female_c = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_female_c__enemy_kill_monster_01",
			"loc_adamant_female_c__enemy_kill_monster_02",
			"loc_adamant_female_c__enemy_kill_monster_03",
			"loc_adamant_female_c__enemy_kill_monster_04",
			"loc_adamant_female_c__enemy_kill_monster_07",
			"loc_adamant_female_c__enemy_kill_monster_08",
		},
		sound_events_duration = {
			2.541208,
			2.989042,
			1.509104,
			2.250292,
			3.891521,
			2.613052,
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
			"loc_adamant_female_c__response_for_enemy_kill_monster_01",
			"loc_adamant_female_c__response_for_enemy_kill_monster_02",
			"loc_adamant_female_c__response_for_enemy_kill_monster_03",
			"loc_adamant_female_c__response_for_enemy_kill_monster_04",
			"loc_adamant_female_c__response_for_enemy_kill_monster_05",
			"loc_adamant_female_c__response_for_enemy_kill_monster_06",
		},
		sound_events_duration = {
			2.98625,
			1.954896,
			2.798594,
			2.378708,
			1.579729,
			2.50475,
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

return settings("mission_vo_km_enforcer_twins_adamant_female_c", mission_vo_km_enforcer_twins_adamant_female_c)
