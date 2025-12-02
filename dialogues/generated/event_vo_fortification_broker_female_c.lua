-- chunkname: @dialogues/generated/event_vo_fortification_broker_female_c.lua

local event_vo_fortification_broker_female_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__event_fortification_beacon_deployed_01",
			[2] = "loc_broker_female_c__event_fortification_beacon_deployed_02",
		},
		sound_events_duration = {
			[1] = 1.217833,
			[2] = 2.5865,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__event_fortification_skyfire_disabled_01",
			[2] = "loc_broker_female_c__event_fortification_skyfire_disabled_02",
		},
		sound_events_duration = {
			[1] = 1.530781,
			[2] = 1.798979,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_broker_female_c", event_vo_fortification_broker_female_c)
