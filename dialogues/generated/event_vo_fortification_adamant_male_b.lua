-- chunkname: @dialogues/generated/event_vo_fortification_adamant_male_b.lua

local event_vo_fortification_adamant_male_b = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_b__event_fortification_beacon_deployed_01",
			"loc_adamant_male_b__event_fortification_beacon_deployed_02",
			"loc_adamant_male_b__event_fortification_beacon_deployed_03",
			"loc_adamant_male_b__event_fortification_beacon_deployed_04",
		},
		sound_events_duration = {
			1.371521,
			1.832833,
			2.684729,
			1.433167,
		},
		randomize_indexes = {},
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_b__event_fortification_gate_powered_01",
			"loc_adamant_male_b__event_fortification_gate_powered_02",
			"loc_adamant_male_b__event_fortification_gate_powered_03",
			"loc_adamant_male_b__event_fortification_gate_powered_04",
		},
		sound_events_duration = {
			1.201865,
			1.627,
			1.454198,
			1.33251,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_b__event_fortification_skyfire_disabled_01",
			"loc_adamant_male_b__event_fortification_skyfire_disabled_02",
			"loc_adamant_male_b__event_fortification_skyfire_disabled_03",
			"loc_adamant_male_b__event_fortification_skyfire_disabled_04",
		},
		sound_events_duration = {
			1.705323,
			1.909417,
			2.796635,
			3.051406,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_adamant_male_b", event_vo_fortification_adamant_male_b)
