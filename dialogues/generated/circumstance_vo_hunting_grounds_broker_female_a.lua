-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_broker_female_a.lua

local circumstance_vo_hunting_grounds_broker_female_a = {
	disabled_by_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_female_a__disabled_by_chaos_hound_01",
			"loc_broker_female_a__disabled_by_chaos_hound_02",
			"loc_broker_female_a__disabled_by_chaos_hound_03",
			"loc_broker_female_a__disabled_by_chaos_hound_04",
			"loc_broker_female_a__disabled_by_chaos_hound_05",
		},
		sound_events_duration = {
			4.276021,
			6.531604,
			3.493771,
			5.974917,
			3.949688,
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
			"loc_broker_female_a__heard_enemy_chaos_hound_01",
			"loc_broker_female_a__heard_enemy_chaos_hound_02",
			"loc_broker_female_a__heard_enemy_chaos_hound_03",
			"loc_broker_female_a__heard_enemy_chaos_hound_04",
			"loc_broker_female_a__heard_enemy_chaos_hound_05",
		},
		sound_events_duration = {
			1.943052,
			2.075542,
			2.283719,
			2.346813,
			2.95875,
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
			[1] = "loc_broker_female_a__smart_tag_vo_enemy_chaos_hound_01",
			[2] = "loc_broker_female_a__smart_tag_vo_enemy_chaos_hound_02",
		},
		sound_events_duration = {
			[1] = 0.594667,
			[2] = 0.507979,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_broker_female_a", circumstance_vo_hunting_grounds_broker_female_a)
