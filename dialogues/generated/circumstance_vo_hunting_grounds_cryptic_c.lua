-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_cryptic_c.lua

local circumstance_vo_hunting_grounds_cryptic_c = {
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_cryptic_c__heard_enemy_chaos_hound_01",
			"loc_cryptic_c__heard_enemy_chaos_hound_02",
			"loc_cryptic_c__heard_enemy_chaos_hound_03",
			"loc_cryptic_c__heard_enemy_chaos_hound_04",
			"loc_cryptic_c__heard_enemy_chaos_hound_05",
		},
		sound_events_duration = {
			1.250333,
			1.625688,
			1.488604,
			1.896802,
			1.565406,
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
			[1] = "loc_cryptic_c__smart_tag_vo_enemy_chaos_hound_01",
			[2] = "loc_cryptic_c__smart_tag_vo_enemy_chaos_hound_02",
		},
		sound_events_duration = {
			[1] = 0.61574,
			[2] = 0.568771,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_cryptic_c", circumstance_vo_hunting_grounds_cryptic_c)
