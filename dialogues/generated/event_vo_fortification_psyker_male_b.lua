-- chunkname: @dialogues/generated/event_vo_fortification_psyker_male_b.lua

local event_vo_fortification_psyker_male_b = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__event_fortification_beacon_deployed_01",
			"loc_psyker_male_b__event_fortification_beacon_deployed_02",
			"loc_psyker_male_b__event_fortification_beacon_deployed_03",
			"loc_psyker_male_b__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			1.779396,
			1.568688,
			2.202667,
			2.440667
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__event_fortification_gate_powered_01",
			"loc_psyker_male_b__event_fortification_gate_powered_02",
			"loc_psyker_male_b__event_fortification_gate_powered_03",
			"loc_psyker_male_b__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			2.547479,
			2.567917,
			3.122625,
			4.050229
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__event_fortification_skyfire_disabled_01",
			"loc_psyker_male_b__event_fortification_skyfire_disabled_02",
			"loc_psyker_male_b__event_fortification_skyfire_disabled_03",
			"loc_psyker_male_b__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			2.071917,
			3.360875,
			3.459417,
			2.922333
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_psyker_male_b", event_vo_fortification_psyker_male_b)
