-- chunkname: @dialogues/generated/conversations_core_pilot_a.lua

local conversations_core_pilot_a = {
	conversation_40k_lore_one_02 = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_pilot_a__conversation_40k_lore_one_02_01",
			"loc_pilot_a__conversation_40k_lore_one_02_02",
			"loc_pilot_a__conversation_40k_lore_one_02_03",
		},
		sound_events_duration = {
			3.617188,
			3.702229,
			5.392083,
		},
		randomize_indexes = {},
	},
	conversation_zealot_one_02 = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_pilot_a__conversation_zealot_one_02_01",
			[2] = "loc_pilot_a__conversation_zealot_one_02_02",
		},
		sound_events_duration = {
			[1] = 1.562729,
			[2] = 2.382771,
		},
		randomize_indexes = {},
	},
	conversation_zealot_three_02 = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_pilot_a__conversation_zealot_three_02_01",
			[2] = "loc_pilot_a__conversation_zealot_three_02_02",
		},
		sound_events_duration = {
			[1] = 2.233833,
			[2] = 4.932063,
		},
		randomize_indexes = {},
	},
	conversation_zealot_two_02 = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_pilot_a__conversation_zealot_two_02_01",
			[2] = "loc_pilot_a__conversation_zealot_two_02_02",
		},
		sound_events_duration = {
			[1] = 3.451021,
			[2] = 3.76075,
		},
		randomize_indexes = {},
	},
	eavesdropping = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_pilot_a__eavesdropping_01",
			"loc_pilot_a__eavesdropping_02",
			"loc_pilot_a__eavesdropping_03",
			"loc_pilot_a__eavesdropping_04",
			"loc_pilot_a__eavesdropping_05",
		},
		sound_events_duration = {
			2.773229,
			3.503729,
			2.435083,
			3.054688,
			2.737146,
		},
		randomize_indexes = {},
	},
}

return settings("conversations_core_pilot_a", conversations_core_pilot_a)
