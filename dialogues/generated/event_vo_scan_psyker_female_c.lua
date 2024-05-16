-- chunkname: @dialogues/generated/event_vo_scan_psyker_female_c.lua

local event_vo_scan_psyker_female_c = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_female_c__event_scan_first_target_scanned_01",
			[2] = "loc_psyker_female_c__event_scan_first_target_scanned_02",
		},
		sound_events_duration = {
			[1] = 2.338813,
			[2] = 2.518385,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_scan_psyker_female_c", event_vo_scan_psyker_female_c)
