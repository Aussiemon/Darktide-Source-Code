-- chunkname: @dialogues/generated/event_vo_fortification_zealot_female_a.lua

local event_vo_fortification_zealot_female_a = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__event_fortification_beacon_deployed_01",
			"loc_zealot_female_a__event_fortification_beacon_deployed_02",
			"loc_zealot_female_a__event_fortification_beacon_deployed_03",
			"loc_zealot_female_a__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			3.203521,
			1.559021,
			2.015604,
			3.351396
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__event_fortification_gate_powered_01",
			"loc_zealot_female_a__event_fortification_gate_powered_02",
			"loc_zealot_female_a__event_fortification_gate_powered_03",
			"loc_zealot_female_a__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			2.529729,
			2.806604,
			3.133854,
			3.360375
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__event_fortification_skyfire_disabled_01",
			"loc_zealot_female_a__event_fortification_skyfire_disabled_02",
			"loc_zealot_female_a__event_fortification_skyfire_disabled_03",
			"loc_zealot_female_a__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			1.397021,
			2.4225,
			3.146438,
			2.249854
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_zealot_female_a", event_vo_fortification_zealot_female_a)
