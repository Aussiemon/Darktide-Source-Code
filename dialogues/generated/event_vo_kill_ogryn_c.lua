-- chunkname: @dialogues/generated/event_vo_kill_ogryn_c.lua

local event_vo_kill_ogryn_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_kill_target_damaged_01",
			"loc_ogryn_c__event_kill_target_damaged_02",
			"loc_ogryn_c__event_kill_target_damaged_03",
			"loc_ogryn_c__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			3.452698,
			3.113438,
			1.858396,
			2.787958
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_kill_target_destroyed_a_01",
			"loc_ogryn_c__event_kill_target_destroyed_a_02",
			"loc_ogryn_c__event_kill_target_destroyed_a_03",
			"loc_ogryn_c__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			3.172063,
			1.934656,
			4.704146,
			1.886427
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_kill_target_heavy_damage_a_01",
			"loc_ogryn_c__event_kill_target_heavy_damage_a_02",
			"loc_ogryn_c__event_kill_target_heavy_damage_a_03",
			"loc_ogryn_c__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			2.30849,
			3.585656,
			3.882375,
			4.960021
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_ogryn_c", event_vo_kill_ogryn_c)
