-- chunkname: @dialogues/generated/event_vo_fortification_psyker_male_c.lua

local event_vo_fortification_psyker_male_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__event_fortification_beacon_deployed_01",
			"loc_psyker_male_c__event_fortification_beacon_deployed_02",
			"loc_psyker_male_c__event_fortification_beacon_deployed_03",
			"loc_psyker_male_c__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			1.016125,
			0.98824,
			1.016031,
			0.93926
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__event_fortification_gate_powered_01",
			"loc_psyker_male_c__event_fortification_gate_powered_02",
			"loc_psyker_male_c__event_fortification_gate_powered_03",
			"loc_psyker_male_c__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			1.17999,
			1.372292,
			1.42325,
			1.384635
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__event_fortification_skyfire_disabled_01",
			"loc_psyker_male_c__event_fortification_skyfire_disabled_02",
			"loc_psyker_male_c__event_fortification_skyfire_disabled_03",
			"loc_psyker_male_c__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			1.411938,
			1.555781,
			1.496344,
			1.531667
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_psyker_male_c", event_vo_fortification_psyker_male_c)
