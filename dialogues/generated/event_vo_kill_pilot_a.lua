-- chunkname: @dialogues/generated/event_vo_kill_pilot_a.lua

local event_vo_kill_pilot_a = {
	event_kill_kill_the_target = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__event_kill_kill_the_target_01",
			"loc_pilot_a__event_kill_kill_the_target_02",
			"loc_pilot_a__event_kill_kill_the_target_03",
			"loc_pilot_a__event_kill_kill_the_target_04",
		},
		sound_events_duration = {
			4.50525,
			3.510146,
			4.574083,
			4.762146,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__event_kill_target_destroyed_b_01",
			"loc_pilot_a__event_kill_target_destroyed_b_02",
			"loc_pilot_a__event_kill_target_destroyed_b_03",
			"loc_pilot_a__event_kill_target_destroyed_b_04",
		},
		sound_events_duration = {
			4.971542,
			3.820188,
			4.457438,
			3.630333,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__event_kill_target_heavy_damage_b_01",
			"loc_pilot_a__event_kill_target_heavy_damage_b_02",
			"loc_pilot_a__event_kill_target_heavy_damage_b_03",
			"loc_pilot_a__event_kill_target_heavy_damage_b_04",
		},
		sound_events_duration = {
			2.076667,
			1.9355,
			2.360021,
			2.693396,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_pilot_a", event_vo_kill_pilot_a)
