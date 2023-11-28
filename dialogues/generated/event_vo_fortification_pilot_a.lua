-- chunkname: @dialogues/generated/event_vo_fortification_pilot_a.lua

local event_vo_fortification_pilot_a = {
	event_fortification_disable_the_skyfire = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__event_fortification_disable_the_skyfire_01",
			"loc_pilot_a__event_fortification_disable_the_skyfire_02",
			"loc_pilot_a__event_fortification_disable_the_skyfire_03",
			"loc_pilot_a__event_fortification_disable_the_skyfire_04"
		},
		sound_events_duration = {
			3.749958,
			4.841333,
			3.613104,
			5.005146
		},
		randomize_indexes = {}
	},
	event_fortification_fortification_survive = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__event_fortification_fortification_survive_01",
			"loc_pilot_a__event_fortification_fortification_survive_02",
			"loc_pilot_a__event_fortification_fortification_survive_03",
			"loc_pilot_a__event_fortification_fortification_survive_04"
		},
		sound_events_duration = {
			3.445771,
			4.005375,
			4.352563,
			3.915417
		},
		randomize_indexes = {}
	},
	event_fortification_kill_stragglers = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_pilot_a__info_event_demolition_corruptors_almost_done_01",
			"loc_pilot_a__info_event_demolition_corruptors_almost_done_03",
			"loc_pilot_a__info_event_demolition_corruptors_almost_done_04"
		},
		sound_events_duration = {
			2.1745,
			2.792167,
			3.160646
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	event_fortification_power_up_gate = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__event_fortification_power_up_gate_01",
			"loc_pilot_a__event_fortification_power_up_gate_02",
			"loc_pilot_a__event_fortification_power_up_gate_03",
			"loc_pilot_a__event_fortification_power_up_gate_04"
		},
		sound_events_duration = {
			3.670396,
			3.314208,
			4.021438,
			3.629229
		},
		randomize_indexes = {}
	},
	event_fortification_set_landing_beacon = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__event_fortification_set_landing_beacon_01",
			"loc_pilot_a__event_fortification_set_landing_beacon_02",
			"loc_pilot_a__event_fortification_set_landing_beacon_03",
			"loc_pilot_a__event_fortification_set_landing_beacon_04"
		},
		sound_events_duration = {
			6.095958,
			4.834958,
			3.417396,
			5.712854
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_pilot_a", event_vo_fortification_pilot_a)
