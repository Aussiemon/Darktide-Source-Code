-- chunkname: @dialogues/generated/event_vo_fortification_zealot_male_c.lua

local event_vo_fortification_zealot_male_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__event_fortification_beacon_deployed_01",
			"loc_zealot_male_c__event_fortification_beacon_deployed_02",
			"loc_zealot_male_c__event_fortification_beacon_deployed_03",
			"loc_zealot_male_c__event_fortification_beacon_deployed_04"
		},
		sound_events_duration = {
			1.227729,
			2.599458,
			2.369302,
			2.04474
		},
		randomize_indexes = {}
	},
	event_fortification_gate_powered = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__event_fortification_gate_powered_01",
			"loc_zealot_male_c__event_fortification_gate_powered_02",
			"loc_zealot_male_c__event_fortification_gate_powered_03",
			"loc_zealot_male_c__event_fortification_gate_powered_04"
		},
		sound_events_duration = {
			1.15376,
			2.462104,
			2.87501,
			2.522292
		},
		randomize_indexes = {}
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__event_fortification_skyfire_disabled_01",
			"loc_zealot_male_c__event_fortification_skyfire_disabled_02",
			"loc_zealot_male_c__event_fortification_skyfire_disabled_03",
			"loc_zealot_male_c__event_fortification_skyfire_disabled_04"
		},
		sound_events_duration = {
			2.256823,
			2.670948,
			3.113333,
			2.713479
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_zealot_male_c", event_vo_fortification_zealot_male_c)
