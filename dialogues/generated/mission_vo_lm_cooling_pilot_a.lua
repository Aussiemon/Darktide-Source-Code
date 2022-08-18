local mission_vo_lm_cooling_pilot_a = {
	info_bypass_mission_cooling = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_pilot_a__info_bypass_01",
			"loc_pilot_a__info_bypass_02",
			"loc_pilot_a__info_bypass_03",
			"loc_pilot_a__info_bypass_04",
			"loc_pilot_a__info_bypass_05"
		},
		sound_events_duration = {
			4.70048,
			4.272188,
			3.770459,
			3.468355,
			4.910125
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_lm_cooling_pilot_a", mission_vo_lm_cooling_pilot_a)
