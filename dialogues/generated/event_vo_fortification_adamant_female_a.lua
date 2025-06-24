-- chunkname: @dialogues/generated/event_vo_fortification_adamant_female_a.lua

local event_vo_fortification_adamant_female_a = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_a__event_fortification_beacon_deployed_01",
			"loc_adamant_female_a__event_fortification_beacon_deployed_02",
			"loc_adamant_female_a__event_fortification_beacon_deployed_03",
			"loc_adamant_female_a__event_fortification_beacon_deployed_04",
		},
		sound_events_duration = {
			1.41401,
			1.474677,
			1.089333,
			1.055333,
		},
		randomize_indexes = {},
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_a__event_fortification_gate_powered_01",
			"loc_adamant_female_a__event_fortification_gate_powered_02",
			"loc_adamant_female_a__event_fortification_gate_powered_03",
			"loc_adamant_female_a__event_fortification_gate_powered_04",
		},
		sound_events_duration = {
			1.32201,
			1.24201,
			1.25401,
			1.802677,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_a__event_fortification_skyfire_disabled_01",
			"loc_adamant_female_a__event_fortification_skyfire_disabled_02",
			"loc_adamant_female_a__event_fortification_skyfire_disabled_03",
			"loc_adamant_female_a__event_fortification_skyfire_disabled_04",
		},
		sound_events_duration = {
			2.115344,
			1.972677,
			1.40001,
			1.746677,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_adamant_female_a", event_vo_fortification_adamant_female_a)
