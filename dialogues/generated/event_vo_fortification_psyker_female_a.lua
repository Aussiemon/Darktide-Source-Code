-- chunkname: @dialogues/generated/event_vo_fortification_psyker_female_a.lua

local event_vo_fortification_psyker_female_a = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__event_fortification_beacon_deployed_01",
			"loc_psyker_female_a__event_fortification_beacon_deployed_02",
			"loc_psyker_female_a__event_fortification_beacon_deployed_03",
			"loc_psyker_female_a__event_fortification_beacon_deployed_04",
		},
		sound_events_duration = {
			1.830292,
			1.529083,
			1.165667,
			2.888688,
		},
		randomize_indexes = {},
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__event_fortification_gate_powered_01",
			"loc_psyker_female_a__event_fortification_gate_powered_02",
			"loc_psyker_female_a__event_fortification_gate_powered_03",
			"loc_psyker_female_a__event_fortification_gate_powered_04",
		},
		sound_events_duration = {
			1.557563,
			2.711792,
			1.554417,
			2.217854,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__event_fortification_skyfire_disabled_01",
			"loc_psyker_female_a__event_fortification_skyfire_disabled_02",
			"loc_psyker_female_a__event_fortification_skyfire_disabled_03",
			"loc_psyker_female_a__event_fortification_skyfire_disabled_04",
		},
		sound_events_duration = {
			2.382063,
			2.626813,
			2.0525,
			3.101042,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_psyker_female_a", event_vo_fortification_psyker_female_a)
