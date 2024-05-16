-- chunkname: @dialogues/generated/conversations_hub_ogryn_c.lua

local conversations_hub_ogryn_c = {
	hub_idle_oath_01_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_c__com_wheel_vo_for_the_emperor_01",
			[2] = "loc_ogryn_c__com_wheel_vo_for_the_emperor_02",
		},
		sound_events_duration = {
			[1] = 1.988177,
			[2] = 2.519115,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	shipmistress_hub_announcement_b_50_b = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_ogryn_c__shipmistress_hub_announcement_b_50_b_01",
		},
		sound_events_duration = {
			[1] = 5.627292,
		},
		randomize_indexes = {},
	},
}

return settings("conversations_hub_ogryn_c", conversations_hub_ogryn_c)
