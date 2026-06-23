-- chunkname: @dialogues/generated/event_vo_kill_cryptic_a.lua

local event_vo_kill_cryptic_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_a__event_kill_target_damaged_01",
			[2] = "loc_cryptic_a__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 1.548656,
			[2] = 2.149719,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_a__event_kill_target_destroyed_a_01",
			[2] = "loc_cryptic_a__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 3.129125,
			[2] = 3.491177,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_a__event_kill_target_heavy_damage_a_01",
			[2] = "loc_cryptic_a__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 2.733896,
			[2] = 2.779865,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_cryptic_a", event_vo_kill_cryptic_a)
