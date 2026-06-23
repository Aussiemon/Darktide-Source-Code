-- chunkname: @dialogues/generated/event_vo_hacking_cryptic_a.lua

local event_vo_hacking_cryptic_a = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_a__hacking_auspex_mutter_a_01",
			[2] = "loc_cryptic_a__hacking_auspex_mutter_a_02",
		},
		sound_events_duration = {
			[1] = 2.624719,
			[2] = 3.053094,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_a__response_to_hacking_fix_decode_01",
			[2] = "loc_cryptic_a__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 2.664615,
			[2] = 3.02726,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_cryptic_a", event_vo_hacking_cryptic_a)
