-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_broker_male_b.lua

local circumstance_vo_hunting_grounds_broker_male_b = {
	disabled_by_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_male_b__disabled_by_chaos_hound_01",
			"loc_broker_male_b__disabled_by_chaos_hound_02",
			"loc_broker_male_b__disabled_by_chaos_hound_03",
			"loc_broker_male_b__disabled_by_chaos_hound_04",
			"loc_broker_male_b__disabled_by_chaos_hound_05",
		},
		sound_events_duration = {
			1.789823,
			2.154885,
			3.571635,
			2.930906,
			3.428333,
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
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_male_b__heard_enemy_chaos_hound_01",
			"loc_broker_male_b__heard_enemy_chaos_hound_02",
			"loc_broker_male_b__heard_enemy_chaos_hound_03",
			"loc_broker_male_b__heard_enemy_chaos_hound_04",
			"loc_broker_male_b__heard_enemy_chaos_hound_05",
		},
		sound_events_duration = {
			1.753271,
			1.750708,
			1.508656,
			1.225292,
			1.274115,
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
			[1] = "loc_broker_male_b__smart_tag_vo_enemy_chaos_hound_01",
			[2] = "loc_broker_male_b__smart_tag_vo_enemy_chaos_hound_02",
		},
		sound_events_duration = {
			[1] = 0.737531,
			[2] = 0.747052,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_broker_male_b", circumstance_vo_hunting_grounds_broker_male_b)
