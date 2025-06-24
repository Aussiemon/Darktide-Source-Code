-- chunkname: @dialogues/generated/circumstance_vo_hunting_grounds_pilot_a.lua

local circumstance_vo_hunting_grounds_pilot_a = {
	hunting_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__hunting_circumstance_start_a_01",
			"loc_pilot_a__hunting_circumstance_start_a_02",
			"loc_pilot_a__hunting_circumstance_start_a_03",
			"loc_pilot_a__hunting_circumstance_start_a_04",
		},
		sound_events_duration = {
			4.432313,
			7.405917,
			5.700708,
			5.613375,
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

return settings("circumstance_vo_hunting_grounds_pilot_a", circumstance_vo_hunting_grounds_pilot_a)
