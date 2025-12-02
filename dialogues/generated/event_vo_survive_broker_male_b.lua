-- chunkname: @dialogues/generated/event_vo_survive_broker_male_b.lua

local event_vo_survive_broker_male_b = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_b__event_survive_almost_done_01",
			[2] = "loc_broker_male_b__event_survive_almost_done_02",
		},
		sound_events_duration = {
			[1] = 1.332115,
			[2] = 2.800646,
		},
		randomize_indexes = {},
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_b__event_survive_keep_coming_a_01",
			[2] = "loc_broker_male_b__event_survive_keep_coming_a_02",
		},
		sound_events_duration = {
			[1] = 3.823094,
			[2] = 3.631469,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_survive_broker_male_b", event_vo_survive_broker_male_b)
