-- chunkname: @dialogues/generated/event_vo_kill_cryptic_c.lua

local event_vo_kill_cryptic_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__event_kill_target_damaged_01",
			[2] = "loc_cryptic_c__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 1.917938,
			[2] = 2.053167,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__event_kill_target_destroyed_a_01",
			[2] = "loc_cryptic_c__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 1.690719,
			[2] = 1.761208,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__event_kill_target_heavy_damage_a_01",
			[2] = "loc_cryptic_c__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 2.508031,
			[2] = 2.301573,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_cryptic_c", event_vo_kill_cryptic_c)
