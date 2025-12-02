-- chunkname: @dialogues/generated/event_vo_survive_broker_female_c.lua

local event_vo_survive_broker_female_c = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__event_survive_almost_done_01",
			[2] = "loc_broker_female_c__event_survive_almost_done_02",
		},
		sound_events_duration = {
			[1] = 2.784979,
			[2] = 2.402583,
		},
		randomize_indexes = {},
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__event_survive_keep_coming_a_01",
			[2] = "loc_broker_female_c__event_survive_keep_coming_a_02",
		},
		sound_events_duration = {
			[1] = 2.248875,
			[2] = 2.70525,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_survive_broker_female_c", event_vo_survive_broker_female_c)
