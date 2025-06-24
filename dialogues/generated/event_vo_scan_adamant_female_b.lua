-- chunkname: @dialogues/generated/event_vo_scan_adamant_female_b.lua

local event_vo_scan_adamant_female_b = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_b__event_scan_first_target_scanned_01",
			[2] = "loc_adamant_female_b__event_scan_first_target_scanned_02",
		},
		sound_events_duration = {
			[1] = 3.366677,
			[2] = 2.719635,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_scan_adamant_female_b", event_vo_scan_adamant_female_b)
