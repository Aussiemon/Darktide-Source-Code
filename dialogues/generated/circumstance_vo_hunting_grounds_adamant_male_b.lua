-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_adamant_male_b.lua

local circumstance_vo_hunting_grounds_adamant_male_b = {
	disabled_by_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_male_b__disabled_by_chaos_hound_01",
			"loc_adamant_male_b__disabled_by_chaos_hound_02",
			"loc_adamant_male_b__disabled_by_chaos_hound_03",
			"loc_adamant_male_b__disabled_by_chaos_hound_04",
			"loc_adamant_male_b__disabled_by_chaos_hound_05",
			"loc_adamant_male_b__disabled_by_chaos_hound_06",
			"loc_adamant_male_b__disabled_by_chaos_hound_07",
			"loc_adamant_male_b__disabled_by_chaos_hound_08",
		},
		sound_events_duration = {
			1.026917,
			2.733333,
			2.281938,
			2.763208,
			1.061792,
			2.866823,
			3.282021,
			3.433333,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_b__heard_enemy_chaos_hound_05",
			"loc_adamant_male_b__heard_enemy_chaos_hound_06",
			"loc_adamant_male_b__heard_enemy_chaos_hound_07",
			"loc_adamant_male_b__heard_enemy_chaos_hound_08",
		},
		sound_events_duration = {
			0.904708,
			1.429865,
			2.961729,
			2.379375,
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
			"loc_adamant_male_b__hunting_circumstance_start_b_01",
			"loc_adamant_male_b__hunting_circumstance_start_b_02",
			"loc_adamant_male_b__hunting_circumstance_start_b_03",
			"loc_adamant_male_b__hunting_circumstance_start_b_04",
		},
		sound_events_duration = {
			2.172063,
			1.863969,
			2.294802,
			2.731677,
		},
		randomize_indexes = {},
	},
	smart_tag_vo_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_b__smart_tag_vo_enemy_chaos_hound_01",
			"loc_adamant_male_b__smart_tag_vo_enemy_chaos_hound_02",
			"loc_adamant_male_b__smart_tag_vo_enemy_chaos_hound_03",
			"loc_adamant_male_b__smart_tag_vo_enemy_chaos_hound_04",
		},
		sound_events_duration = {
			0.760969,
			0.716844,
			0.992771,
			0.626625,
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

return settings("circumstance_vo_hunting_grounds_adamant_male_b", circumstance_vo_hunting_grounds_adamant_male_b)
