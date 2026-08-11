-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_cryptic_d.lua

local circumstance_vo_hunting_grounds_cryptic_d = {
	disabled_by_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_cryptic_d__disabled_by_chaos_hound_01",
			"loc_cryptic_d__disabled_by_chaos_hound_02",
			"loc_cryptic_d__disabled_by_chaos_hound_03",
			"loc_cryptic_d__disabled_by_chaos_hound_04",
			"loc_cryptic_d__disabled_by_chaos_hound_05",
		},
		sound_events_duration = {
			4.374167,
			4.015156,
			3.915469,
			2.81676,
			5.062927,
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
			"loc_cryptic_d__heard_enemy_chaos_hound_01",
			"loc_cryptic_d__heard_enemy_chaos_hound_02",
			"loc_cryptic_d__heard_enemy_chaos_hound_03",
			"loc_cryptic_d__heard_enemy_chaos_hound_04",
			"loc_cryptic_d__heard_enemy_chaos_hound_05",
		},
		sound_events_duration = {
			2.099479,
			2.146,
			2.297063,
			2.86026,
			2.403104,
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
			[1] = "loc_cryptic_d__smart_tag_vo_enemy_chaos_hound_01",
			[2] = "loc_cryptic_d__smart_tag_vo_enemy_chaos_hound_02",
		},
		sound_events_duration = {
			[1] = 1.165615,
			[2] = 0.957823,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_cryptic_d", circumstance_vo_hunting_grounds_cryptic_d)
