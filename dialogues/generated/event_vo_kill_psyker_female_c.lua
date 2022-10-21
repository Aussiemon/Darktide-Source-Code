local event_vo_kill_psyker_female_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_c__event_kill_target_damaged_01",
			"loc_psyker_female_c__event_kill_target_damaged_02",
			"loc_psyker_female_c__event_kill_target_damaged_03",
			"loc_psyker_female_c__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			1.660073,
			2.783427,
			2.255333,
			2.350042
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_c__event_kill_target_destroyed_a_01",
			"loc_psyker_female_c__event_kill_target_destroyed_a_02",
			"loc_psyker_female_c__event_kill_target_destroyed_a_03",
			"loc_psyker_female_c__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			1.745906,
			2.987813,
			2.234688,
			1.797313
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_c__event_kill_target_heavy_damage_a_01",
			"loc_psyker_female_c__event_kill_target_heavy_damage_a_02",
			"loc_psyker_female_c__event_kill_target_heavy_damage_a_03",
			"loc_psyker_female_c__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			1.736958,
			2.907531,
			2.259021,
			1.524365
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_psyker_female_c", event_vo_kill_psyker_female_c)
