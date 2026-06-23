-- chunkname: @dialogues/generated/event_vo_survive_cryptic_c.lua

local event_vo_survive_cryptic_c = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__event_survive_almost_done_01",
			[2] = "loc_cryptic_c__event_survive_almost_done_02",
		},
		sound_events_duration = {
			[1] = 3.050906,
			[2] = 2.850271,
		},
		randomize_indexes = {},
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__event_survive_keep_coming_a_01",
			[2] = "loc_cryptic_c__event_survive_keep_coming_a_02",
		},
		sound_events_duration = {
			[1] = 2.867917,
			[2] = 3.068385,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_survive_cryptic_c", event_vo_survive_cryptic_c)
