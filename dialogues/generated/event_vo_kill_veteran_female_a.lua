local event_vo_kill_veteran_female_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_a__event_kill_target_damaged_01",
			"loc_veteran_female_a__event_kill_target_damaged_02",
			"loc_veteran_female_a__event_kill_target_damaged_03",
			"loc_veteran_female_a__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			1.457333,
			1.519125,
			2.370313,
			1.891521
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_a__event_kill_target_destroyed_a_01",
			"loc_veteran_female_a__event_kill_target_destroyed_a_02",
			"loc_veteran_female_a__event_kill_target_destroyed_a_03",
			"loc_veteran_female_a__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			2.776396,
			2.422271,
			2.51175,
			2.880479
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_a__event_kill_target_heavy_damage_a_01",
			"loc_veteran_female_a__event_kill_target_heavy_damage_a_02",
			"loc_veteran_female_a__event_kill_target_heavy_damage_a_03",
			"loc_veteran_female_a__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			2.604708,
			3.550958,
			2.232042,
			2.656729
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_veteran_female_a", event_vo_kill_veteran_female_a)
