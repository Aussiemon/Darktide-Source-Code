-- chunkname: @dialogues/generated/event_vo_survive_broker_female_b.lua

local event_vo_survive_broker_female_b = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__event_survive_almost_done_01",
			[2] = "loc_broker_female_b__event_survive_almost_done_02",
		},
		sound_events_duration = {
			[1] = 1.362802,
			[2] = 2.411094,
		},
		randomize_indexes = {},
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__event_survive_keep_coming_a_01",
			[2] = "loc_broker_female_b__event_survive_keep_coming_a_02",
		},
		sound_events_duration = {
			[1] = 3.829375,
			[2] = 2.959906,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_survive_broker_female_b", event_vo_survive_broker_female_b)
