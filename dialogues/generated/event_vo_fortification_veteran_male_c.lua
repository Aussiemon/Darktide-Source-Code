-- chunkname: @dialogues/generated/event_vo_fortification_veteran_male_c.lua

local event_vo_fortification_veteran_male_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__event_fortification_beacon_deployed_01",
			"loc_veteran_male_c__event_fortification_beacon_deployed_02",
			"loc_veteran_male_c__event_fortification_beacon_deployed_03",
			"loc_veteran_male_c__event_fortification_beacon_deployed_04",
		},
		sound_events_duration = {
			1.17849,
			0.946594,
			0.925083,
			1.301146,
		},
		randomize_indexes = {},
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__event_fortification_gate_powered_01",
			"loc_veteran_male_c__event_fortification_gate_powered_02",
			"loc_veteran_male_c__event_fortification_gate_powered_03",
			"loc_veteran_male_c__event_fortification_gate_powered_04",
		},
		sound_events_duration = {
			1.19975,
			0.919042,
			0.995865,
			1.001396,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__event_fortification_skyfire_disabled_01",
			"loc_veteran_male_c__event_fortification_skyfire_disabled_02",
			"loc_veteran_male_c__event_fortification_skyfire_disabled_03",
			"loc_veteran_male_c__event_fortification_skyfire_disabled_04",
		},
		sound_events_duration = {
			1.388729,
			1.609073,
			1.734625,
			1.448292,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_veteran_male_c", event_vo_fortification_veteran_male_c)
