-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_cryptic_a.lua

local circumstance_vo_hunting_grounds_cryptic_a = {
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_cryptic_a__heard_enemy_chaos_hound_01",
			"loc_cryptic_a__heard_enemy_chaos_hound_02",
			"loc_cryptic_a__heard_enemy_chaos_hound_03",
			"loc_cryptic_a__heard_enemy_chaos_hound_04",
			"loc_cryptic_a__heard_enemy_chaos_hound_05",
		},
		sound_events_duration = {
			2.121135,
			2.050563,
			2.609313,
			2.435104,
			2.227292,
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
	smart_tag_vo_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_a__smart_tag_vo_enemy_chaos_hound_01",
			[2] = "loc_cryptic_a__smart_tag_vo_enemy_chaos_hound_02",
		},
		sound_events_duration = {
			[1] = 0.585115,
			[2] = 0.741302,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_cryptic_a", circumstance_vo_hunting_grounds_cryptic_a)
