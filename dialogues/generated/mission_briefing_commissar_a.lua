-- chunkname: @dialogues/generated/mission_briefing_commissar_a.lua

local mission_briefing_commissar_a = {
	mission_scavenge_briefing_one = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_commissar_a__mission_scavenge_briefing_one_01",
			[2] = "loc_commissar_a__mission_scavenge_briefing_one_02",
		},
		sound_events_duration = {
			[1] = 10.70598,
			[2] = 10.84192,
		},
		randomize_indexes = {},
	},
	mission_scavenge_briefing_three = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_commissar_a__mission_scavenge_briefing_three_01",
			[2] = "loc_commissar_a__mission_scavenge_briefing_three_02",
		},
		sound_events_duration = {
			[1] = 8.480707,
			[2] = 9.497042,
		},
		randomize_indexes = {},
	},
	mission_scavenge_briefing_two = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_commissar_a__mission_scavenge_briefing_two_01",
		},
		sound_events_duration = {
			[1] = 9.424313,
		},
		randomize_indexes = {},
	},
}

return settings("mission_briefing_commissar_a", mission_briefing_commissar_a)
