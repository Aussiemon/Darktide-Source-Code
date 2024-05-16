﻿-- chunkname: @dialogues/generated/event_vo_scan_psyker_male_c.lua

local event_vo_scan_psyker_male_c = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_c__event_scan_first_target_scanned_01",
			[2] = "loc_psyker_male_c__event_scan_first_target_scanned_02",
		},
		sound_events_duration = {
			[1] = 1.719792,
			[2] = 1.618917,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_scan_psyker_male_c", event_vo_scan_psyker_male_c)
