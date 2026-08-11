-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_broker_female_b.lua

local circumstance_vo_hunting_grounds_broker_female_b = {
	disabled_by_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_female_b__disabled_by_chaos_hound_01",
			"loc_broker_female_b__disabled_by_chaos_hound_02",
			"loc_broker_female_b__disabled_by_chaos_hound_03",
			"loc_broker_female_b__disabled_by_chaos_hound_04",
			"loc_broker_female_b__disabled_by_chaos_hound_05",
		},
		sound_events_duration = {
			3.005698,
			3.072958,
			3.492813,
			3.074604,
			1.88351,
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
			"loc_broker_female_b__heard_enemy_chaos_hound_01",
			"loc_broker_female_b__heard_enemy_chaos_hound_02",
			"loc_broker_female_b__heard_enemy_chaos_hound_03",
			"loc_broker_female_b__heard_enemy_chaos_hound_04",
			"loc_broker_female_b__heard_enemy_chaos_hound_05",
		},
		sound_events_duration = {
			1.412677,
			1.523625,
			1.376917,
			1.078354,
			1.101083,
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
			[1] = "loc_broker_female_b__smart_tag_vo_enemy_chaos_hound_01",
			[2] = "loc_broker_female_b__smart_tag_vo_enemy_chaos_hound_02",
		},
		sound_events_duration = {
			[1] = 0.682,
			[2] = 0.700677,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_broker_female_b", circumstance_vo_hunting_grounds_broker_female_b)
