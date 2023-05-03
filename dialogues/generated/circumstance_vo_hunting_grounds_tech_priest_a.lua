local circumstance_vo_hunting_grounds_tech_priest_a = {
	hunting_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__hunting_circumstance_start_a_01",
			"loc_tech_priest_a__hunting_circumstance_start_a_02",
			"loc_tech_priest_a__hunting_circumstance_start_a_03",
			"loc_tech_priest_a__hunting_circumstance_start_a_04"
		},
		sound_events_duration = {
			10.10402,
			9.50525,
			8.724999,
			12.27242
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	}
}

return settings("circumstance_vo_hunting_grounds_tech_priest_a", circumstance_vo_hunting_grounds_tech_priest_a)
