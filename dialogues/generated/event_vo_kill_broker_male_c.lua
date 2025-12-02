-- chunkname: @dialogues/generated/event_vo_kill_broker_male_c.lua

local event_vo_kill_broker_male_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_c__event_kill_target_damaged_01",
			[2] = "loc_broker_male_c__event_kill_target_damaged_02",
		},
		sound_events_duration = {
			[1] = 2.562865,
			[2] = 2.851979,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_c__event_kill_target_destroyed_a_01",
			[2] = "loc_broker_male_c__event_kill_target_destroyed_a_02",
		},
		sound_events_duration = {
			[1] = 3.325063,
			[2] = 1.786302,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_c__event_kill_target_heavy_damage_a_01",
			[2] = "loc_broker_male_c__event_kill_target_heavy_damage_a_02",
		},
		sound_events_duration = {
			[1] = 3.181906,
			[2] = 1.256104,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_broker_male_c", event_vo_kill_broker_male_c)
