-- chunkname: @dialogues/generated/event_vo_hacking_veteran_male_a.lua

local event_vo_hacking_veteran_male_a = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_veteran_male_a__hacking_auspex_mutter_a_01",
			"loc_veteran_male_a__hacking_auspex_mutter_a_02",
			"loc_veteran_male_a__hacking_auspex_mutter_a_03",
			"loc_veteran_male_a__hacking_auspex_mutter_a_04",
			"loc_veteran_male_a__hacking_auspex_mutter_a_05",
		},
		sound_events_duration = {
			0.9065,
			0.928458,
			0.928708,
			2.204479,
			1.806333,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_a__response_to_hacking_fix_decode_01",
			[2] = "loc_veteran_male_a__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 2.031167,
			[2] = 1.666563,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_veteran_male_a", event_vo_hacking_veteran_male_a)
