-- chunkname: @dialogues/generated/event_vo_fortification_contract_vendor_a.lua

local event_vo_fortification_contract_vendor_a = {
	event_fortification_disable_the_skyfire = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_contract_vendor_a__event_fortification_disable_the_skyfire_a_01",
			"loc_contract_vendor_a__event_fortification_disable_the_skyfire_a_02",
			"loc_contract_vendor_a__event_fortification_disable_the_skyfire_a_03",
		},
		sound_events_duration = {
			3.722833,
			4.106813,
			4.243094,
		},
		randomize_indexes = {},
	},
	event_fortification_fortification_survive = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_contract_vendor_a__event_fortification_fortification_survive_a_01",
			"loc_contract_vendor_a__event_fortification_fortification_survive_a_02",
			"loc_contract_vendor_a__event_fortification_fortification_survive_a_03",
		},
		sound_events_duration = {
			3.237323,
			3.45426,
			3.501417,
		},
		randomize_indexes = {},
	},
	event_fortification_kill_stragglers = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_contract_vendor_a__event_fortification_kill_all_a_01",
			"loc_contract_vendor_a__event_fortification_kill_all_a_02",
			"loc_contract_vendor_a__event_fortification_kill_all_a_03",
		},
		sound_events_duration = {
			3.878063,
			5.105219,
			4.998063,
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
			"loc_contract_vendor_a__event_fortification_set_landing_beacon_a_01",
			"loc_contract_vendor_a__event_fortification_set_landing_beacon_a_02",
			"loc_contract_vendor_a__event_fortification_set_landing_beacon_a_03",
		},
		sound_events_duration = {
			4.293063,
			4.125146,
			4.05225,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_contract_vendor_a", event_vo_fortification_contract_vendor_a)
