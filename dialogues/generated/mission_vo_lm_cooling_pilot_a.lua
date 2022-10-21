local mission_vo_lm_cooling_pilot_a = {
	mission_cooling_leaving_response = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__cmd_mission_completed_response_01",
			"loc_pilot_a__cmd_mission_completed_response_02",
			"loc_pilot_a__cmd_mission_completed_response_03",
			"loc_pilot_a__cmd_mission_completed_response_04"
		},
		sound_events_duration = {
			3.689583,
			4.107542,
			2.011313,
			2.550854
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

return settings("mission_vo_lm_cooling_pilot_a", mission_vo_lm_cooling_pilot_a)
