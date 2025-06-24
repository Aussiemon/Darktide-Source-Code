-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_adamant_female_b.lua

local circumstance_vo_hunting_grounds_adamant_female_b = {
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_b__heard_enemy_chaos_hound_05",
			"loc_adamant_female_b__heard_enemy_chaos_hound_06",
			"loc_adamant_female_b__heard_enemy_chaos_hound_07",
			"loc_adamant_female_b__heard_enemy_chaos_hound_08",
		},
		sound_events_duration = {
			1.219646,
			1.756802,
			3.131719,
			2.410604,
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
			"loc_adamant_female_b__hunting_circumstance_start_b_01",
			"loc_adamant_female_b__hunting_circumstance_start_b_02",
			"loc_adamant_female_b__hunting_circumstance_start_b_03",
			"loc_adamant_female_b__hunting_circumstance_start_b_04",
		},
		sound_events_duration = {
			2.485344,
			2.01601,
			1.835344,
			2.564677,
		},
		randomize_indexes = {},
	},
	smart_tag_vo_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_b__smart_tag_vo_enemy_chaos_hound_01",
			"loc_adamant_female_b__smart_tag_vo_enemy_chaos_hound_02",
			"loc_adamant_female_b__smart_tag_vo_enemy_chaos_hound_03",
			"loc_adamant_female_b__smart_tag_vo_enemy_chaos_hound_04",
		},
		sound_events_duration = {
			0.992313,
			0.859823,
			3.45678,
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

return settings("circumstance_vo_hunting_grounds_adamant_female_b", circumstance_vo_hunting_grounds_adamant_female_b)
