local event_vo_fortification_veteran_female_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__event_fortification_beacon_deployed_01",
			"loc_veteran_female_c__event_fortification_beacon_deployed_02",
			"loc_veteran_female_c__event_fortification_beacon_deployed_03",
			"loc_veteran_female_c__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			1.456458,
			1.040156,
			1.040531,
			1.666229
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__event_fortification_gate_powered_01",
			"loc_veteran_female_c__event_fortification_gate_powered_02",
			"loc_veteran_female_c__event_fortification_gate_powered_03",
			"loc_veteran_female_c__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			1.301396,
			1.257156,
			1.452802,
			1.6935
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__event_fortification_skyfire_disabled_01",
			"loc_veteran_female_c__event_fortification_skyfire_disabled_02",
			"loc_veteran_female_c__event_fortification_skyfire_disabled_03",
			"loc_veteran_female_c__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			1.700385,
			1.612771,
			1.887313,
			1.772854
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_veteran_female_c", event_vo_fortification_veteran_female_c)
