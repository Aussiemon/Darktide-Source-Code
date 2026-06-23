-- chunkname: @dialogues/generated/event_vo_scan_cryptic_d.lua

local event_vo_scan_cryptic_d = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__event_scan_first_target_scanned_01",
			[2] = "loc_cryptic_d__event_scan_first_target_scanned_02",
		},
		sound_events_duration = {
			[1] = 3.623292,
			[2] = 3.653156,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_scan_cryptic_d", event_vo_scan_cryptic_d)
