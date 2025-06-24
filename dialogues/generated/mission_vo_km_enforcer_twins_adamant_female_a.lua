-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_adamant_female_a.lua

local mission_vo_km_enforcer_twins_adamant_female_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_female_a__enemy_kill_monster_01",
			"loc_adamant_female_a__enemy_kill_monster_02",
			"loc_adamant_female_a__enemy_kill_monster_03",
			"loc_adamant_female_a__enemy_kill_monster_05",
			"loc_adamant_female_a__enemy_kill_monster_07",
			"loc_adamant_female_a__enemy_kill_monster_08",
		},
		sound_events_duration = {
			3.394677,
			2.486677,
			3.276677,
			2.14901,
			2.121344,
			3.38001,
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
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_a__response_for_enemy_kill_monster_02",
			"loc_adamant_female_a__response_for_enemy_kill_monster_03",
			"loc_adamant_female_a__response_for_enemy_kill_monster_04",
			"loc_adamant_female_a__response_for_enemy_kill_monster_05",
		},
		sound_events_duration = {
			1.202583,
			1.429552,
			1.524781,
			1.982656,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_adamant_female_a", mission_vo_km_enforcer_twins_adamant_female_a)
