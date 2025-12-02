-- chunkname: @dialogues/generated/event_vo_kill_broker_male_a.lua

local event_vo_kill_broker_male_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__event_kill_target_damaged_01",
			[2] = "loc_broker_male_a__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 1.665896,
			[2] = 1.454969,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__event_kill_target_destroyed_a_01",
			[2] = "loc_broker_male_a__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 2.038479,
			[2] = 2.254969,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__event_kill_target_heavy_damage_a_01",
			[2] = "loc_broker_male_a__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 2.215125,
			[2] = 1.421781,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_broker_male_a", event_vo_kill_broker_male_a)
