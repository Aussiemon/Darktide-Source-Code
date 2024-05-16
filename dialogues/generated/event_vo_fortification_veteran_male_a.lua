-- chunkname: @dialogues/generated/event_vo_fortification_veteran_male_a.lua

local event_vo_fortification_veteran_male_a = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__event_fortification_beacon_deployed_01",
			"loc_veteran_male_a__event_fortification_beacon_deployed_02",
			"loc_veteran_male_a__event_fortification_beacon_deployed_03",
			"loc_veteran_male_a__event_fortification_beacon_deployed_04",
		},
		sound_events_duration = {
			1.264083,
			0.955771,
			1.428583,
			1.614438,
		},
		randomize_indexes = {},
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__event_fortification_gate_powered_01",
			"loc_veteran_male_a__event_fortification_gate_powered_02",
			"loc_veteran_male_a__event_fortification_gate_powered_03",
			"loc_veteran_male_a__event_fortification_gate_powered_04",
		},
		sound_events_duration = {
			1.048854,
			1.719646,
			1.156583,
			1.580896,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__event_fortification_skyfire_disabled_01",
			"loc_veteran_male_a__event_fortification_skyfire_disabled_02",
			"loc_veteran_male_a__event_fortification_skyfire_disabled_03",
			"loc_veteran_male_a__event_fortification_skyfire_disabled_04",
		},
		sound_events_duration = {
			2.052771,
			1.561396,
			1.830271,
			2.140583,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_veteran_male_a", event_vo_fortification_veteran_male_a)
