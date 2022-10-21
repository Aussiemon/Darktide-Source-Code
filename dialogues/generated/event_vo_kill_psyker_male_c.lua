local event_vo_kill_psyker_male_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__event_kill_target_damaged_01",
			"loc_psyker_male_c__event_kill_target_damaged_02",
			"loc_psyker_male_c__event_kill_target_damaged_03",
			"loc_psyker_male_c__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.051177,
			1.540438,
			1.52526,
			1.880313
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__event_kill_target_destroyed_a_01",
			"loc_psyker_male_c__event_kill_target_destroyed_a_02",
			"loc_psyker_male_c__event_kill_target_destroyed_a_03",
			"loc_psyker_male_c__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			2.135344,
			2.668,
			1.601688,
			1.427385
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__event_kill_target_heavy_damage_a_01",
			"loc_psyker_male_c__event_kill_target_heavy_damage_a_02",
			"loc_psyker_male_c__event_kill_target_heavy_damage_a_03",
			"loc_psyker_male_c__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			1.459281,
			2.467427,
			1.665156,
			1.367458
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_psyker_male_c", event_vo_kill_psyker_male_c)
