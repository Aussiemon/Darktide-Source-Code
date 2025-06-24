-- chunkname: @dialogues/generated/conversations_hub_adamant_male_b.lua

local conversations_hub_adamant_male_b = {
	hub_idle_oath_01_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_male_b__com_wheel_vo_for_the_emperor_01",
			[2] = "loc_adamant_male_b__com_wheel_vo_for_the_emperor_02",
		},
		sound_events_duration = {
			[1] = 1.256667,
			[2] = 1.746,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
}

return settings("conversations_hub_adamant_male_b", conversations_hub_adamant_male_b)
