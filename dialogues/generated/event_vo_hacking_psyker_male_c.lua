-- chunkname: @dialogues/generated/event_vo_hacking_psyker_male_c.lua

local event_vo_hacking_psyker_male_c = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_psyker_male_c__hacking_auspex_mutter_a_01",
			"loc_psyker_male_c__hacking_auspex_mutter_a_02",
			"loc_psyker_male_c__hacking_auspex_mutter_a_03",
			"loc_psyker_male_c__hacking_auspex_mutter_a_04",
			"loc_psyker_male_c__hacking_auspex_mutter_a_05",
		},
		sound_events_duration = {
			2.006146,
			1.861052,
			1.873667,
			1.816885,
			1.192333,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_c__response_to_hacking_fix_decode_01",
			[2] = "loc_psyker_male_c__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 1.54775,
			[2] = 1.427656,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_psyker_male_c", event_vo_hacking_psyker_male_c)
