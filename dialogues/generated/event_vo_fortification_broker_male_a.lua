-- chunkname: @dialogues/generated/event_vo_fortification_broker_male_a.lua

local event_vo_fortification_broker_male_a = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__event_fortification_beacon_deployed_01",
			[2] = "loc_broker_male_a__event_fortification_beacon_deployed_02",
		},
		sound_events_duration = {
			[1] = 2.084177,
			[2] = 2.665542,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__event_fortification_skyfire_disabled_01",
			[2] = "loc_broker_male_a__event_fortification_skyfire_disabled_02",
		},
		sound_events_duration = {
			[1] = 1.864594,
			[2] = 2.653271,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_broker_male_a", event_vo_fortification_broker_male_a)
