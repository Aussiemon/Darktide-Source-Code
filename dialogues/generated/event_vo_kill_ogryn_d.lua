-- chunkname: @dialogues/generated/event_vo_kill_ogryn_d.lua

local event_vo_kill_ogryn_d = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__event_kill_target_damaged_01",
			"loc_ogryn_d__event_kill_target_damaged_02",
			"loc_ogryn_d__event_kill_target_damaged_03",
			"loc_ogryn_d__event_kill_target_damaged_04",
		},
		sound_events_duration = {
			1.996406,
			3.493708,
			4.069146,
			4.292281,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__event_kill_target_destroyed_a_01",
			"loc_ogryn_d__event_kill_target_destroyed_a_02",
			"loc_ogryn_d__event_kill_target_destroyed_a_03",
			"loc_ogryn_d__event_kill_target_destroyed_a_04",
		},
		sound_events_duration = {
			2.410792,
			3.376281,
			4.897073,
			3.405635,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__event_kill_target_heavy_damage_a_01",
			"loc_ogryn_d__event_kill_target_heavy_damage_a_02",
			"loc_ogryn_d__event_kill_target_heavy_damage_a_03",
			"loc_ogryn_d__event_kill_target_heavy_damage_a_04",
		},
		sound_events_duration = {
			4.551938,
			2.522573,
			3.485344,
			3.088563,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_ogryn_d", event_vo_kill_ogryn_d)
