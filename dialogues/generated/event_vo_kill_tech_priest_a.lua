local event_vo_kill_tech_priest_a = {
	event_kill_kill_the_target = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_kill_kill_the_target_01",
			"loc_tech_priest_a__event_kill_kill_the_target_02",
			"loc_tech_priest_a__event_kill_kill_the_target_03",
			"loc_tech_priest_a__event_kill_kill_the_target_04"
		},
		sound_events_duration = {
			5.672125,
			5.071042,
			5.19925,
			4.741917
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_kill_target_destroyed_b_01",
			"loc_tech_priest_a__event_kill_target_destroyed_b_02",
			"loc_tech_priest_a__event_kill_target_destroyed_b_03",
			"loc_tech_priest_a__event_kill_target_destroyed_b_04"
		},
		sound_events_duration = {
			3.99525,
			5.118958,
			6.793458,
			5.630958
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_kill_target_heavy_damage_b_01",
			"loc_tech_priest_a__event_kill_target_heavy_damage_b_02",
			"loc_tech_priest_a__event_kill_target_heavy_damage_b_03",
			"loc_tech_priest_a__event_kill_target_heavy_damage_b_04"
		},
		sound_events_duration = {
			3.987812,
			5.368625,
			5.012833,
			4.309542
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_tech_priest_a", event_vo_kill_tech_priest_a)
