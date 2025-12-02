-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_ogryn_d.lua

local circumstance_vo_hunting_grounds_ogryn_d = {
	disabled_by_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_ogryn_d__disabled_by_chaos_hound_01",
			"loc_ogryn_d__disabled_by_chaos_hound_02",
			"loc_ogryn_d__disabled_by_chaos_hound_03",
			"loc_ogryn_d__disabled_by_chaos_hound_04",
			"loc_ogryn_d__disabled_by_chaos_hound_05",
			"loc_ogryn_d__disabled_by_chaos_hound_06",
			"loc_ogryn_d__disabled_by_chaos_hound_07",
			"loc_ogryn_d__disabled_by_chaos_hound_08",
		},
		sound_events_duration = {
			2.640385,
			1.971854,
			2.835385,
			2.93924,
			3.452354,
			2.464833,
			2.069583,
			3.010917,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
	heard_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__heard_enemy_chaos_hound_05",
			"loc_ogryn_d__heard_enemy_chaos_hound_06",
			"loc_ogryn_d__heard_enemy_chaos_hound_07",
			"loc_ogryn_d__heard_enemy_chaos_hound_08",
		},
		sound_events_duration = {
			1.626479,
			2.642292,
			1.649958,
			1.937688,
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
			"loc_ogryn_d__hunting_circumstance_start_b_01",
			"loc_ogryn_d__hunting_circumstance_start_b_02",
			"loc_ogryn_d__hunting_circumstance_start_b_03",
			"loc_ogryn_d__hunting_circumstance_start_b_04",
		},
		sound_events_duration = {
			5.355427,
			4.9745,
			4.391865,
			5.247854,
		},
		randomize_indexes = {},
	},
	smart_tag_vo_enemy_chaos_hound_mutator = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__smart_tag_vo_enemy_chaos_hound_01",
			"loc_ogryn_d__smart_tag_vo_enemy_chaos_hound_02",
			"loc_ogryn_d__smart_tag_vo_enemy_chaos_hound_03",
			"loc_ogryn_d__smart_tag_vo_enemy_chaos_hound_04",
		},
		sound_events_duration = {
			1.076208,
			0.827073,
			0.820479,
			1.025302,
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

return settings("circumstance_vo_hunting_grounds_ogryn_d", circumstance_vo_hunting_grounds_ogryn_d)
