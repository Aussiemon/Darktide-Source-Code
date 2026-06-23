-- chunkname: @dialogues/generated/event_vo_survive_cryptic_d.lua

local event_vo_survive_cryptic_d = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__event_survive_almost_done_01",
			[2] = "loc_cryptic_d__event_survive_almost_done_02",
		},
		sound_events_duration = {
			[1] = 2.515208,
			[2] = 6.116635,
		},
		randomize_indexes = {},
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__event_survive_keep_coming_a_01",
			[2] = "loc_cryptic_d__event_survive_keep_coming_a_02",
		},
		sound_events_duration = {
			[1] = 3.76701,
			[2] = 4.972854,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_survive_cryptic_d", event_vo_survive_cryptic_d)
