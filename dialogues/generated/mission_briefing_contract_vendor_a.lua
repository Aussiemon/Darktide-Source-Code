-- chunkname: @dialogues/generated/mission_briefing_contract_vendor_a.lua

local mission_briefing_contract_vendor_a = {
	mission_cartel_brief_one = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_contract_vendor_a__mission_cartel_brief_one_01",
		},
		sound_events_duration = {
			[1] = 3.45678,
		},
		randomize_indexes = {},
	},
	mission_cartel_brief_three = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_contract_vendor_a__mission_cartel_brief_three_01",
			"loc_contract_vendor_a__mission_cartel_brief_three_02",
			"loc_contract_vendor_a__mission_cartel_brief_three_03",
		},
		sound_events_duration = {
			3.45678,
			3.45678,
			3.45678,
		},
		randomize_indexes = {},
	},
	mission_cartel_brief_two = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_contract_vendor_a__mission_cartel_brief_two_01",
			[2] = "loc_contract_vendor_a__mission_cartel_brief_two_02",
		},
		sound_events_duration = {
			[1] = 3.45678,
			[2] = 3.45678,
		},
		randomize_indexes = {},
	},
	mission_enforcer_briefing_a = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_contract_vendor_a__mission_enforcer_briefing_a_01",
			"loc_contract_vendor_a__mission_enforcer_briefing_a_02",
			"loc_contract_vendor_a__mission_enforcer_briefing_a_03",
		},
		sound_events_duration = {
			3.45678,
			3.45678,
			3.45678,
		},
		randomize_indexes = {},
	},
	mission_enforcer_briefing_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_contract_vendor_a__mission_enforcer_briefing_b_01",
			"loc_contract_vendor_a__mission_enforcer_briefing_b_02",
			"loc_contract_vendor_a__mission_enforcer_briefing_b_03",
		},
		sound_events_duration = {
			3.45678,
			3.45678,
			3.45678,
		},
		randomize_indexes = {},
	},
	mission_stockpile_briefing_a = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_contract_vendor_a__mission_stockpile_briefing_a_01",
			"loc_contract_vendor_a__mission_stockpile_briefing_a_02",
			"loc_contract_vendor_a__mission_stockpile_briefing_b_01",
			"loc_contract_vendor_a__mission_stockpile_briefing_b_02",
			"loc_contract_vendor_a__mission_stockpile_briefing_c_01",
			"loc_contract_vendor_a__mission_stockpile_briefing_c_02",
		},
		sound_events_duration = {
			3.45678,
			3.45678,
			3.45678,
			3.45678,
			3.45678,
			3.45678,
		},
		randomize_indexes = {},
	},
}

return settings("mission_briefing_contract_vendor_a", mission_briefing_contract_vendor_a)
