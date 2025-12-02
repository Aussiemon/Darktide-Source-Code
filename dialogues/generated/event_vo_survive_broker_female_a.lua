-- chunkname: @dialogues/generated/event_vo_survive_broker_female_a.lua

local event_vo_survive_broker_female_a = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_a__event_survive_almost_done_01",
			[2] = "loc_broker_female_a__event_survive_almost_done_02",
		},
		sound_events_duration = {
			[1] = 3.09651,
			[2] = 4.036813,
		},
		randomize_indexes = {},
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_a__event_survive_keep_coming_a_01",
			[2] = "loc_broker_female_a__event_survive_keep_coming_a_02",
		},
		sound_events_duration = {
			[1] = 3.242417,
			[2] = 2.14,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_survive_broker_female_a", event_vo_survive_broker_female_a)
