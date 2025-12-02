-- chunkname: @dialogues/generated/event_vo_kill_broker_female_a.lua

local event_vo_kill_broker_female_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_a__event_kill_target_damaged_01",
			[2] = "loc_broker_female_a__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 1.924135,
			[2] = 1.741188,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_a__event_kill_target_destroyed_a_01",
			[2] = "loc_broker_female_a__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 1.69701,
			[2] = 2.737938,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_a__event_kill_target_heavy_damage_a_01",
			[2] = "loc_broker_female_a__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 2.245875,
			[2] = 1.816875,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_broker_female_a", event_vo_kill_broker_female_a)
