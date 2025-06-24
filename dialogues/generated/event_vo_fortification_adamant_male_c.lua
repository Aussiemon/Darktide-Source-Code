-- chunkname: @dialogues/generated/event_vo_fortification_adamant_male_c.lua

local event_vo_fortification_adamant_male_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_c__event_fortification_beacon_deployed_01",
			"loc_adamant_male_c__event_fortification_beacon_deployed_02",
			"loc_adamant_male_c__event_fortification_beacon_deployed_03",
			"loc_adamant_male_c__event_fortification_beacon_deployed_04",
		},
		sound_events_duration = {
			1.238,
			1.882,
			1.164,
			1.332667,
		},
		randomize_indexes = {},
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_c__event_fortification_gate_powered_01",
			"loc_adamant_male_c__event_fortification_gate_powered_02",
			"loc_adamant_male_c__event_fortification_gate_powered_03",
			"loc_adamant_male_c__event_fortification_gate_powered_04",
		},
		sound_events_duration = {
			1.37,
			1.584,
			1.954,
			0.990667,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_c__event_fortification_skyfire_disabled_01",
			"loc_adamant_male_c__event_fortification_skyfire_disabled_02",
			"loc_adamant_male_c__event_fortification_skyfire_disabled_03",
			"loc_adamant_male_c__event_fortification_skyfire_disabled_04",
		},
		sound_events_duration = {
			1.639333,
			1.419333,
			1.747333,
			1.922667,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_adamant_male_c", event_vo_fortification_adamant_male_c)
