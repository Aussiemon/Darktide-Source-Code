local event_vo_scan_ogryn_c = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_ogryn_c__event_scan_first_target_scanned_01"
		},
		sound_events_duration = {
			[1.0] = 2.17075
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_scan_ogryn_c", event_vo_scan_ogryn_c)
