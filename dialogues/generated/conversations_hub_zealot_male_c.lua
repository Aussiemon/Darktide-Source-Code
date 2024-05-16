-- chunkname: @dialogues/generated/conversations_hub_zealot_male_c.lua

local conversations_hub_zealot_male_c = {
	hub_idle_oath_01_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_c__com_wheel_vo_for_the_emperor_01",
			[2] = "loc_zealot_male_c__com_wheel_vo_for_the_emperor_02",
		},
		sound_events_duration = {
			[1] = 1.881323,
			[2] = 2.27774,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("conversations_hub_zealot_male_c", conversations_hub_zealot_male_c)
