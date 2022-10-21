local event_vo_scan_veteran_female_b = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_veteran_female_b__event_scan_first_target_scanned_01",
			[2.0] = "loc_veteran_female_b__event_scan_first_target_scanned_02"
		},
		sound_events_duration = {
			[1.0] = 1.211438,
			[2.0] = 1.404
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_scan_veteran_female_b", event_vo_scan_veteran_female_b)
