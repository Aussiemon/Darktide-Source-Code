-- chunkname: @dialogues/generated/event_vo_kill_broker_female_b.lua

local event_vo_kill_broker_female_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__event_kill_target_damaged_01",
			[2] = "loc_broker_female_b__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 1.014313,
			[2] = 1.748448,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__event_kill_target_destroyed_a_01",
			[2] = "loc_broker_female_b__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 1.163646,
			[2] = 2.606156,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__event_kill_target_heavy_damage_a_01",
			[2] = "loc_broker_female_b__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 2.208073,
			[2] = 1.533313,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_broker_female_b", event_vo_kill_broker_female_b)
