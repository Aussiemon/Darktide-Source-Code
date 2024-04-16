local conversations_hub_veteran_female_b = {
	hub_idle_oath_01_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_b__com_wheel_vo_for_the_emperor_01",
			[2.0] = "loc_veteran_female_b__com_wheel_vo_for_the_emperor_02"
		},
		sound_events_duration = {
			[1.0] = 1.237854,
			[2.0] = 1.329917
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	}
}

return settings("conversations_hub_veteran_female_b", conversations_hub_veteran_female_b)
