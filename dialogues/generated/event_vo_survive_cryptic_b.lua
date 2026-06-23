-- chunkname: @dialogues/generated/event_vo_survive_cryptic_b.lua

local event_vo_survive_cryptic_b = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_b__event_survive_almost_done_01",
			[2] = "loc_cryptic_b__event_survive_almost_done_02",
		},
		sound_events_duration = {
			[1] = 4.557552,
			[2] = 3.260604,
		},
		randomize_indexes = {},
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_b__event_survive_keep_coming_a_01",
			[2] = "loc_cryptic_b__event_survive_keep_coming_a_02",
		},
		sound_events_duration = {
			[1] = 3.074479,
			[2] = 4.643833,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_survive_cryptic_b", event_vo_survive_cryptic_b)
