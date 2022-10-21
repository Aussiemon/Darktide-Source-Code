local event_vo_kill_zealot_male_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_b__event_kill_target_damaged_01",
			"loc_zealot_male_b__event_kill_target_damaged_02",
			"loc_zealot_male_b__event_kill_target_damaged_03",
			"loc_zealot_male_b__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.014729,
			2.832708,
			2.0375,
			3.568667
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_b__event_kill_target_destroyed_a_01",
			"loc_zealot_male_b__event_kill_target_destroyed_a_02",
			"loc_zealot_male_b__event_kill_target_destroyed_a_03",
			"loc_zealot_male_b__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			3.906,
			3.373708,
			3.995167,
			3.409979
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_b__event_kill_target_heavy_damage_a_01",
			"loc_zealot_male_b__event_kill_target_heavy_damage_a_02",
			"loc_zealot_male_b__event_kill_target_heavy_damage_a_03",
			"loc_zealot_male_b__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			4.199354,
			4.538208,
			1.573729,
			3.654708
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_zealot_male_b", event_vo_kill_zealot_male_b)
