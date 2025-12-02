-- chunkname: @dialogues/generated/event_vo_kill_broker_female_c.lua

local event_vo_kill_broker_female_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__event_kill_target_damaged_01",
			[2] = "loc_broker_female_c__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 2.9585,
			[2] = 2.95324,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__event_kill_target_destroyed_a_01",
			[2] = "loc_broker_female_c__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 4.425396,
			[2] = 2.751531,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__event_kill_target_heavy_damage_a_01",
			[2] = "loc_broker_female_c__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 2.691969,
			[2] = 1.655302,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_broker_female_c", event_vo_kill_broker_female_c)
