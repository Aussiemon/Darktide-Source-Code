-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_broker_female_c.lua

local circumstance_vo_hunting_grounds_broker_female_c = {
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_female_c__heard_enemy_chaos_hound_01",
			"loc_broker_female_c__heard_enemy_chaos_hound_02",
			"loc_broker_female_c__heard_enemy_chaos_hound_03",
			"loc_broker_female_c__heard_enemy_chaos_hound_04",
			"loc_broker_female_c__heard_enemy_chaos_hound_05",
		},
		sound_events_duration = {
			2.334594,
			1.579188,
			2.110823,
			3.201646,
			1.745885,
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
			[1] = "loc_broker_female_c__smart_tag_vo_enemy_chaos_hound_01",
			[2] = "loc_broker_female_c__smart_tag_vo_enemy_chaos_hound_02",
		},
		sound_events_duration = {
			[1] = 0.7675,
			[2] = 0.795292,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_broker_female_c", circumstance_vo_hunting_grounds_broker_female_c)
