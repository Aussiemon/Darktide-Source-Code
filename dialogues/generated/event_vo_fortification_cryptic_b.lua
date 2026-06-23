-- chunkname: @dialogues/generated/event_vo_fortification_cryptic_b.lua

local event_vo_fortification_cryptic_b = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_b__event_fortification_beacon_deployed_01",
			[2] = "loc_cryptic_b__event_fortification_beacon_deployed_02",
		},
		sound_events_duration = {
			[1] = 3.080583,
			[2] = 1.48401,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_b__event_fortification_skyfire_disabled_01",
			[2] = "loc_cryptic_b__event_fortification_skyfire_disabled_02",
		},
		sound_events_duration = {
			[1] = 2.308271,
			[2] = 2.415865,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_cryptic_b", event_vo_fortification_cryptic_b)
