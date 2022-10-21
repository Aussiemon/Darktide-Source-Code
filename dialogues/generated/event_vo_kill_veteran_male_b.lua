local event_vo_kill_veteran_male_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_b__event_kill_target_damaged_01",
			"loc_veteran_male_b__event_kill_target_damaged_02",
			"loc_veteran_male_b__event_kill_target_damaged_03",
			"loc_veteran_male_b__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			3.680167,
			3.202521,
			2.371188,
			1.823021
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_b__event_kill_target_destroyed_a_01",
			"loc_veteran_male_b__event_kill_target_destroyed_a_02",
			"loc_veteran_male_b__event_kill_target_destroyed_a_03",
			"loc_veteran_male_b__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			1.634938,
			2.162167,
			4.206792,
			2.580625
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_b__event_kill_target_heavy_damage_a_01",
			"loc_veteran_male_b__event_kill_target_heavy_damage_a_02",
			"loc_veteran_male_b__event_kill_target_heavy_damage_a_03",
			"loc_veteran_male_b__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			3.380021,
			3.058188,
			3.602083,
			2.066458
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_veteran_male_b", event_vo_kill_veteran_male_b)
