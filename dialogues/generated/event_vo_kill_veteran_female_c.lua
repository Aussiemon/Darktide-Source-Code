-- chunkname: @dialogues/generated/event_vo_kill_veteran_female_c.lua

local event_vo_kill_veteran_female_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__event_kill_target_damaged_01",
			"loc_veteran_female_c__event_kill_target_damaged_02",
			"loc_veteran_female_c__event_kill_target_damaged_03",
			"loc_veteran_female_c__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			1.429667,
			1.895896,
			1.47125,
			1.90475
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__event_kill_target_destroyed_a_01",
			"loc_veteran_female_c__event_kill_target_destroyed_a_02",
			"loc_veteran_female_c__event_kill_target_destroyed_a_03",
			"loc_veteran_female_c__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			1.45125,
			1.767833,
			1.803677,
			1.980396
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__event_kill_target_heavy_damage_a_01",
			"loc_veteran_female_c__event_kill_target_heavy_damage_a_02",
			"loc_veteran_female_c__event_kill_target_heavy_damage_a_03",
			"loc_veteran_female_c__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			1.624969,
			2.094573,
			1.768479,
			0.783135
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_veteran_female_c", event_vo_kill_veteran_female_c)
