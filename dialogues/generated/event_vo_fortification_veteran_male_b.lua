local event_vo_fortification_veteran_male_b = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_b__event_fortification_beacon_deployed_01",
			"loc_veteran_male_b__event_fortification_beacon_deployed_02",
			"loc_veteran_male_b__event_fortification_beacon_deployed_03",
			"loc_veteran_male_b__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			3.726479,
			1.703833,
			3.375563,
			3.624604
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_b__event_fortification_gate_powered_01",
			"loc_veteran_male_b__event_fortification_gate_powered_02",
			"loc_veteran_male_b__event_fortification_gate_powered_03",
			"loc_veteran_male_b__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			2.312063,
			2.839792,
			1.560854,
			3.677458
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_b__event_fortification_skyfire_disabled_01",
			"loc_veteran_male_b__event_fortification_skyfire_disabled_02",
			"loc_veteran_male_b__event_fortification_skyfire_disabled_03",
			"loc_veteran_male_b__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			2.725458,
			2.996917,
			2.186417,
			2.041063
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_veteran_male_b", event_vo_fortification_veteran_male_b)
