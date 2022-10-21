local event_vo_scan_psyker_male_a = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_a__event_scan_first_target_scanned_01",
			[2.0] = "loc_psyker_male_a__event_scan_first_target_scanned_02"
		},
		sound_events_duration = {
			[1.0] = 2.346563,
			[2.0] = 3.723083
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_scan_psyker_male_a", event_vo_scan_psyker_male_a)
