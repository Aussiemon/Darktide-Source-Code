-- chunkname: @dialogues/generated/event_vo_kill_cryptic_b.lua

local event_vo_kill_cryptic_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_b__event_kill_target_damaged_01",
			[2] = "loc_cryptic_b__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 1.374042,
			[2] = 2.984438,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_b__event_kill_target_destroyed_a_01",
			[2] = "loc_cryptic_b__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 2.551698,
			[2] = 2.042,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_b__event_kill_target_heavy_damage_a_01",
			[2] = "loc_cryptic_b__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 2.391927,
			[2] = 2.528531,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_cryptic_b", event_vo_kill_cryptic_b)
