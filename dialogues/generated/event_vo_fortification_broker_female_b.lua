-- chunkname: @dialogues/generated/event_vo_fortification_broker_female_b.lua

local event_vo_fortification_broker_female_b = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__event_fortification_beacon_deployed_01",
			[2] = "loc_broker_female_b__event_fortification_beacon_deployed_02",
		},
		sound_events_duration = {
			[1] = 2.367927,
			[2] = 1.825281,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__event_fortification_skyfire_disabled_01",
			[2] = "loc_broker_female_b__event_fortification_skyfire_disabled_02",
		},
		sound_events_duration = {
			[1] = 1.245635,
			[2] = 1.405958,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_broker_female_b", event_vo_fortification_broker_female_b)
