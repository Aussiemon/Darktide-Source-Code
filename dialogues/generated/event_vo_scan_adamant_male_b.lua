-- chunkname: @dialogues/generated/event_vo_scan_adamant_male_b.lua

local event_vo_scan_adamant_male_b = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_male_b__event_scan_first_target_scanned_01",
			[2] = "loc_adamant_male_b__event_scan_first_target_scanned_02",
		},
		sound_events_duration = {
			[1] = 2.942813,
			[2] = 2.730385,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_scan_adamant_male_b", event_vo_scan_adamant_male_b)
