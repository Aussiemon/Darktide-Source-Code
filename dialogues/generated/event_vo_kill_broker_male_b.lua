-- chunkname: @dialogues/generated/event_vo_kill_broker_male_b.lua

local event_vo_kill_broker_male_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_b__event_kill_target_damaged_01",
			[2] = "loc_broker_male_b__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 1.130833,
			[2] = 1.281927,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_b__event_kill_target_destroyed_a_01",
			[2] = "loc_broker_male_b__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 1.06175,
			[2] = 3.512094,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_b__event_kill_target_heavy_damage_a_01",
			[2] = "loc_broker_male_b__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 2.030188,
			[2] = 1.910573,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_broker_male_b", event_vo_kill_broker_male_b)
