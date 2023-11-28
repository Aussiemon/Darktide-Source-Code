-- chunkname: @dialogues/generated/event_vo_kill_ogryn_b.lua

local event_vo_kill_ogryn_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__event_kill_target_damaged_01",
			"loc_ogryn_b__event_kill_target_damaged_02",
			"loc_ogryn_b__event_kill_target_damaged_03",
			"loc_ogryn_b__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.046656,
			2.649438,
			2.010229,
			1.946208
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__event_kill_target_destroyed_a_01",
			"loc_ogryn_b__event_kill_target_destroyed_a_02",
			"loc_ogryn_b__event_kill_target_destroyed_a_03",
			"loc_ogryn_b__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			1.871375,
			3.323396,
			2.377469,
			5.588365
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__event_kill_target_heavy_damage_a_01",
			"loc_ogryn_b__event_kill_target_heavy_damage_a_02",
			"loc_ogryn_b__event_kill_target_heavy_damage_a_03",
			"loc_ogryn_b__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			1.684375,
			2.63076,
			1.6465,
			2.326948
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_ogryn_b", event_vo_kill_ogryn_b)
