-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_adamant_male_a.lua

local mission_vo_km_enforcer_twins_adamant_male_a = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_adamant_male_a__enemy_kill_monster_01",
			"loc_adamant_male_a__enemy_kill_monster_02",
			"loc_adamant_male_a__enemy_kill_monster_03",
			"loc_adamant_male_a__enemy_kill_monster_05",
			"loc_adamant_male_a__enemy_kill_monster_07",
			"loc_adamant_male_a__enemy_kill_monster_08",
		},
		sound_events_duration = {
			4.333219,
			3.263542,
			3.774688,
			1.795167,
			3.435042,
			3.678125,
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
			"loc_adamant_male_a__response_for_enemy_kill_monster_02",
			"loc_adamant_male_a__response_for_enemy_kill_monster_03",
			"loc_adamant_male_a__response_for_enemy_kill_monster_04",
			"loc_adamant_male_a__response_for_enemy_kill_monster_05",
		},
		sound_events_duration = {
			1.146563,
			1.672604,
			1.574146,
			2.244125,
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

return settings("mission_vo_km_enforcer_twins_adamant_male_a", mission_vo_km_enforcer_twins_adamant_male_a)
