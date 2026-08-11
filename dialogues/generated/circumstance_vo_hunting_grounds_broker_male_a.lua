-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_broker_male_a.lua

local circumstance_vo_hunting_grounds_broker_male_a = {
	disabled_by_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_male_a__disabled_by_chaos_hound_01",
			"loc_broker_male_a__disabled_by_chaos_hound_02",
			"loc_broker_male_a__disabled_by_chaos_hound_03",
			"loc_broker_male_a__disabled_by_chaos_hound_04",
			"loc_broker_male_a__disabled_by_chaos_hound_05",
		},
		sound_events_duration = {
			3.425688,
			3.652885,
			2.645333,
			3.623563,
			4.297667,
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
			"loc_broker_male_a__heard_enemy_chaos_hound_01",
			"loc_broker_male_a__heard_enemy_chaos_hound_02",
			"loc_broker_male_a__heard_enemy_chaos_hound_03",
			"loc_broker_male_a__heard_enemy_chaos_hound_04",
			"loc_broker_male_a__heard_enemy_chaos_hound_05",
		},
		sound_events_duration = {
			1.654552,
			1.998198,
			1.778594,
			1.997156,
			2.812302,
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
			[1] = "loc_broker_male_a__smart_tag_vo_enemy_chaos_hound_01",
			[2] = "loc_broker_male_a__smart_tag_vo_enemy_chaos_hound_02",
		},
		sound_events_duration = {
			[1] = 0.659,
			[2] = 0.550833,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_broker_male_a", circumstance_vo_hunting_grounds_broker_male_a)
