-- chunkname: @dialogues/generated/event_vo_hacking_ogryn_a.lua

local event_vo_hacking_ogryn_a = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_ogryn_a__hacking_auspex_mutter_a_01",
			"loc_ogryn_a__hacking_auspex_mutter_a_02",
			"loc_ogryn_a__hacking_auspex_mutter_a_03",
			"loc_ogryn_a__hacking_auspex_mutter_a_04",
			"loc_ogryn_a__hacking_auspex_mutter_a_05",
		},
		sound_events_duration = {
			2.686542,
			3.013146,
			2.672667,
			3.086396,
			2.065969,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_a__response_to_hacking_fix_decode_01",
			[2] = "loc_ogryn_a__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 1.245063,
			[2] = 1.416427,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_ogryn_a", event_vo_hacking_ogryn_a)
