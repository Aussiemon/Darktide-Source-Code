-- chunkname: @dialogues/generated/event_vo_kill_ogryn_a.lua

local event_vo_kill_ogryn_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__event_kill_target_damaged_01",
			"loc_ogryn_a__event_kill_target_damaged_02",
			"loc_ogryn_a__event_kill_target_damaged_03",
			"loc_ogryn_a__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.553698,
			2.171344,
			1.248156,
			1.612948
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__event_kill_target_destroyed_a_01",
			"loc_ogryn_a__event_kill_target_destroyed_a_02",
			"loc_ogryn_a__event_kill_target_destroyed_a_03",
			"loc_ogryn_a__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			2.444948,
			2.601781,
			3.183042,
			3.01124
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__event_kill_target_heavy_damage_a_01",
			"loc_ogryn_a__event_kill_target_heavy_damage_a_02",
			"loc_ogryn_a__event_kill_target_heavy_damage_a_03",
			"loc_ogryn_a__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			2.161552,
			2.495854,
			2.676938,
			1.769698
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_ogryn_a", event_vo_kill_ogryn_a)
