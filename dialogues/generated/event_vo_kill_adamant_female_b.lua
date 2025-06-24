-- chunkname: @dialogues/generated/event_vo_kill_adamant_female_b.lua

local event_vo_kill_adamant_female_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_b__event_kill_target_damaged_01",
			"loc_adamant_female_b__event_kill_target_damaged_02",
			"loc_adamant_female_b__event_kill_target_damaged_03",
			"loc_adamant_female_b__event_kill_target_damaged_04",
		},
		sound_events_duration = {
			2.419333,
			2.259156,
			2.629344,
			2.82125,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_b__event_kill_target_destroyed_a_01",
			"loc_adamant_female_b__event_kill_target_destroyed_a_02",
			"loc_adamant_female_b__event_kill_target_destroyed_a_03",
			"loc_adamant_female_b__event_kill_target_destroyed_a_04",
		},
		sound_events_duration = {
			3.00124,
			3.650177,
			2.484125,
			3.866583,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_b__event_kill_target_heavy_damage_a_01",
			"loc_adamant_female_b__event_kill_target_heavy_damage_a_02",
			"loc_adamant_female_b__event_kill_target_heavy_damage_a_03",
			"loc_adamant_female_b__event_kill_target_heavy_damage_a_04",
		},
		sound_events_duration = {
			2.217833,
			3.125135,
			2.418333,
			3.448469,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_adamant_female_b", event_vo_kill_adamant_female_b)
