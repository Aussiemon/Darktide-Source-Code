-- chunkname: @dialogues/generated/event_vo_fortification_broker_female_a.lua

local event_vo_fortification_broker_female_a = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_a__event_fortification_beacon_deployed_01",
			[2] = "loc_broker_female_a__event_fortification_beacon_deployed_02",
		},
		sound_events_duration = {
			[1] = 1.886052,
			[2] = 3.36899,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_a__event_fortification_skyfire_disabled_01",
			[2] = "loc_broker_female_a__event_fortification_skyfire_disabled_02",
		},
		sound_events_duration = {
			[1] = 1.790083,
			[2] = 2.279594,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_broker_female_a", event_vo_fortification_broker_female_a)
