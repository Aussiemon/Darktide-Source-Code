-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_adamant_female_b.lua

local mission_vo_km_enforcer_twins_adamant_female_b = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_adamant_female_b__enemy_kill_monster_01",
			"loc_adamant_female_b__enemy_kill_monster_02",
			"loc_adamant_female_b__enemy_kill_monster_03",
			"loc_adamant_female_b__enemy_kill_monster_06",
			"loc_adamant_female_b__enemy_kill_monster_08",
		},
		sound_events_duration = {
			1.861344,
			2.557344,
			4.929333,
			2.783344,
			2.537344,
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
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__response_for_enemy_kill_monster_05",
		},
		sound_events_duration = {
			[1] = 2.356708,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_adamant_female_b", mission_vo_km_enforcer_twins_adamant_female_b)
