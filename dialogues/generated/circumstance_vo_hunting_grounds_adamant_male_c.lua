-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_adamant_male_c.lua

local circumstance_vo_hunting_grounds_adamant_male_c = {
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_c__heard_enemy_chaos_hound_05",
			"loc_adamant_male_c__heard_enemy_chaos_hound_06",
			"loc_adamant_male_c__heard_enemy_chaos_hound_07",
			"loc_adamant_male_c__heard_enemy_chaos_hound_08",
		},
		sound_events_duration = {
			1.172,
			1.866667,
			1.786667,
			2.272,
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
			"loc_adamant_male_c__hunting_circumstance_start_b_01",
			"loc_adamant_male_c__hunting_circumstance_start_b_02",
			"loc_adamant_male_c__hunting_circumstance_start_b_03",
			"loc_adamant_male_c__hunting_circumstance_start_b_04",
		},
		sound_events_duration = {
			3.136948,
			3.489031,
			2.965344,
			4.059906,
		},
		randomize_indexes = {},
	},
	smart_tag_vo_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_c__smart_tag_vo_enemy_chaos_hound_01",
			"loc_adamant_male_c__smart_tag_vo_enemy_chaos_hound_02",
			"loc_adamant_male_c__smart_tag_vo_enemy_chaos_hound_03",
			"loc_adamant_male_c__smart_tag_vo_enemy_chaos_hound_04",
		},
		sound_events_duration = {
			0.613083,
			0.675917,
			0.626271,
			0.557563,
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

return settings("circumstance_vo_hunting_grounds_adamant_male_c", circumstance_vo_hunting_grounds_adamant_male_c)
