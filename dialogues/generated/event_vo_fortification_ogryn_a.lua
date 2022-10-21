local event_vo_fortification_ogryn_a = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__event_fortification_beacon_deployed_01",
			"loc_ogryn_a__event_fortification_beacon_deployed_02",
			"loc_ogryn_a__event_fortification_beacon_deployed_03",
			"loc_ogryn_a__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			1.332677,
			1.795188,
			1.154833,
			1.49749
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__event_fortification_gate_powered_01",
			"loc_ogryn_a__event_fortification_gate_powered_02",
			"loc_ogryn_a__event_fortification_gate_powered_03",
			"loc_ogryn_a__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			1.538854,
			2.280031,
			2.168646,
			1.561771
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__event_fortification_skyfire_disabled_01",
			"loc_ogryn_a__event_fortification_skyfire_disabled_02",
			"loc_ogryn_a__event_fortification_skyfire_disabled_03",
			"loc_ogryn_a__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			1.85275,
			1.635896,
			1.475667,
			2.163948
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_ogryn_a", event_vo_fortification_ogryn_a)
