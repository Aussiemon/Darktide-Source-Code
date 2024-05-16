-- chunkname: @dialogues/generated/event_vo_fortification_ogryn_c.lua

local event_vo_fortification_ogryn_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_fortification_beacon_deployed_01",
			"loc_ogryn_c__event_fortification_beacon_deployed_02",
			"loc_ogryn_c__event_fortification_beacon_deployed_03",
			"loc_ogryn_c__event_fortification_beacon_deployed_04",
		},
		sound_events_duration = {
			1.497646,
			2.310198,
			5.489542,
			1.672865,
		},
		randomize_indexes = {},
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_fortification_gate_powered_01",
			"loc_ogryn_c__event_fortification_gate_powered_02",
			"loc_ogryn_c__event_fortification_gate_powered_03",
			"loc_ogryn_c__event_fortification_gate_powered_04",
		},
		sound_events_duration = {
			1.577302,
			1.683635,
			2.833542,
			1.656813,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_fortification_skyfire_disabled_01",
			"loc_ogryn_c__event_fortification_skyfire_disabled_02",
			"loc_ogryn_c__event_fortification_skyfire_disabled_03",
			"loc_ogryn_c__event_fortification_skyfire_disabled_04",
		},
		sound_events_duration = {
			2.238167,
			2.885292,
			3.988833,
			3.251042,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_ogryn_c", event_vo_fortification_ogryn_c)
