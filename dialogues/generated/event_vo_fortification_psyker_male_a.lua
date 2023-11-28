-- chunkname: @dialogues/generated/event_vo_fortification_psyker_male_a.lua

local event_vo_fortification_psyker_male_a = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__event_fortification_beacon_deployed_01",
			"loc_psyker_male_a__event_fortification_beacon_deployed_02",
			"loc_psyker_male_a__event_fortification_beacon_deployed_03",
			"loc_psyker_male_a__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			2.050833,
			2.089333,
			1.580542,
			5.263167
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__event_fortification_gate_powered_01",
			"loc_psyker_male_a__event_fortification_gate_powered_02",
			"loc_psyker_male_a__event_fortification_gate_powered_03",
			"loc_psyker_male_a__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			2.072229,
			4.349813,
			1.848875,
			3.313604
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__event_fortification_skyfire_disabled_01",
			"loc_psyker_male_a__event_fortification_skyfire_disabled_02",
			"loc_psyker_male_a__event_fortification_skyfire_disabled_03",
			"loc_psyker_male_a__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			2.875896,
			3.878229,
			2.798396,
			3.952167
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_psyker_male_a", event_vo_fortification_psyker_male_a)
