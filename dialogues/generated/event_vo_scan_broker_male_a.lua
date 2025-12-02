-- chunkname: @dialogues/generated/event_vo_scan_broker_male_a.lua

local event_vo_scan_broker_male_a = {
	event_scan_first_target_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__event_scan_first_target_scanned_01",
			[2] = "loc_broker_male_a__event_scan_first_target_scanned_02",
		},
		sound_events_duration = {
			[1] = 1.555104,
			[2] = 1.681688,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_scan_broker_male_a", event_vo_scan_broker_male_a)
