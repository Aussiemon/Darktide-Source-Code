local event_vo_fortification_ogryn_b = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__event_fortification_beacon_deployed_01",
			"loc_ogryn_b__event_fortification_beacon_deployed_02",
			"loc_ogryn_b__event_fortification_beacon_deployed_03",
			"loc_ogryn_b__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			2.269521,
			2.3215,
			2.354042,
			1.295688
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__event_fortification_gate_powered_01",
			"loc_ogryn_b__event_fortification_gate_powered_02",
			"loc_ogryn_b__event_fortification_gate_powered_03",
			"loc_ogryn_b__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			1.357354,
			2.086042,
			1.820125,
			1.870042
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__event_fortification_skyfire_disabled_01",
			"loc_ogryn_b__event_fortification_skyfire_disabled_02",
			"loc_ogryn_b__event_fortification_skyfire_disabled_03",
			"loc_ogryn_b__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			2.062417,
			2.824406,
			2.213688,
			2.511958
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_ogryn_b", event_vo_fortification_ogryn_b)
