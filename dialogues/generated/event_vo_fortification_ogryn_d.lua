-- chunkname: @dialogues/generated/event_vo_fortification_ogryn_d.lua

local event_vo_fortification_ogryn_d = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__event_fortification_beacon_deployed_01",
			"loc_ogryn_d__event_fortification_beacon_deployed_02",
			"loc_ogryn_d__event_fortification_beacon_deployed_03",
			"loc_ogryn_d__event_fortification_beacon_deployed_04",
		},
		sound_events_duration = {
			1.785021,
			1.491438,
			3.00001,
			3.804927,
		},
		randomize_indexes = {},
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__event_fortification_gate_powered_01",
			"loc_ogryn_d__event_fortification_gate_powered_02",
			"loc_ogryn_d__event_fortification_gate_powered_03",
			"loc_ogryn_d__event_fortification_gate_powered_04",
		},
		sound_events_duration = {
			1.767396,
			1.908344,
			2.084479,
			3.147271,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__event_fortification_skyfire_disabled_01",
			"loc_ogryn_d__event_fortification_skyfire_disabled_02",
			"loc_ogryn_d__event_fortification_skyfire_disabled_03",
			"loc_ogryn_d__event_fortification_skyfire_disabled_04",
		},
		sound_events_duration = {
			2.260521,
			2.413302,
			3.047469,
			4.7855,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_ogryn_d", event_vo_fortification_ogryn_d)
