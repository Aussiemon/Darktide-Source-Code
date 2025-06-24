-- chunkname: @dialogues/generated/event_vo_kill_adamant_female_a.lua

local event_vo_kill_adamant_female_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_a__event_kill_target_damaged_01",
			"loc_adamant_female_a__event_kill_target_damaged_02",
			"loc_adamant_female_a__event_kill_target_damaged_03",
			"loc_adamant_female_a__event_kill_target_damaged_04",
		},
		sound_events_duration = {
			1.168,
			2.22401,
			1.408667,
			1.634677,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_a__event_kill_target_destroyed_a_01",
			"loc_adamant_female_a__event_kill_target_destroyed_a_02",
			"loc_adamant_female_a__event_kill_target_destroyed_a_03",
			"loc_adamant_female_a__event_kill_target_destroyed_a_04",
		},
		sound_events_duration = {
			3.390677,
			1.78801,
			2.265344,
			1.909344,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_a__event_kill_target_heavy_damage_a_01",
			"loc_adamant_female_a__event_kill_target_heavy_damage_a_02",
			"loc_adamant_female_a__event_kill_target_heavy_damage_a_03",
			"loc_adamant_female_a__event_kill_target_heavy_damage_a_04",
		},
		sound_events_duration = {
			2.141333,
			3.974677,
			3.042677,
			2.270677,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_adamant_female_a", event_vo_kill_adamant_female_a)
