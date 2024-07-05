-- chunkname: @dialogues/generated/event_vo_fortification_boon_vendor_a.lua

local event_vo_fortification_boon_vendor_a = {
	event_fortification_fortification_survive = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_boon_vendor_a__event_fortification_fortification_survive_a_01",
			"loc_boon_vendor_a__event_fortification_fortification_survive_a_02",
			"loc_boon_vendor_a__event_fortification_fortification_survive_a_03",
		},
		sound_events_duration = {
			3.666677,
			4.378677,
			4.866677,
		},
		randomize_indexes = {},
	},
	event_fortification_kill_stragglers = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_boon_vendor_a__event_fortification_kill_all_a_01",
			"loc_boon_vendor_a__event_fortification_kill_all_a_02",
			"loc_boon_vendor_a__event_fortification_kill_all_a_03",
		},
		sound_events_duration = {
			4.627604,
			4.666677,
			6.00001,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	event_fortification_set_landing_beacon = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_boon_vendor_a__event_fortification_set_landing_beacon_a_01",
			"loc_boon_vendor_a__event_fortification_set_landing_beacon_a_02",
			"loc_boon_vendor_a__event_fortification_set_landing_beacon_a_03",
		},
		sound_events_duration = {
			3.333344,
			2.80001,
			4.466677,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_boon_vendor_a", event_vo_fortification_boon_vendor_a)
