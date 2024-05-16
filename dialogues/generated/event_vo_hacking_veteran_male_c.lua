-- chunkname: @dialogues/generated/event_vo_hacking_veteran_male_c.lua

local event_vo_hacking_veteran_male_c = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_veteran_male_c__hacking_auspex_mutter_a_01",
			"loc_veteran_male_c__hacking_auspex_mutter_a_02",
			"loc_veteran_male_c__hacking_auspex_mutter_a_03",
			"loc_veteran_male_c__hacking_auspex_mutter_a_04",
			"loc_veteran_male_c__hacking_auspex_mutter_a_05",
		},
		sound_events_duration = {
			0.907635,
			0.560313,
			0.75299,
			1.110469,
			1.034396,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_c__response_to_hacking_fix_decode_01",
			[2] = "loc_veteran_male_c__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 1.349521,
			[2] = 2.382896,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_veteran_male_c", event_vo_hacking_veteran_male_c)
