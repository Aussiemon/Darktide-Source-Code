-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_tech_priest_a.lua

local circumstance_vo_hunting_grounds_tech_priest_a = {
	hunting_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__hunting_circumstance_start_a_01",
			"loc_tech_priest_a__hunting_circumstance_start_a_02",
			"loc_tech_priest_a__hunting_circumstance_start_a_03",
			"loc_tech_priest_a__hunting_circumstance_start_a_04",
		},
		sound_events_duration = {
			10.10104,
			9.502272,
			8.722021,
			12.26944,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	hunting_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__hunting_circumstance_start_b_01",
			"loc_tech_priest_a__hunting_circumstance_start_b_02",
			"loc_tech_priest_a__hunting_circumstance_start_b_03",
			"loc_tech_priest_a__hunting_circumstance_start_b_04",
		},
		sound_events_duration = {
			6.808667,
			5.277938,
			5.857188,
			5.306313,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_hunting_grounds_tech_priest_a", circumstance_vo_hunting_grounds_tech_priest_a)
