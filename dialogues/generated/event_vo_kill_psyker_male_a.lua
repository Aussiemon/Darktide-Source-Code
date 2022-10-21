local event_vo_kill_psyker_male_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__event_kill_target_damaged_01",
			"loc_psyker_male_a__event_kill_target_damaged_02",
			"loc_psyker_male_a__event_kill_target_damaged_03",
			"loc_psyker_male_a__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.787083,
			2.291104,
			2.465958,
			4.302771
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__event_kill_target_destroyed_a_01",
			"loc_psyker_male_a__event_kill_target_destroyed_a_02",
			"loc_psyker_male_a__event_kill_target_destroyed_a_03",
			"loc_psyker_male_a__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			3.060292,
			3.18475,
			4.763563,
			4.073188
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__event_kill_target_heavy_damage_a_01",
			"loc_psyker_male_a__event_kill_target_heavy_damage_a_02",
			"loc_psyker_male_a__event_kill_target_heavy_damage_a_03",
			"loc_psyker_male_a__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			2.476896,
			4.17,
			2.677125,
			4.326083
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_psyker_male_a", event_vo_kill_psyker_male_a)
