-- chunkname: @dialogues/generated/event_vo_scan_ogryn_d.lua

local event_vo_scan_ogryn_d = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__event_scan_first_target_scanned_01",
			[2] = "loc_ogryn_d__event_scan_first_target_scanned_02",
		},
		sound_events_duration = {
			[1] = 3.095479,
			[2] = 4.575583,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_scan_ogryn_d", event_vo_scan_ogryn_d)
