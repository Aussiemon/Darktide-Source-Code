local event_vo_kill_zealot_male_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_a__event_kill_target_damaged_01",
			"loc_zealot_male_a__event_kill_target_damaged_02",
			"loc_zealot_male_a__event_kill_target_damaged_03",
			"loc_zealot_male_a__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.384229,
			2.524333,
			4.072167,
			2.014729
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_a__event_kill_target_destroyed_a_01",
			"loc_zealot_male_a__event_kill_target_destroyed_a_02",
			"loc_zealot_male_a__event_kill_target_destroyed_a_03",
			"loc_zealot_male_a__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			3.634271,
			3.236042,
			2.141354,
			3.364813
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_a__event_kill_target_heavy_damage_a_01",
			"loc_zealot_male_a__event_kill_target_heavy_damage_a_02",
			"loc_zealot_male_a__event_kill_target_heavy_damage_a_03",
			"loc_zealot_male_a__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			3.256521,
			1.601188,
			3.500813,
			2.149104
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_zealot_male_a", event_vo_kill_zealot_male_a)
