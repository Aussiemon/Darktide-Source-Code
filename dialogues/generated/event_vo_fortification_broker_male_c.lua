-- chunkname: @dialogues/generated/event_vo_fortification_broker_male_c.lua

local event_vo_fortification_broker_male_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_c__event_fortification_beacon_deployed_01",
			[2] = "loc_broker_male_c__event_fortification_beacon_deployed_02",
		},
		sound_events_duration = {
			[1] = 1.218,
			[2] = 2.646344,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_c__event_fortification_skyfire_disabled_01",
			[2] = "loc_broker_male_c__event_fortification_skyfire_disabled_02",
		},
		sound_events_duration = {
			[1] = 1.806333,
			[2] = 1.935344,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_broker_male_c", event_vo_fortification_broker_male_c)
