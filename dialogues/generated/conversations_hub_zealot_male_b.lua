local conversations_hub_zealot_male_b = {
	hub_idle_oath_01_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_male_b__com_wheel_vo_for_the_emperor_01",
			[2.0] = "loc_zealot_male_b__com_wheel_vo_for_the_emperor_02"
		},
		sound_events_duration = {
			[1.0] = 2.481167,
			[2.0] = 2.377417
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	}
}

return settings("conversations_hub_zealot_male_b", conversations_hub_zealot_male_b)
