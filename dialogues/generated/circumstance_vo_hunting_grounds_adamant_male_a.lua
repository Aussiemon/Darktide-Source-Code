-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_adamant_male_a.lua

local circumstance_vo_hunting_grounds_adamant_male_a = {
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_a__heard_enemy_chaos_hound_05",
			"loc_adamant_male_a__heard_enemy_chaos_hound_06",
			"loc_adamant_male_a__heard_enemy_chaos_hound_07",
			"loc_adamant_male_a__heard_enemy_chaos_hound_08",
		},
		sound_events_duration = {
			1.275167,
			1.955146,
			1.910677,
			1.604656,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	hunting_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_a__hunting_circumstance_start_b_01",
			"loc_adamant_male_a__hunting_circumstance_start_b_02",
			"loc_adamant_male_a__hunting_circumstance_start_b_03",
			"loc_adamant_male_a__hunting_circumstance_start_b_04",
		},
		sound_events_duration = {
			4.108,
			4.529333,
			2.978667,
			2.428667,
		},
		randomize_indexes = {},
	},
	smart_tag_vo_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_a__smart_tag_vo_enemy_chaos_hound_01",
			"loc_adamant_male_a__smart_tag_vo_enemy_chaos_hound_02",
			"loc_adamant_male_a__smart_tag_vo_enemy_chaos_hound_03",
			"loc_adamant_male_a__smart_tag_vo_enemy_chaos_hound_04",
		},
		sound_events_duration = {
			0.696708,
			0.670896,
			0.841354,
			3.45678,
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

return settings("circumstance_vo_hunting_grounds_adamant_male_a", circumstance_vo_hunting_grounds_adamant_male_a)
