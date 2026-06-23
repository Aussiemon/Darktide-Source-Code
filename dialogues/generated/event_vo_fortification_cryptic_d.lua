-- chunkname: @dialogues/generated/event_vo_fortification_cryptic_d.lua

local event_vo_fortification_cryptic_d = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__event_fortification_beacon_deployed_01",
			[2] = "loc_cryptic_d__event_fortification_beacon_deployed_02",
		},
		sound_events_duration = {
			[1] = 2.196354,
			[2] = 3.807188,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__event_fortification_skyfire_disabled_01",
			[2] = "loc_cryptic_d__event_fortification_skyfire_disabled_02",
		},
		sound_events_duration = {
			[1] = 3.43649,
			[2] = 2.47251,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_cryptic_d", event_vo_fortification_cryptic_d)
