-- chunkname: @dialogues/generated/event_vo_fortification_cryptic_c.lua

local event_vo_fortification_cryptic_c = {
	event_fortification_beacon_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__event_fortification_beacon_deployed_01",
			[2] = "loc_cryptic_c__event_fortification_beacon_deployed_02",
		},
		sound_events_duration = {
			[1] = 1.55251,
			[2] = 1.765958,
		},
		randomize_indexes = {},
	},
	event_fortification_skyfire_disabled = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__event_fortification_skyfire_disabled_01",
			[2] = "loc_cryptic_c__event_fortification_skyfire_disabled_02",
		},
		sound_events_duration = {
			[1] = 2.245958,
			[2] = 1.919688,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_fortification_cryptic_c", event_vo_fortification_cryptic_c)
