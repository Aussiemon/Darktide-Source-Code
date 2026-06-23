-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_broker_male_c.lua

local circumstance_vo_hunting_grounds_broker_male_c = {
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_male_c__heard_enemy_chaos_hound_01",
			"loc_broker_male_c__heard_enemy_chaos_hound_02",
			"loc_broker_male_c__heard_enemy_chaos_hound_03",
			"loc_broker_male_c__heard_enemy_chaos_hound_04",
			"loc_broker_male_c__heard_enemy_chaos_hound_05",
		},
		sound_events_duration = {
			2.04326,
			1.647667,
			1.991354,
			2.798469,
			1.612125,
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
			[1] = "loc_broker_male_c__smart_tag_vo_enemy_chaos_hound_01",
			[2] = "loc_broker_male_c__smart_tag_vo_enemy_chaos_hound_02",
		},
		sound_events_duration = {
			[1] = 0.746667,
			[2] = 0.747979,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_broker_male_c", circumstance_vo_hunting_grounds_broker_male_c)
