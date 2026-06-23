-- chunkname: @dialogues/generated/event_vo_kill_cryptic_d.lua

local event_vo_kill_cryptic_d = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__event_kill_target_damaged_01",
			[2] = "loc_cryptic_d__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 3.82099,
			[2] = 3.338583,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__event_kill_target_destroyed_a_01",
			[2] = "loc_cryptic_d__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 3.793052,
			[2] = 2.432979,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__event_kill_target_heavy_damage_a_01",
			[2] = "loc_cryptic_d__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 4.055188,
			[2] = 3.648729,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_cryptic_d", event_vo_kill_cryptic_d)
