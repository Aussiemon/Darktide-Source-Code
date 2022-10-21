local event_vo_fortification_zealot_male_a = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_a__event_fortification_beacon_deployed_01",
			"loc_zealot_male_a__event_fortification_beacon_deployed_02",
			"loc_zealot_male_a__event_fortification_beacon_deployed_03",
			"loc_zealot_male_a__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			3.370208,
			1.591625,
			1.949375,
			3.333063
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_a__event_fortification_gate_powered_01",
			"loc_zealot_male_a__event_fortification_gate_powered_02",
			"loc_zealot_male_a__event_fortification_gate_powered_03",
			"loc_zealot_male_a__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			2.138771,
			2.845083,
			2.7365,
			2.906479
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_a__event_fortification_skyfire_disabled_01",
			"loc_zealot_male_a__event_fortification_skyfire_disabled_02",
			"loc_zealot_male_a__event_fortification_skyfire_disabled_03",
			"loc_zealot_male_a__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			1.332625,
			2.285229,
			2.944708,
			1.886063
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_zealot_male_a", event_vo_fortification_zealot_male_a)
